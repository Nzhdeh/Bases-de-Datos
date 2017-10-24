--drop database Relacion_1N

create database Relacion_1N
go
use Relacion_1N
go

create table Lideres
(
	Dni char(9) not null,
	Nombre varchar(10) not null,
	Apellidos varchar(20) not null,
	Cargo varchar (10) not null,
	constraint PK_Lideres primary key (Dni),
)
go

create table Organizaciones
(
	Nombre varchar(20) not null,
	Campo_Actividad varchar(10) not null,
	Orientacion_Ideologica varchar(10) not null,
	DniLideres char(9) not null,
	constraint PK_Organizaciones primary key (Nombre),
	--usamos el metodo de propagacion de la clave primaria de la tabala LIDERES a la tabla ORGANIZACIONES
	constraint FK_Lideres_Organizaciones foreign key (DniLideres) references Lideres (Dni) on update cascade on delete cascade,
)
go