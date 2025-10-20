Sistema de Gestión de Turnos - Servicios LiMar
📋 Descripción del Proyecto
Este proyecto implementa un sistema de gestión y asignación de turnos para Servicios LiMar, diseñado para optimizar la administración de servicios ante la alta demanda de usuarios. El sistema permite el registro, organización y asignación eficiente de turnos a clientes, empleados, proveedores y cualquier persona que requiera acceder a los servicios ofrecidos por la entidad.
🎯 Objetivos

Automatizar el proceso de asignación de turnos mediante un sistema robusto y escalable
Gestionar el registro de usuarios con consideración a condiciones especiales
Facilitar la comunicación multicanal con los usuarios (correo, teléfono, SMS, etc.)
Proveer una solución normalizada basada en PostgreSQL v14
Implementar despliegue mediante contenedores Docker para garantizar portabilidad

🏗️ Arquitectura del Sistema
Componentes Principales

Motor de Base de Datos: PostgreSQL v14
Herramienta de Administración: pgAdmin 4
Modelo de Datos: Relacional normalizado (3FN)
Contenedorización: Docker

Modelo Entidad-Relación
El sistema implementa las siguientes entidades principales:

Usuario: Almacena información de clientes, empleados y proveedores
Ciudad: Gestiona ubicaciones geográficas y códigos postales
TipoUsuario: Categoriza los diferentes tipos de usuarios del sistema
MedioContacto: Define canales de comunicación disponibles
ContactoUsuario: Relaciona usuarios con sus medios de contacto
Servicio: Catálogo de servicios ofrecidos por la entidad
Empleado: Información laboral del personal
Turno: Registro de asignaciones de turnos
Notificacion: Historial de comunicaciones enviadas

🔐 Dependencias Funcionales
El diseño del sistema se fundamenta en las siguientes dependencias funcionales para garantizar la normalización:
usuario_id → nombre, apellido, tipo_usuario, condicion_especial, ciudad_id
ciudad_id → nombre_ciudad, codigo_postal
servicio_id → nombre, descripcion, estado
notificacion_id → usuario_id, medio_id, mensaje, fecha_envio, estado
🐳 Despliegue con Docker
Prerequisitos

Docker instalado (versión 20.10 o superior)
Conexión a Internet para descarga de imágenes

Paso 1: Despliegue del Motor de Base de Datos PostgreSQL
bashdocker run -d \
  --name postgres-limar \
  -e POSTGRES_USER=ulimar \
  -e POSTGRES_PASSWORD=ex4men_db \
  -e POSTGRES_DB=servilimar \
  -p 5432:5432 \
  postgres:14
Parámetros de configuración:

Usuario: ulimar
Contraseña: ex4men_db
Puerto: 5432
Base de datos inicial: servilimar

Paso 2: Despliegue de pgAdmin 4
bashdocker run -d \
  --name pgadmin-limar \
  -e PGADMIN_DEFAULT_EMAIL=usuario@servilimar.com \
  -e PGADMIN_DEFAULT_PASSWORD=limar#123 \
  -p 8080:80 \
  --link postgres-limar:postgres \
  dpage/pgadmin4
Credenciales de acceso:

Email: usuario@servilimar.com
Contraseña: limar#123
URL de acceso: http://localhost:8080

Paso 3: Configuración de la Conexión

Acceder a pgAdmin en http://localhost:8080
Iniciar sesión con las credenciales proporcionadas
Registrar servidor PostgreSQL:

Host: postgres (o postgres-limar)
Puerto: 5432
Usuario: ulimar
Contraseña: ex4men_db
Base de datos: servilimar



📊 Estructura de la Base de Datos
DDL (Data Definition Language)
El esquema de base de datos implementa 9 tablas normalizadas:
sql-- Tabla de Ciudades
CREATE TABLE Ciudad (
    ciudad_id SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL
);

-- Tabla de Tipos de Usuario
CREATE TABLE TipoUsuario (
    tipo_usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de Usuarios
CREATE TABLE Usuario (
    usuario_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_usuario_id INT NOT NULL,
    condicion_especial VARCHAR(200),
    ciudad_id INT NOT NULL,
    FOREIGN KEY (tipo_usuario_id) REFERENCES TipoUsuario(tipo_usuario_id),
    FOREIGN KEY (ciudad_id) REFERENCES Ciudad(ciudad_id)
);

-- Tabla de Medios de Contacto
CREATE TABLE MedioContacto (
    medio_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de Contactos de Usuario
CREATE TABLE ContactoUsuario (
    contacto_id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    medio_id INT NOT NULL,
    valor_contacto VARCHAR(200) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id),
    FOREIGN KEY (medio_id) REFERENCES MedioContacto(medio_id)
);

-- Tabla de Servicios
CREATE TABLE Servicio (
    servicio_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    estado VARCHAR(20) NOT NULL
);

-- Tabla de Empleados
CREATE TABLE Empleado (
    empleado_id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    departamento VARCHAR(100) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id)
);

