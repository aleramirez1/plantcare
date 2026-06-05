import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/planta_entity.dart';
import '../viewmodels/plantas_viewmodel.dart';
import '../widgets/planta_image_picker_widget.dart';

class PlantaFormularioPage extends StatefulWidget {
  final PlantaEntity? planta;

  const PlantaFormularioPage({super.key, this.planta});

  @override
  State<PlantaFormularioPage> createState() => _PlantaFormularioPageState();
}

class _PlantaFormularioPageState extends State<PlantaFormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late TextEditingController _nombreController;
  late TextEditingController _especieController;
  late TextEditingController _tipoController;
  late TextEditingController _frecuenciaRiegoController;
  DateTime _fechaSiembra = DateTime.now();
  DateTime? _ultimoRiego;
  String _estadoSalud = 'bueno';
  File? _imageFile;
  String? _imageUrl;

  final List<String> _estadosSalud = ['bueno', 'regular', 'malo'];
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.planta != null;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.planta?.nombre ?? '');
    _especieController = TextEditingController(text: widget.planta?.especie ?? '');
    _tipoController = TextEditingController(text: widget.planta?.tipo ?? '');
    _frecuenciaRiegoController = TextEditingController(
      text: widget.planta?.frecuenciaRiego.toString() ?? '7'
    );
    
    if (widget.planta != null) {
      _fechaSiembra = widget.planta!.fechaSiembra;
      _ultimoRiego = widget.planta!.ultimoRiego;
      _estadoSalud = widget.planta!.estadoSalud;
      _imageUrl = widget.planta!.foto;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _especieController.dispose();
    _tipoController.dispose();
    _frecuenciaRiegoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camara'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFechaSiembra() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSiembra,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _fechaSiembra = picked;
      });
    }
  }

  Future<void> _selectUltimoRiego() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _ultimoRiego ?? DateTime.now(),
      firstDate: _fechaSiembra,
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _ultimoRiego = picked;
      });
    }
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (_nombreController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa el nombre')),
        );
        return;
      }
      if (_especieController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa la especie')),
        );
        return;
      }
      if (_tipoController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ingresa el tipo')),
        );
        return;
      }
    }
    
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final plantasViewmodel = context.read<PlantasViewmodel>();
    
    String? imagePath = _imageFile?.path ?? _imageUrl;
    
    final planta = PlantaEntity(
      id: widget.planta?.id ?? '',
      nombre: _nombreController.text,
      especie: _especieController.text,
      fechaSiembra: _fechaSiembra,
      tipo: _tipoController.text,
      frecuenciaRiego: int.parse(_frecuenciaRiegoController.text),
      ultimoRiego: _ultimoRiego,
      estadoSalud: _estadoSalud,
      ubicacion: '',
      foto: imagePath,
    );

    bool success;
    if (isEditing) {
      success = await plantasViewmodel.actualizarPlanta(planta);
    } else {
      success = await plantasViewmodel.agregarPlanta(planta);
    }

    if (success && mounted) {
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(plantasViewmodel.error ?? 'Error al guardar')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar planta' : 'Nueva planta'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / 2,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation(Colors.green[800]),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text('${_currentPage + 1}/2'),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  children: [
                    _buildPage1(),
                    _buildPage2(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousPage,
                          child: const Text('Anterior'),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    if (_currentPage < 1)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          child: const Text('Siguiente'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Informacion basica', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          PlantaImagePickerWidget(
            imageFile: _imageFile,
            imageUrl: _imageUrl,
            onTap: _showImagePicker,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _especieController,
            decoration: const InputDecoration(
              labelText: 'Especie',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tipoController,
            decoration: const InputDecoration(
              labelText: 'Tipo (ej: Ornamental, Frutal)',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cuidados', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ListTile(
            title: const Text('Fecha de siembra'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(_fechaSiembra)),
            trailing: const Icon(Icons.calendar_today),
            onTap: _selectFechaSiembra,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _frecuenciaRiegoController,
            decoration: const InputDecoration(
              labelText: 'Frecuencia de riego (dias)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) return 'Requerido';
              if (int.tryParse(value!) == null) return 'Numero invalido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Ultimo riego'),
            subtitle: Text(
              _ultimoRiego != null
                  ? DateFormat('dd/MM/yyyy').format(_ultimoRiego!)
                  : 'No registrado',
            ),
            trailing: const Icon(Icons.water_drop),
            onTap: _selectUltimoRiego,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _estadoSalud,
            decoration: const InputDecoration(
              labelText: 'Estado de salud',
              border: OutlineInputBorder(),
            ),
            items: _estadosSalud.map((estado) {
              return DropdownMenuItem(
                value: estado,
                child: Text(estado),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _estadoSalud = value);
              }
            },
          ),
        ],
      ),
    );
  }
}
