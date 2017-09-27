--drop database RelacionTernaria

create database RelacionTernaria
go
use RelacionTernaria
go

create table Pasajero
(
	DNI char(9) not null primary key,
	Nombre varchar(20) not null,
	Apellido varchar(30) not null,
	Direccion varchar (50) not null,
	Telefono char (9) not null,
)

go

create table Asiento
(
	Fila tinyint not null,
	Numero tinyint not null,
	constraint PK_Asiento primary key(Fila,Numero),--dos PKs en una misma tabla
)
go

create table Vuelo
(
	Codigo tinyint not null primary key,
	Origen varchar(40) not null,
	Destino varchar(40) not null,
)

go

create table PasajeroAsiento
(
	DNI char(9) not null,
	Fila tinyint not null,
	Numero tinyint not null,
	constraint PK_PasajeroAsiento primary key(DNI,Fila,Numero),
	constraint Pasajero_Asiento1 foreign key (DNI) references Pasajero (DNI) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint Pasajero_Asiento2 foreign key (Fila,Numero) references Asiento (Fila,Numero) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

create table PasajeroVuelo
(
	DNI char(9) not null,
	Codigo tinyint not null
	constraint PK_PasajeroVuelo primary key(DNI,Codigo),
	constraint Pasajero_Vuelo1 foreign key (DNI) references Pasajero (DNI) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint Pasajero_Vuelo2 foreign key (Codigo) references Vuelo (Codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go

create table VueloAsiento
(
	Codigo tinyint not null,
	Fila tinyint not null,
	Numero tinyint not null,
	constraint PK_VueloAsiento primary key(Codigo,Fila,Numero),
	constraint Vuelo_Asiento1 foreign key (Codigo) references Vuelo (Codigo) ON DELETE NO ACTION ON UPDATE CASCADE,
	constraint Vuelo_Asiento2 foreign key (Fila,Numero) references Asiento (Fila,Numero) ON DELETE NO ACTION ON UPDATE CASCADE,
)

go