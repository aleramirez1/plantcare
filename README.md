# PlantCare

Aplicación móvil para gestión y cuidado de plantas.

## Características

- Login y Registro de usuarios
- CRUD completo de plantas
- Dashboard con filtros
- Calendario de riego
- Estadísticas con gráficos
- Perfil de usuario

## Tecnologías

- **Flutter** - Framework mobile
- **Provider** - Gestión de estado
- **http** - Cliente HTTP
- **Material Design 3** - UI/UX

## Arquitectura

- **MVVM** - Model-View-ViewModel
- **Clean Architecture** - Separación en capas
- **Vertical Slicing** - Features independientes
- **Manual DI** - Inyección de dependencias

## Instalación

```bash
flutter pub get
flutter run
```

## Estructura

```
lib/
├── core/
│   ├── config.dart
│   └── inyection_container.dart
├── feats/
│   ├── auth/
│   ├── plantas/
│   ├── dashboard/
│   ├── perfil/
│   ├── estadisticas/
│   ├── calendario/
│   ├── bienvenida/
│   └── navegacion/
└── main.dart
```

## Licencia

MIT
