-- Tabla de Ciudades
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
CREATE TABLE Medio(
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