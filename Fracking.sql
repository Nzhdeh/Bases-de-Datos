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
	Extencion decimal (3,1) not null

	----------PK-------------------
	--constraint PK_Parcelas primary key (NumCatastral)
)
go
-------------------------------------------------------------------------------
alter table Parcelas add constraint PK_Parcelas primary key (NumCatastral)
go
-------------------------------------------------------------------------------

create table Asociaciones
(
	Nombre char (20) not null,
	Telefono char (12) not null

	----------PK-------------------
	--constraint PK_Asociaciones primary key (Nombre)
)
go
-------------------------------------------------------------------------------
alter table Asociaciones add constraint PK_Asociaciones primary key (Nombre)
go
-------------------------------------------------------------------------------

create table Propietarios
(
	DNI char(9) not null,
	Nombres varchar (15) not null,
	Apellidos varchar (20) not null,
	GradoDebilidad smallint not null

	----------PK-------------------
	--constraint PK_Propietarios primary key (DNI)
)
go
-------------------------------------------------------------------------------
alter table Propietarios add constraint PK_Propietarios primary key (DNI)
go
-------------------------------------------------------------------------------

create table Limites
(
	Longitud char(10) not null,
	Latitud char (10) not null,

	----------PK-------------------
	--constraint PK_Limites primary key (Longitud,Latitud)
)
go
-------------------------------------------------------------------------------
alter table Limites add constraint PK_Limites primary key (Longitud,Latitud)
go
-------------------------------------------------------------------------------

create table Espias
(
	Alias char(10) not null

	----------PK-------------------
	--constraint PK_Espias primary key (Alias)
)
go
-------------------------------------------------------------------------------
alter table Espias add constraint PK_Espias primary key (Alias)
go
-------------------------------------------------------------------------------

create table Actos
(
	ID tinyint not null,
	Lugar varchar(15) not null,
	Momento datetime not null,
	AliasEspias char(10) not null

	----------PK-------------------
	--constraint PK_Actos primary key (ID)
)
go
-------------------------------------------------------------------------------
alter table Actos add constraint PK_Actos primary key (ID)
go
-------------------------------------------------------------------------------

create table Instituciones
(
	Nombres char(15) not null,
	CodigoPostal tinyint not null

	----------PK-------------------
	--constraint PK_Instituciones primary key (Nombres,CodigoPostal)
)
go
-------------------------------------------------------------------------------
alter table Instituciones add constraint PK_Instituciones primary key (Nombres,CodigoPostal)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table Actos add constraint FK_Actos_Espias foreign key (AliasEspias) references Espias(Alias) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table Politicos
(
	Codigo tinyint not null,  ------codigo de politico
	Nombres varchar(15) not null,
	Apellidos varchar(20) not null,
	Direcciones varchar (30) not null,
	Categoria varchar not null,
	NombresInstituciones char(15) not null,
	CodigoPostalInstituciones tinyint not null

	----------PK-------------------
	--constraint PK_Politicos primary key (Codigo)
)
go
-------------------------------------------------------------------------------
alter table Politicos add constraint PK_Politicos primary key (Codigo)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table Politicos add constraint FK_Politicos_Institucion foreign key (NombresInstituciones,CodigoPostalInstituciones) references Instituciones(Nombres,CodigoPostal) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table Informaciones
(
	ID tinyint not null,
	PuntosDebiles varchar(15) not null

	----------PK-------------------
	--constraint PK_Informaciones primary key ()
)
go
-------------------------------------------------------------------------------
alter table Informaciones add constraint PK_Informaciones primary key (ID)
go
-------------------------------------------------------------------------------

/************************************************************/

