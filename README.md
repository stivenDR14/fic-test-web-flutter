# FIC Investment Funds Web App

Una aplicación web desarrollada con Flutter para la gestión de fondos de inversión. Esta aplicación permite a los usuarios ver, suscribir y gestionar sus inversiones en diferentes fondos.

## 🚀 Requisitos Previos

- Flutter SDK (última versión estable)
- Node.js (para json-server)
- npm o yarn
- Un navegador web moderno
- Git

## 📦 Instalación

1. Clonar el repositorio:

```bash
git clone <repository-url>
cd fic-test-web-flutter
```

2. Instalar dependencias de Flutter:

```bash
flutter pub get
```

3. Generar archivos necesarios:

```bash
# Generar archivos de Freezed
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Instalar json-server globalmente:

```bash
npm install -g json-server
# o con yarn
yarn global add json-server
```

## 🔧 Configuración del Backend Mock

1. Iniciar json-server (asegúrate de estar en la raíz del proyecto):

```bash
json-server --watch db.json --port 3000
```

El servidor estará disponible en `http://localhost:3000`

## 🚀 Ejecutar la Aplicación

1. Para ejecutar la aplicación en modo web:

```bash
flutter run -d chrome
```

La aplicación estará disponible en `http://localhost:56014`

## 🏗️ Arquitectura del Proyecto

### Estructura de Carpetas

```
lib/
├── config/          # Configuración de la aplicación
│   ├── di/         # Inyección de dependencias
│   ├── router/     # Configuración de rutas
│   └── theme/      # Temas y estilos
├── core/           # Funcionalidades core y widgets compartidos
├── features/       # Módulos de la aplicación
└── shared/         # Código compartido entre features
```

### Características Principales

1. **Arquitectura Clean**

   - Separación clara de responsabilidades
   - Capas: Presentation, Domain, Data
   - Inversión de dependencias

2. **Gestión de Estado**

   - Utiliza Riverpod para la gestión de estado
   - Providers modulares y reutilizables

3. **Navegación**

   - Implementación de Navigator 2.0
   - Navegación declarativa

4. **Persistencia de Datos**

   - Almacenamiento local con WebStorage
   - Sincronización con backend mock (json-server)

5. **UI/UX**
   - Diseño responsive
   - Componentes reutilizables
   - Soporte para diferentes tamaños de pantalla, desde móvil hasta escritorio

### Módulos Principales

- **Funds**: Visualización y gestión de fondos de inversión
- **Subscription**: Proceso de suscripción a fondos
- **History**: Historial de transacciones
- **Shared**: Servicios compartidos y modelos de datos

## 🧪 Testing

Para ejecutar las pruebas:

```bash
flutter test
```

## 📱 Soporte de Dispositivos

La aplicación es completamente responsive y soporta:

- Navegadores web de escritorio
- Tablets
- Dispositivos móviles

---

# FIC Investment Funds Web App (English Version)

A web application developed with Flutter for investment fund management. This application allows users to view, subscribe to, and manage their investments in different funds.

## 🚀 Prerequisites

- Flutter SDK (latest stable version)
- Node.js (for json-server)
- npm or yarn
- A modern web browser
- Git

## 📦 Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd fic-test-web-flutter
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Generate required files:

```bash
# Generate Freezed files
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Install json-server globally:

```bash
npm install -g json-server
# or with yarn
yarn global add json-server
```

## 🔧 Mock Backend Configuration

1. Start json-server (make sure you're in the project root):

```bash
json-server --watch db.json --port 3000
```

The server will be available at `http://localhost:3000`

## 🚀 Running the Application

1. To run the application in web mode:

```bash
flutter run -d chrome
```

The application will be available at `http://localhost:56014`

## 🏗️ Project Architecture

### Folder Structure

```
lib/
├── config/          # Application configuration
│   ├── di/         # Dependency injection
│   ├── router/     # Route configuration
│   └── theme/      # Themes and styles
├── core/           # Core functionalities and shared widgets
├── features/       # Application modules
└── shared/         # Code shared between features
```

### Main Features

1. **Clean Architecture**

   - Clear separation of responsibilities
   - Layers: Presentation, Domain, Data
   - Dependency inversion

2. **State Management**

   - Uses Riverpod for state management
   - Modular and reusable providers

3. **Navigation**

   - Navigator 2.0 implementation
   - Declarative navigation

4. **Data Persistence**

   - Local storage with WebStorage
   - Synchronization with mock backend (json-server)

5. **UI/UX**
   - Responsive design
   - Reusable components
   - Support for different screen sizes, from mobile to desktop

### Main Modules

- **Funds**: Investment fund visualization and management
- **Subscription**: Fund subscription process
- **History**: Transaction history
- **Shared**: Shared services and data models

## 🧪 Testing

To run the tests:

```bash
flutter test
```

## 📱 Device Support

The application is fully responsive and supports:

- Desktop web browsers
- Tablets
- Mobile devices
