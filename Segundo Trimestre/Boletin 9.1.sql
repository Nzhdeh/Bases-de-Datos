--Escribe las siguientes consultas sobre la base de datos NorthWind.
use Northwind
go

--Nombre de los proveedores y n�mero de productos que nos vende cada uno
select S.CompanyName,count(P.ProductID) as [N�mero de productos vendidos por los proveedores] from Suppliers as S
inner join Products as P on S.SupplierID=P.SupplierID
group by S.CompanyName
go

--Nombre completo y telefono de los vendedores que trabajen en New York, Seattle, Vermont, Columbia, Los Angeles, Redmond o Atlanta.
--select * from Suppliers
select LastName,FirstName ,HomePhone,City from Employees
where City in ('New York','Seattle','Vermont','Columbia','Los Angeles','Redmond','Atlanta')

--N�mero de productos de cada categor�a y nombre de la categor�a.


--Nombre de la compa��a de todos los clientes que hayan comprado queso de cabrales o tofu.


--Empleados (ID, nombre, apellidos y tel�fono) que han vendido algo a Bon app' o Meter Franken.


--Empleados (ID, nombre, apellidos, mes y d�a de su cumplea�os) que no han vendido nunca nada a ning�n cliente de Francia. *


--Total de ventas en US$ de productos de cada categor�a (nombre de la categor�a).


--Total de ventas en US$ de cada empleado cada a�o (nombre, apellidos, direcci�n).


--Ventas de cada producto en el a�o 97. Nombre del producto y unidades.


--Cu�l es el producto del que hemos vendido m�s unidades en cada pa�s. *


--Empleados (nombre y apellidos) que trabajan a las �rdenes de Andrew Fuller.


--N�mero de subordinados que tiene cada empleado, incluyendo los que no tienen ninguno. Nombre, apellidos, ID.