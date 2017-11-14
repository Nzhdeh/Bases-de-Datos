--use master 
--go 
--drop database Ejemplos

create database Ejemplos
go 
use Ejemplos
go


--DatosRestrictivos. Columnas:
--ID Es un SmallInt autonum�rico que se rellenar� con n�meros impares.. No admite nulos. Clave primaria
--Nombre: Cadena de tama�o 15. No puede empezar por "N� ni por "X� A�ade una restiricci�n UNIQUE. No admite nulos
--Numpelos: Int con valores comprendidos entre 0 y 145.000
--TipoRopa: Car�cter con uno de los siguientes valores: "C�, "F�, "E�, "P�, "B�, �N�
--NumSuerte: TinyInt. Tiene que ser un n�mero divisible por 3.
--Minutos: TinyInt Con valores comprendidos entre 20 y 85 o entre 120 y 185.

create table DatosRestrictivos
(
	ID smallint identity not null,
	Nombre char (15) not null,
	NumPelos int null,
	TipoRopa char(1) null,
	Minutos tinyint null,

	----------------------------------
	constraint Pk_Datos_Restrictivos primary key (ID),

	-----------------------------------
	constraint UQ_Nombre unique (Nombre)
)
go
--DatosRelacionados. Columnas:
--NombreRelacionado: Cadena de tama�o 15. Define una FK para relacionarla con la columna "Nombre� de la tabla DatosRestrictivos.
--�Deber�amos poner la misma restricci�n que en la columna correspondiente?
--�Qu� ocurrir�a si la ponemos?
--�Y si no la ponemos?
--PalabraTabu: Cadena de longitud max 20. No admitir� los valores "Barcenas�, "Gurtel�, "P�nica�, "Bankia� ni "sobre�. Tampoco admitir� ninguna palabra terminada en "eo�
--NumRarito: TinyInt menor que 20. No admitir� n�meros primos.
--NumMasgrande: SmallInt. Valores comprendidos entre NumRarito y 1000. Definirlo como clave primaria.
--�Puede tener valores menores que 20?

create table DatosRelacionados
(
	NumMasgrande smallint not null,
	PalabraTabu varchar (20) null,
	NumRarito tinyint null,
	NombreRelacionado char (15) null,

	----------------------------------
	constraint PK_Datos_Relacionados primary key (NumMasgrande),

	-----------------------------------
	constraint FK_DatosRestrictivos_DatosRelacionados foreign key (NombreRelacionado) references DatosRestrictivos (Nombre) on update cascade on delete cascade
)
go



--DatosAlMogollon. Columnas:
--ID. SmallInt. No admitir� m�ltiplos de 5. Definirlo como PK
--LimiteSuperior. SmallInt comprendido entre 1500 y 2000.
--OtroNumero. Ser� mayor que el ID y Menor que LimiteSuperior. Poner UNIQUE
--NumeroQueVinoDelMasAlla: SmallInt FK relacionada con NumMasGrande de la tabla DatosRelacionados
--Etiqueta. Cadena de 3 caracteres. No puede tener los valores "pao�, "peo�, "pio� ni "puo�

create table DatosAlMogollon
(
	ID smallint not null,
	LimiteSuperior smallint null,
	OtroNumero tinyint null,
	Etiqueta char (3) null,
	NumeroQueVinoDelMasAlla smallint null,

	----------------------------------
	constraint PK_Datos_Al_Mogollon primary key (ID),

	-----------------------------------
	constraint FK_DatosAlMogollon_DatosRelacionados foreign key (NumeroQueVinoDelMasAlla) references DatosRelacionados (NumMasgrande) on update cascade on delete cascade,

	-------------------------------------
	constraint UQ_OtroNumero unique (OtroNumero)
)
go

--------------------restricciones check tabla DatosRestrictivos----------------------
alter table DatosRestrictivos add constraint CK_ID check (ID%2!=0)
go
--alter table DatosRestrictivos add constraint CK_Nombre check (like Nombre '[^NX]%')
