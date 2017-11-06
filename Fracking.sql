--use master
--go
--drop database Fracking

create database Fracking
go 
use Fracking
go

create table Parcelas
(
	NumCatastral tinyint not null,
	Extencion decimal (3,1) not null,

	----------PK-------------------
	constraint PK_Parcelas primary key (NumCatastral)
)
go

create table Asociaciones
(
	Nombre char (20) not null,
	Telefono char (12) not null,

	----------PK-------------------
	constraint PK_Asociaciones primary key (Nombre)
)
go

create table Propietarios
(
	DNI char(9) not null,
	Nombres varchar (15) not null,
	Apellidos varchar (20) not null,
	GradoDebilidad smallint not null,

	----------PK-------------------
	constraint PK_Propietarios primary key (DNI)
)
go

create table Limites
(
	Longitud char(10) not null,
	Latitud char (10) not null,

	----------PK-------------------
	constraint PK_Limites primary key (Longitud,Latitud)
)
go

create table Espias
(
	Alias char(10) not null,

	----------PK-------------------
	constraint PK_Espias primary key (Alias)
)
go

create table Actos
(
	ID tinyint not null,
	Lugar varchar(15) not null,
	Momento datetime not null,

	----------PK-------------------
	constraint PK_Actos primary key (ID)
)
go