--Escribe las siguientes consultas sobre la base de datos NorthWind.
use Northwind
go

--Nombre de los proveedores y número de productos que nos vende cada uno
select S.CompanyName,count(P.ProductID) as [Número de productos vendidos por los proveedores] from Suppliers as S
inner join Products as P on S.SupplierID=P.SupplierID
group by S.CompanyName
go

--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
--select * from Suppliers
select LastName,FirstName ,HomePhone,City from Employees
where City in ('New York','Seattle','Vermont','Columbia','Los Angeles','Redmond','Atlanta')

--Número de productos de cada categoría y nombre de la categoría.


--Nombre de la compañía de todos los clientes que hayan comprado queso de cabrales o tofu.


--Empleados (ID, nombre, apellidos y teléfono) que han vendido algo a Bon app' o Meter Franken.


--Empleados (ID, nombre, apellidos, mes y día de su cumpleaños) que no han vendido nunca nada a ningún cliente de Francia. *


--Total de ventas en US$ de productos de cada categoría (nombre de la categoría).


--Total de ventas en US$ de cada empleado cada año (nombre, apellidos, dirección).


--Ventas de cada producto en el año 97. Nombre del producto y unidades.


--Cuál es el producto del que hemos vendido más unidades en cada país. *


--Empleados (nombre y apellidos) que trabajan a las órdenes de Andrew Fuller.


--Número de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.