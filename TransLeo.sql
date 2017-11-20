--use master 
--go
--drop database TransLeo

create database TransLeo
go
use TransLeo
go

create table Paquetes
(
	Codigo int not null,
	Alto tinyint not null,
	Ancho tinyint not null,
	Largo tinyint not null,
	Peso tinyint not null,

	---------------------------------------------------------
	constraint PK_Paquetes primary key (Codigo)
)
go
--es una generalizacion y he decidido hacer una sola tabla
create table ClientesRemitentesDestinatarios
(
	Codigo tinyint not null,
	Nombre varchar (20) not null,
	Apellidos varchar (40) not null,
	Tipo varchar (12) not null,
	Direccion varchar (80) not null,
	Ciudad  varchar (20) not null,
	CodigoPostal tinyint not null,
	Provincias varchar (20) not null,
	Telefono char (9) not null,
	TelefonoAlternativo char (9) null,
	NombreUsuario varchar (15) not null, 
	Contraseña varchar (10) not null,

	------Relacion Pemitentes Paquetes
	CodigoPaquetes int not null,
	NumReferencia int identity not null,

	------------------------------------------------------
	constraint PK_ClientesRemitentesDestinatarios primary key (Codigo)
)
go

create table Centros
(
	Codigo tinyint not null unique,
	Denominacion varchar (40) not null,
	Direccion varchar (80) not null,
	Ciudad varchar (20) not null,
	CodigoPostal tinyint not null,
	Provincia varchar (20) not null,
	Telefono char (9) not null,
	TelefonoAlternativo char (9) null,

	---------------------------------------------------------
	constraint PK_Centros primary key (Codigo)
)
go

create table Vehiculos
(
	Matricula char (7) not null,
	Tipo char (1) not null,
	FechaAdquisicion date not null,
	FechaMatriculacion date not  null,
	TipoCarnet char (3) not null,
	Capacidad tinyint not null,
	PesoMaximoTransportable smallint not null,

	---------------------------------------------------------
	constraint PK_Vehiculos primary key (Matricula)
)
go