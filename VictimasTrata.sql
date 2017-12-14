
--use master
--go
--drop database VictimasTrata

create database VictimasTrata
go
use VictimasTrata


--la generalizacion hago tres tablas porque los subtipos tienen varias relaciones
create table Sicarios
(
	ID smallint not null,
	Nombre varchar (15) null,
	Apellidos varchar (20) null,

	----------------pk-----------
	constraint PK_Sicarios primary key (ID)
)
go

--el atributo apodo podria ser multievaluado
create table Apodos
(
	ID smallint not null,
	Apodo varchar (15) null,
	IDSicario smallint not null

	----------------pk-----------
	constraint PK_Apodos primary key (ID),

	-------fk-------------------
	constraint FK_Apodos_Sicarios foreign key (IDSicario) references Sicarios(ID) on delete cascade on update cascade
)
go

--puede tener varias nacionalidades i incluso falsas nacionalidades
create table Paises
(
	ID smallint not null,
	Nacionalidad varchar (15) not null,

	----------------pk-----------
	constraint PK_Paises primary key (ID)
)
go

create table SicariosPaises
(
	IDSicario smallint not null,
	IDPaises smallint not null,

	----------------pk-----------
	constraint PK_SicariosPaises primary key (IDPaises,IDSicario),

	-------fk-------------------
	constraint FK_Sicarios_Paises foreign key (IDSicario) references Sicarios(ID),
	constraint FK_Paises_Sicarios foreign key (IDPaises) references Paises(ID)
)
go

create table Matones
(
	IDSicario smallint not null,
	ArmaFavorita varchar (15) not null,

	----------------pk-----------
	constraint PK_Matones primary key (IDSicario),

	-------fk-------------------
	constraint FK_Matones_Sicarios foreign key (IDSicario) references Sicarios(ID) on delete cascade on update cascade
)
go

create table Ganchos
(
	IDSicario smallint not null,
	Idiomas varchar (15)  null,
	Niveles char (2) null,

	----------------pk-----------
	constraint PK_Ganchos primary key (IDSicario),

	-------fk-------------------
	constraint FK_Ganchos_Sicarios foreign key (IDSicario) references Sicarios(ID) on delete cascade on update cascade
)
go

create table Victimas
(
	ID smallint not null,
	Nombre varchar (15) null,
	Apellidos varchar (20) null,
	Nacionalidad varchar (15) null,--es pobre ,tiene una sola nacionalidad
	FechaNacimiento smalldatetime null,
	Raza varchar (15) null,

	----------------pk-----------
	constraint PK_Victimas primary key (ID)
)
go

create table CaracteristicasVictimas
(
	ID smallint not null,
	Estatura tinyint null,
	TallaRopa tinyint null,
	ColorPelo varchar (15) null,
	ContornoPecho tinyint null,
	IDVictimas smallint not null,

	----------------pk-----------
	constraint PK_CaracteristicasVictimas primary key (ID),
	constraint FK_Caracteristicas_Victimas foreign key (IDVictimas) references Victimas(ID) on delete cascade on update cascade
)
go

create table GanchosVictimas
(
	IDVictima smallint not null,
	IDSicarioGancho smallint not null,
	Promesa varchar (20) null,
	CantidadDebida int null,

	----------------pk-----------
	constraint PK_GanchosVictimas primary key (IDVictima),

	-------fk-------------------
	constraint FK_Ganchos_Victimas foreign key (IDSicarioGancho) references Ganchos(IDSicario) on delete cascade on update cascade,
	constraint FK_Victimas_Ganchos foreign key (IDVictima) references Victimas(ID) on delete cascade on update cascade
)
go

create table Lugares
(
	ID smallint not null,
	Denominacion varchar (20) null,
	Direccion varchar (40) null,

	----------------pk-----------
	constraint PK_Lugares primary key (ID)
)
go

create table MatonesVictimasLugares
(
	IDSicarioMaton smallint not null,
	IDVictima smallint not null,
	IDLugar smallint not null,
	Agresion varchar (15) null,

	----------------pk-----------
	constraint PK_MatonesVictimasLugares primary key (IDSicarioMaton,IDVictima),

	-------fk-------------------
	constraint FK_Matones_Victimas_Lugares foreign key (IDSicarioMaton) references Matones(IDSicario),
	constraint FK_Victimas_Matones_Lugares foreign key (IDVictima) references Victimas(ID),
	constraint FK_Lugares_Victimas_Matones foreign key (IDLugar) references Lugares(ID)
)
go

