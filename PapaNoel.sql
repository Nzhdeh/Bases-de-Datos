--use master 
--go
--drop database PapaNoel


create database PapaNoel
go
use PapaNoel
go

create table Personas
(
	DNI char(9) not null,
	Nombre varchar (15) not null,
	Telefono varchar (20) not null,
	FechaNacimiento date not null

	----------------------------------
	constraint PK_Personas primary key (DNI)
)
go

create table Rutas
(
	ID tinyint not null,
	Zona varchar (30) not null,

	----------------------------------
	constraint PK_Rutas primary key (ID)
)
go

create table Peticiones
(
	ID tinyint not null,
	EsAceptada char (2) not null,
	DNIPersonas char(9) not null,
	IDRutas tinyint not null,

	----------------------------------
	constraint PK_Peticiones primary key (ID),

	----------------------------------
	constraint FK_Peticiones_Personas foreign key (DNIPersonas) references Personas (DNI),
	constraint FK_Peticiones_Rutas foreign key (IDRutas) references Rutas (ID)
)
go

create table Acciones
(
	Codigo tinyint not null,
	Lugar varchar (30) not null,
	Descripcion varchar(50) not null,
	FechaHora datetime not null,

	----------------------------------
	constraint PK_Acciones primary key (Codigo)
)
go

create table Buenas
(
	CodigoAcciones tinyint not null,
	Recompensa varchar (30) not null,
	NombrePeriodico varchar (15) not null,
	----------------------------------
	constraint PK_Buenas primary key (CodigoAcciones),

	----------------------------------
	constraint FK_Acciones_Buenas foreign key (CodigoAcciones) references Acciones (Codigo)
)
go

create table Malas
(
	CodigoAcciones tinyint not null,
	Coste decimal (3,1) not null,
	Delito varchar (15) not null,
	----------------------------------
	constraint PK_Malas primary key (CodigoAcciones),

	----------------------------------
	constraint FK_Acciones_Malas foreign key (CodigoAcciones) references Acciones (Codigo)
)
go

create table Tiendas
(
	ID tinyint not null,
	Denominacion varchar (10) not null,
	Direccion varchar (30) not null,
	Telefono varchar (20) not null,

	----------------------------------
	constraint PK_Tiendas primary key (ID)
)
go

create table Pedidos
(
	ID tinyint not null,
	Fecha date not null,
	IDTienda tinyint not null,
	----------------------------------
	constraint PK_Pedido primary key (ID),

	----------------------------------
	constraint FK_Pedidos_Tiendas foreign key (IDTienda) references Tiendas (ID)
)
go