-- Tabla de Turnos
CREATE TABLE Turno (
    turno_id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    servicio_id INT NOT NULL,
    empleado_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(20) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id),
    FOREIGN KEY (servicio_id) REFERENCES Servicio(servicio_id),
    FOREIGN KEY (empleado_id) REFERENCES Empleado(empleado_id)
);

-- Tabla de Notificaciones
CREATE TABLE Notificacion (
    notificacion_id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    medio_id INT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_envio TIMESTAMP NOT NULL,
    estado VARCHAR(20) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(usuario_id),
    FOREIGN KEY (medio_id) REFERENCES MedioContacto(medio_id)
);
```



### DML (Data Manipulation Language)

Se han insertado datos de prueba para validar la funcionalidad del sistema:

- **10 registros** por cada tabla
- **Datos representativos** de ciudades colombianas
- **Usuarios con diferentes condiciones especiales**
- **Turnos en estados variados** (Confirmado, Pendiente, Atendido)
- **Notificaciones enviadas** por múltiples medios



#### Resumen de Datos Insertados

| Tabla | Registros | Descripción |
|-------|-----------|-------------|
| Ciudad | 10 | Principales ciudades de Colombia |
| TipoUsuario | 10 | Categorías de usuarios del sistema |
| Usuario | 10 | Clientes, empleados y proveedores |
| MedioContacto | 10 | Canales de comunicación disponibles |
| ContactoUsuario | 10 | Información de contacto por usuario |
| Servicio | 10 | Servicios ofrecidos por LiMar |
| Empleado | 10 | Personal asignado a atención |
| Turno | 10 | Asignaciones de turnos programadas |
| Notificacion | 10 | Comunicaciones enviadas a usuarios |

## 🎥 Demostración en Video

El video de demostración incluye:

1. ✅ Comandos de despliegue de contenedores Docker
2. ✅ Acceso exitoso a pgAdmin 4
3. ✅ Conexión al servidor PostgreSQL
4. ✅ Creación de la base de datos `servilimar`
5. ✅ Ejecución de scripts DDL para crear tablas
6. ✅ Ejecución de scripts DML para insertar datos


## 📁 Estructura del Repositorio
```
   
🚀 Inicio Rápido
Opción 1: Comandos Individuales
bash# 1. Levantar PostgreSQL
docker run -d --name postgres-limar \
  -e POSTGRES_USER=ulimar \
  -e POSTGRES_PASSWORD=ex4men_db \
  -e POSTGRES_DB=servilimar \
  -p 5432:5432 postgres:14

2. Levantar pgAdmin
docker run -d --name pgadmin-limar \
  -e PGADMIN_DEFAULT_EMAIL=usuario@servilimar.com \
  -e PGADMIN_DEFAULT_PASSWORD=limar#123 \
  -p 8080:80 --link postgres-limar:postgres \
  dpage/pgadmin4

3. Acceder a pgAdmin
 Abrir navegador: http://localhost:8080

🛠️ Tecnologías Utilizadas

PostgreSQL 14: Sistema de gestión de base de datos relacional
pgAdmin 4: Herramienta de administración gráfica
Docker: Plataforma de contenedorización
SQL: Lenguaje de consulta estructurada

📚 Fundamentos Teóricos
Normalización
El diseño implementa la Tercera Forma Normal (3FN) para:

Eliminar redundancia de datos
Prevenir anomalías de inserción, actualización y eliminación
Optimizar el almacenamiento
Facilitar el mantenimiento

Integridad Referencial
Se garantiza mediante:

Claves primarias en todas las tablas
Claves foráneas para relaciones entre entidades
Restricciones NOT NULL en campos obligatorios
Tipos de datos apropiados según el dominio

👥 Funcionalidades del Sistema
Gestión de Usuarios

Registro con datos personales completos
Categorización por tipo de usuario
Registro de condiciones especiales
Asociación con ciudades y códigos postales

Gestión de Turnos

Asignación automática de turnos
Selección de servicios disponibles
Asignación de empleados responsables
Control de estados (Pendiente, Confirmado, Atendido, Cancelado)

Sistema de Notificaciones

Comunicaión mediante los medios
Registro histórico de notificaciones
Seguimiento de estados de envío
Personalización de mensajes



📝 Autor
Sebastian Orejuela Albornoz (2242232)
Examen parcial práctico I Base de Datos
Universidad [Nombre de la Universidad]
Año 2025