create table VictimasLugares
(
	IDVictima smallint not null,
	IDLugar smallint not null,
	FechaIngreso smalldatetime null,
	FechaSalida smalldatetime null,

	----------------pk-----------
	constraint PK_VictimasLugares primary key (IDVictima,IDLugar),

	-------fk-------------------
	constraint FK_Victimas_Lugares foreign key (IDVictima) references Victimas(ID),
	constraint FK_Lugares_Victimas foreign key (IDLugar) references Lugares(ID)
)
go

create table Familiares
(
	ID smallint not null,
	Nombre varchar (15) null,
	Apellidos varchar (20) null,
	Domicilio varchar (40) null,
	Parentesco varchar (15) null,
	IDVictima smallint not null,

	----------------pk-----------
	constraint PK_Familiares primary key (ID),

	-------fk-------------------
	constraint FK_Familiares_Victimas foreign key (IDVictima) references Victimas(ID) on delete cascade on update cascade
)
go

create table Servicios
(
	ID smallint not null,
	FechaHora datetime null,
	PracticaRealizada varchar (15) null,
	NombrePutero varchar (20) null,
	ImporteCobrado money null,
	IDVictima smallint not null,

	----------------pk-----------
	constraint PK_Servicios primary key (ID),

	-------fk-------------------
	constraint FK_Servicios_Victimas foreign key (IDVictima) references Victimas(ID) on delete cascade on update cascade
)
go

create table Medidas
(
	NumeroHabitacion smallint not null,
	Superficie smallint null,

	----------------pk-----------
	constraint PK_Medidas primary key (NumeroHabitacion)
)
go

create table Habitaciones
(
	NombreHotel char (20) not null,
	NumeroHabitacion smallint not null,
	Direccion varchar (40) null,
	IDServicio smallint not null unique,

	----------------pk-----------
	constraint PK_Habitaciones primary key (NombreHotel,NumeroHabitacion),

	-------fk-------------------
	constraint FK_Habitaciones_Servicios foreign key (IDServicio) references Servicios(ID) on delete cascade on update cascade,
	constraint FK_Habitaciones_Medidas foreign key (NumeroHabitacion) references Medidas(NumeroHabitacion) on delete cascade on update cascade
)
go

create table DineroServicios
(
	ID smallint not null,
	ImporteAbonado money null,
	ImporteVictima money null,
	IDServicio smallint not null unique,

	----------------pk-----------
	constraint PK_DineroServicios primary key (ID),

	-------fk-------------------
	constraint FK_Dinero_Servicios foreign key (IDServicio) references Servicios(ID) on delete cascade on update cascade
)
go









-----------------------CHECK----------------------
--alter table Victimas add constraint CK_EdadVivtima1 check ( year(Current_Timestamp) - year (FechaNacimiento)>18)
--go
alter table Victimas add constraint CK_EdadVivtima2 check ( year(Current_Timestamp - (FechaNacimiento)-1900)>18)
go
alter table CaracteristicasVictimas add constraint CK_TallaRopa check(TallaRopa between 36 and 46)
go
alter table VictimasLugares add constraint CK_FechaSalida check(FechaSalida>FechaIngreso )
go
alter table DineroServicios add constraint CK_ImporteVictima check(ImporteVictima<=(ImporteAbonado*0.2))
go








----Ejercicio 4
--se crea una relacion reflexiva N:M
create table SicariosESJefeSicario
(
	IDSicarioJefe smallint not null,
	IDSicarioSubordinado smallint not null,

	---------pk--------
	constraint PK_SicariosESJefeSicario primary key (IDSicarioJefe,IDSicarioSubordinado),

	-------fk-------------------
	constraint FK_Sicarios_ES_JefeSicario foreign key (IDSicarioJefe) references Sicarios(ID),
	constraint FK_Sicarios_ESJefeSicario foreign key (IDSicarioSubordinado) references Sicarios(ID)
)
go


----Ejercicio 5

create table Dinero
(
	ID smallint not null,
	IDFamiliar smallint not null,
	Importe money null,
	FechaEntrega smalldatetime null,
	IDVictima smallint not null,

	---------pk--------
	constraint PK_Dinero primary key (ID),

	-------fk-------------------
	constraint FK_Dinero_Victima foreign key (IDVictima) references Victimas(ID) on delete cascade on update cascade,
	constraint FK_Dinero_Familia foreign key (IDFamiliar) references Familiares(ID) on delete no action on update no action
)
go
