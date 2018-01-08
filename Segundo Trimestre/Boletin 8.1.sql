--Escribe el c�digo SQL necesario para realizar las siguientes operaciones sobre la base de datos "NorthWind�

use Northwind
go

--Consultas sobre una sola Tabla
--1. Nombre del pa�s y n�mero de clientes de cada pa�s, ordenados alfab�ticamente por el nombre del pa�s.
select Country, count (*) as [Numero de clientes] from Customers
group by Country
order by Country asc
go
--2. ID de producto y n�mero de unidades vendidas de cada producto. 
--select * from Products
select ProductID from Products/**************************************/
--3. ID del cliente y n�mero de pedidos que nos ha hecho.
--select * from Orders
select CustomerID,count(*) as [Numero de pedidos hechos] from Orders
group by CustomerID
go
--4. ID del cliente, a�o y n�mero de pedidos que nos ha hecho cada a�o.
select CustomerID,year(OrderDate) as [Anio],count(*) as [Numero de pedidos hechos cada a�o] from Orders
group by CustomerID,OrderDate
go
--5. ID del producto, precio unitario y total facturado de ese producto, ordenado por cantidad facturada de mayor a menor. 
--Si hay varios precios unitarios para el mismo producto tomaremos el mayor.
--select * from Products
select ProductID,max(UnitPrice) as [Precio mayor],sum(UnitPrice*UnitsInStock) as [Total facturado de ese producto] from Products
group by ProductID,UnitPrice						--duda
order by [Total facturado de ese producto] desc
go
--6. ID del proveedor e importe total del stock acumulado de productos correspondientes a ese proveedor.
select SupplierID,sum(UnitsInStock) as [Importe total por proveedor] from Products
group by SupplierID,UnitsInStock
go
--7. N�mero de pedidos registrados mes a mes de cada a�o.

--8. A�o y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado 
--(ShipDate), en d�as para cada a�o.

--9. ID del distribuidor y n�mero de pedidos enviados a trav�s de ese distribuidor.

--10. ID de cada proveedor y n�mero de productos distintos que nos suministra.