--use master
--go
--drop database Bienal

create database Bienal
go
use Bienal
go

create table Empresas
(
	CIF char(9) not null,
	Nombres varchar (20) not null,
	Direcciones varchar (30) not null,

	--------------------------------
	constraint PK_Empresas primary key (CIF)
)
go

create table Trabajadores	------TipoTrabajo en la relacion
(
	DNI char(9) not null,
	Nombres varchar (15) not null,
	Apellidos varchar (20) not null,

	--------------------------------
	constraint PK_Trabajadores primary key (DNI)
)
go

create table Espectaculos    ----relacion 1:N flecha hacia funciones
(
	ID tinyint not null,--inventado

	--------------------------------
	constraint PK_Espectaculos primary key (ID)
)
go

create table Funciones
(
	ID tinyint not null,--inventado
	Fechas datetime not null,

	--------------------------------
	constraint PK_Funciones primary key (ID)
)
go

create table Representantes
(
	DNI char(9) not null,
	Nombres varchar (15) not null,
	Apellidos varchar (20) not null,
	Telefonos varchar(15) not null,
	--------------------------------
	constraint PK_Representantes primary key (DNI)
)
go

create table Artistas
(
	DNI char(9) not null,
	Nombres varchar (15) not null,
	Apellidos varchar (20) not null,
	Profecion varchar(15) not null,
	--------------------------------
	constraint PK_Artistas primary key (DNI)
)
go

create table Espacios
(
	ID char(9) not null,
	Nombres varchar (15) not null,
	Direcciones varchar (20) not null,
	Aforos tinyint not null,
	--------------------------------
	constraint PK_Espacios primary key (ID)
)
go

create table Zonas
(
	Filas tinyint not null,
	Asientos tinyint not null,
	
	--------------------------------
	constraint PK_Zonas primary key (Filas)
)
go

create table Localidades
(
	CodigoPostal char (5) not null,
	
	--------------------------------
	constraint PK_Localidades primary key (CodigoPostal)
)
go