--Sobre la base de Datos AdventureWorks

use AdventureWorks2012
go
--Nombre, numero de producto, precio y color de los productos de color rojo o amarillo cuyo precio esté comprendido entre 50 y 500
--select * from Production.Product
select Name,ProductNumber,ListPrice,Color from Production.Product
where Color in ('Red','Yellow') and StandardCost between 50 and 500

--Nombre, número de producto, precio de coste,  precio de venta, margen de beneficios total y margen de beneficios en % del precio 
--de venta de los productos de categorías inferiores a 16
--select * from Production.Product
select Name,ProductNumber,StandardCost,ListPrice,ListPrice-StandardCost as [Margen de Beneficios],(ListPrice-StandardCost)/StandardCost*100 as [Beneficios en %]  from Production.Product
where ProductSubcategoryID<16

--Empleados cuyo nombre o apellidos contenga la letra "r". Los empleados son los que tienen el valor "EM" en la columna PersonType de la tabla Person
select * from Person.Person
where  PersonType='EM' and (FirstName like ('%r%') or MiddleName  like ('%r%') or LastName  like ('%r%'))

--LoginID, nationalIDNumber, edad y puesto de trabajo (jobTitle) de los empleados (tabla Employees) de sexo femenino que tengan más de cinco años de antigüedad
select LoginID,NationalIDNumber,year(CURRENT_TIMESTAMP)-year(BirthDate) as [Edad],JobTitle from HumanResources.Employee
where Gender='F' and year(CURRENT_TIMESTAMP)-year(HireDate)>5

--Ciudades correspondientes a los estados 11, 14, 35 o 70, sin repetir. Usar la tabla Person.Address
select distinct City  from Person.[Address]
where StateProvinceID in (11,14,35,70)