create table ParcelasLimites
(
	NumCatastralParcelas tinyint not null,
	LongitudLimites char(10) not null,
	LatitudLimites char (10) not null
)
go
-------------------------------------------------------------------------------
alter table ParcelasLimites add constraint PK_ParcelasLimites primary key (NumCatastralParcelas,LongitudLimites,LatitudLimites)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table ParcelasLimites add constraint FK_Parcelas_Limites foreign key (NumCatastralParcelas) references Parcelas(NumCatastral) on update cascade on delete cascade
go
alter table ParcelasLimites add constraint FK_Limites_Parcelas foreign key (LongitudLimites,LatitudLimites) references Limites(Longitud,Latitud) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table ParcelasAsociaciones
(
	NumCatastralParcelas tinyint not null,
	NombresAsociaciones char (20) not null
)
go
-------------------------------------------------------------------------------
alter table ParcelasAsociaciones add constraint PK_ParcelasAsociaciones primary key (NumCatastralParcelas,NombresAsociaciones)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table ParcelasAsociaciones add constraint FK_Parcelas_Asociaciones foreign key (NumCatastralParcelas) references Parcelas(NumCatastral) on update cascade on delete cascade
go
alter table ParcelasAsociaciones add constraint FK_Asociaciones_Parcelas foreign key (NombresAsociaciones) references Asociaciones(Nombre) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table ParcelasInstituciones
(
	NumCatastralParcelas tinyint not null,
	NombresInstituciones char(15) not null,
	CodigoPostalInstituciones tinyint not null
)
go
-------------------------------------------------------------------------------
alter table ParcelasInstituciones add constraint PK_ParcelasInstituciones primary key (NumCatastralParcelas,NombresInstituciones,CodigoPostalInstituciones)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table ParcelasInstituciones add constraint FK_Parcelas_Instituciones foreign key (NumCatastralParcelas) references Parcelas(NumCatastral) on update cascade on delete cascade
go
alter table ParcelasInstituciones add constraint FK_Instituciones_Parcelas foreign key (NombresInstituciones,CodigoPostalInstituciones) references Instituciones(Nombres,CodigoPostal) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table ParcelasPropietarios
(
	NumCatastralParcelas tinyint not null,
	DNIPropietarios char(9) not null
)
go
-------------------------------------------------------------------------------
alter table ParcelasPropietarios add constraint PK_ParcelasPropietarios primary key (NumCatastralParcelas,DNIPropietarios)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table ParcelasPropietarios add constraint FK_Parcelas_Propietarios foreign key (NumCatastralParcelas) references Parcelas(NumCatastral) on update cascade on delete cascade
go
alter table ParcelasPropietarios add constraint FK_Propietarios_Parcelas foreign key (DNIPropietarios) references Propietarios(DNI) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table AsociacionesActos
(
	NombresAsociaciones char (20) not null,
	IDActos tinyint not null
)
go
-------------------------------------------------------------------------------
alter table AsociacionesActos add constraint PK_AsociacionesActos primary key (NombresAsociaciones,IDActos)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table AsociacionesActos add constraint FK_Asociaciones_Actos foreign key (NombresAsociaciones) references Asociaciones(Nombre) on update cascade on delete cascade
go
alter table AsociacionesActos add constraint FK_Actos_Asociaciones foreign key (IDActos) references Actos(ID) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table PoliticosActos
(
	IDActos tinyint not null,
	CodigoPoliticos tinyint not null,
	Participacion char(2) not null--si o no
)
go
-------------------------------------------------------------------------------
alter table PoliticosActos add constraint PK_PoliticosActos primary key (IDActos,CodigoPoliticos)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table PoliticosActos add constraint FK_Actos_Politicos foreign key (IDActos) references Actos(ID) on update cascade on delete cascade
go
alter table PoliticosActos add constraint FK_Politicos_Actos foreign key (CodigoPoliticos) references Politicos(Codigo) on update cascade on delete cascade
go
-------------------------------------------------------------------------------

create table PoliticosInformacion
(
	CodigoPoliticos tinyint not null,
	IDInformaciones tinyint not null
)
go
-------------------------------------------------------------------------------
alter table PoliticosInformacion add constraint PK_PoliticosInformacion primary key (CodigoPoliticos,IDInformaciones)
go
-------------------------------------------------------------------------------
-------------------------------------FK's--------------------------------------
alter table PoliticosInformacion add constraint FK_Politicos_Informacion foreign key (CodigoPoliticos) references Politicos(Codigo) on update cascade on delete cascade
go
alter table PoliticosInformacion add constraint FK_Informacion_Politicos foreign key (IDInformaciones) references Informaciones(ID) on update cascade on delete cascade
go
-------------------------------------------------------------------------------
