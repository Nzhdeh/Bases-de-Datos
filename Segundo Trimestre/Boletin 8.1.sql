--Escribe el código SQL necesario para realizar las siguientes operaciones sobre la base de datos "NorthWind”

use Northwind
go

--Consultas sobre una sola Tabla
--1. Nombre del país y número de clientes de cada país, ordenados alfabéticamente por el nombre del país.
select Country, count (*) as [Numero de clientes] from Customers
group by Country
order by Country asc
go
--2. ID de producto y número de unidades vendidas de cada producto. 
--select * from [Order Details]
select ProductID,count(Quantity) as [Número de unidades vendidas por producto] from [Order Details]
group by ProductID
go
--3. ID del cliente y número de pedidos que nos ha hecho.
--select * from Orders
select CustomerID,count(*) as [Numero de pedidos hechos] from Orders
group by CustomerID
go
--4. ID del cliente, año y número de pedidos que nos ha hecho cada año.
select CustomerID,year(OrderDate) as [Anio],count(*) as [Numero de pedidos hechos cada año] from Orders
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
--7. Número de pedidos registrados mes a mes de cada año.
--select * from Orders
select * from Orders/*****************************/
go
--8. Año y tiempo medio transcurrido entre la fecha de cada pedido (OrderDate) y la fecha en la que lo hemos enviado 
--(ShipDate), en días para cada año.
select day((OrderDate-ShippedDate)) from Orders/***************************************/
go
--9. ID del distribuidor y número de pedidos enviados a través de ese distribuidor.
select ShipVia,count(OrderID) as [Numero de pedidos enviados] from Orders
group by ShipVia
go
--10. ID de cada proveedor y número de productos distintos que nos suministra.
select SupplierID,count(ProductID) as [Numero de productos distintos suministrados] from Products--se puede poner distinct
group by SupplierID
go