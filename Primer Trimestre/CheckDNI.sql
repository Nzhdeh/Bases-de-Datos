--use master
--go
--drop database CheckDNI

create database CheckDNI
go
use CheckDNI
go

create table Persona
(
	DNI char (9) not null,
	Telefono char (9) null,
	Email varchar (30) null,

	-----------------PK-----------------------------
	constraint PK_Persona primary key (DNI),

	-----------------CK------------------------------------------
	constraint CK_CK_DNI check (DNI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')
)
go

--alter table Persona add constraint CK_DNI check (DNI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][A-Z]')
--go

alter table Persona add constraint CK_Telefono check (Telefono like '[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
go

alter table Persona add constraint CK_Email check (Email like '%@%.%')
go

insert into Persona 
	   (DNI,Telefono,Email)
values ('22446678E','899999299','nzhdeh1991@gmail.com')
go

--insert into Persona 
-- 	     (DNI,Telefono,Email)
--values ('22446678J','89999929','nzhdeh1991gmail.com')	--caso de error
--go

--insert into Persona 
-- 	     (DNI,Telefono,Email)
--values ('22446678J','899999293','nzhdeh1991gmail.com')	--caso de error
--go

select * from Persona