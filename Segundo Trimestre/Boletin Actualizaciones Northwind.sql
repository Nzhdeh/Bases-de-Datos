--Usa la base de datos NorthWind
use Northwind
go

set dateformat ymd
--1. Inserta un nuevo cliente.
select * from Customers
insert into Customers
(CustomerID,CompanyName,ContactName,ContactTitle,[Address],City,Region,PostalCode,Country,Phone,Fax)
values('NAZIS','National Zinc Poison','Adolf Hitler','Second World War','In the Sky','Berlin',null,41019,'Germany','666666666','null')
go

--2. V�ndele (hoy) tres unidades de "Pavlova�, diez de "Inlagd Sill� y 25 de "Filo Mix�. 
--El transportista ser� Speedy Express y el vendedor Laura Callahan.
select * from Products
where ProductName in ('Pavlova','Inlagd Sill','Filo Mix')

select * from Shippers
where CompanyName='Speedy Express'

select * from Employees
where LastName='Callahan' and FirstName='Laura'
go
begin transaction

insert into [dbo].[Orders]
           ([CustomerID]
           ,[EmployeeID]
           ,[OrderDate]
           ,[RequiredDate]
           ,[ShippedDate]
           ,[ShipVia]
           ,[Freight]
           ,[ShipName]
           ,[ShipAddress]
           ,[ShipCity]
           ,[ShipRegion]
           ,[ShipPostalCode]
           ,[ShipCountry])
values('NAZIS',8,getdate(),getdate(),getdate(),1,33.25,'Disco disco Partizani','In the Sky','Berlin','GER',41019,'Germany'),
	  ('NAZIS',8,getdate(),getdate(),getdate(),1,25.25,'Disco disco Partizani','In the Sky','Berlin','GER',41019,'Germany'),
	  ('NAZIS',8,getdate(),getdate(),getdate(),1,15.15,'Disco disco Partizani','In the Sky','Berlin','GER',41019,'Germany')
go

--commit
rollback

select * from [Order Details]

insert into [dbo].[Order Details]
           ([OrderID]
           ,[ProductID]
           ,[UnitPrice]
           ,[Quantity]
           ,[Discount])
values (11080,16,17.45,3,0)


insert into [Order Details]
select 11081,P.ProductID,P.UnitPrice,10,0 from Products as P
where P.ProductName='Inlagd Sill'

insert into [Order Details]
select 11082,P.ProductID,P.UnitPrice,25,0 from Products as P
where P.ProductName='Filo Mix'

--3. Ante la bajada de ventas producida por la crisis, hemos de adaptar nuestros precios
-- seg�n las siguientes reglas:

--	1. Los productos de la categor�a de bebidas (Beverages) que cuesten m�s de $10 reducen su 
--	precio en un d�lar.
select * from Products as P
inner join Categories as C on P.CategoryID=C.CategoryID
where CategoryName='Beverages' and UnitPrice>10

begin transaction 
	
	update Products
		set UnitPrice=UnitPrice-1
	where ProductID in
					(
						select P.ProductID from Products as P
						inner join Categories as C on P.CategoryID=C.CategoryID
						where CategoryName='Beverages' and UnitPrice>10
					)
--commit
rollback
--	2. Los productos de la categor�a L�cteos que cuesten m�s de $5 reducen su precio en un 10%.
select * from Products as P
inner join Categories as C on P.CategoryID=C.CategoryID
where CategoryName='Dairy Products' and UnitPrice>5

begin transaction 
	update Products
			set UnitPrice=UnitPrice-(UnitPrice*0.1)
		where ProductID in
						(
							select P.ProductID from Products as P
							inner join Categories as C on P.CategoryID=C.CategoryID
							where CategoryName='Dairy Products' and UnitPrice>5
						)
--commit
rollback

select * from Categories
--	3. Los productos de los que se hayan vendido menos de 200 unidades en el �ltimo a�o, reducen 
--	su precio en un 5%
select P.ProductID,P.ProductName,count(OD.OrderID)  as Cantidad,P.UnitPrice from Products as P
inner join [Order Details] as OD on P.ProductID=OD.ProductID
group by P.ProductID,P.ProductName,P.UnitPrice
having count(OD.OrderID)<200

begin transaction 
	update Products
			set UnitPrice=UnitPrice-(UnitPrice*0.05)
		where ProductID in
						(
							select P.ProductID from Products as P
							inner join [Order Details] as OD on P.ProductID=OD.ProductID
							group by P.ProductID,P.ProductName
							having count(OD.OrderID)<200
						)
--commit
rollback

set dateformat ymd
--4. Inserta un nuevo vendedor llamado Michael Trump. As�gnale los territorios de Louisville, 
--Phoenix, Santa Cruz y Atlanta.
select * from Employees

insert into Employees
(LastName,FirstName,Title,TitleOfCourtesy,BirthDate,HireDate,[Address],City,Region,PostalCode,Country,HomePhone,Extension,Photo,Notes,ReportsTo,PhotoPath)
values('Trump','Michael','Sales Manager','Mr','1959-12-12 00:00:00:000','1979-12-24 00:00:00:000','Calle cucuruc� 9','New york',null,null,'USA','(206) 555-9456',3547,null,null,5,null)

select TerritoryID from Territories
where TerritoryDescription in ('Louisville','Phoenix','Santa Cruz','Atlanta')

insert into [dbo].[EmployeeTerritories]
           ([EmployeeID]
           ,[TerritoryID])
select 11 as [EmployeeID],TerritoryID from Territories
where TerritoryDescription in ('Louisville','Phoenix','Santa Cruz','Atlanta')
go

--select * from EmployeeTerritories ET JOIN Territories T ON ET.TerritoryID = T.TerritoryID
--Where ET.EmployeeID = 11 

--5. Haz que las ventas del a�o 97 de Robert King que haya hecho a clientes de los estados de 
--California y Texas se le asignen al nuevo empleado.
select * from Customers as C
inner join Orders as O on C.CustomerID=O.CustomerID
inner join Employees as E on O.EmployeeID=E.EmployeeID
where E.FirstName='Robert' and E.LastName='King' and year(O.OrderDate)=1997 and C.Region in ('CA','TX')
go

begin transaction
	update Orders
		set CustomerID =11
		where CustomerID in (select C.CustomerID from Customers as C
								inner join Orders as O on C.CustomerID=O.CustomerID
								inner join Employees as E on O.EmployeeID=E.EmployeeID
								where E.FirstName='Robert' and E.LastName='King' and year(O.OrderDate)=1997 and C.Region in ('CA','TX'))
--commit
rollback
go

--6. Inserta un nuevo producto con los siguientes datos:
--	ProductID: 90
--	ProductName: Nesquick Power Max
--	SupplierID: 12
--	CategoryID: 3
--	QuantityPerUnit: 10 x 300g
--	UnitPrice: 2,40
--	UnitsInStock: 38
--	UnitsOnOrder: 0
--	ReorderLevel: 0
--	Discontinued: 0

--SET IDENTITY_INSERT Products ON  --para desactivar el identity temporalmente
--SET IDENTITY_INSERT Products OFF	--para volver a activarlo

INSERT INTO [dbo].[Products]
           ([ProductID]
		   ,[ProductName]
           ,[SupplierID]
           ,[CategoryID]
           ,[QuantityPerUnit]
           ,[UnitPrice]
           ,[UnitsInStock]
           ,[UnitsOnOrder]
           ,[ReorderLevel]
           ,[Discontinued])
     VALUES
           (90,'Nesquick Power Max',12,3,'10 x 300g',2.40,38,0,0,0)
GO
select * from Products

--7. Inserta un nuevo producto con los siguientes datos:
--	ProductID: 91
--	ProductName: Mecca Cola
--	SupplierID: 1
--	CategoryID: 1
--	QuantityPerUnit: 6 x 75 cl
--	UnitPrice: 7,35
--	UnitsInStock: 14
--	UnitsOnOrder: 0
--	ReorderLevel: 0
--	Discontinued: 0

insert into [dbo].[Products]
           ([ProductName]
           ,[SupplierID]
           ,[CategoryID]
           ,[QuantityPerUnit]
           ,[UnitPrice]
           ,[UnitsInStock]
           ,[UnitsOnOrder]
           ,[ReorderLevel]
           ,[Discontinued])
     values
           ('Mecca Cola',1,1,'6 x 75 cl',7.35,14,0,0,0)
GO


--8. Todos los que han comprado "Outback Lager" han comprado cinco a�os despu�s la misma cantidad de 
--Mecca Cola al mismo vendedor
begin transaction
insert into Orders
select VentasOutbackLager.CustomerID,VentasOutbackLager.EmployeeID,dateadd(year,5,VentasOutbackLager.OrderDate),VentasOutbackLager.RequiredDate,VentasOutbackLager.ShippedDate,VentasOutbackLager.ShipVia,VentasOutbackLager.Freight,VentasOutbackLager.ShipName,VentasOutbackLager.ShipAddress,VentasOutbackLager.ShipCity,VentasOutbackLager.ShipRegion,VentasOutbackLager.ShipPostalCode,VentasOutbackLager.ShipCountry
from(
select O.CustomerID,O.EmployeeID,O.RequiredDate,O.ShippedDate,O.ShipVia,O.Freight,O.ShipName,O.ShipAddress,O.ShipCity,O.ShipRegion,O.ShipPostalCode,O.ShipCountry,sum(OD.Quantity) as Cantidad,O.OrderDate
from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
inner join Products as P on OD.ProductID=P.ProductID
where P.ProductName='Outback Lager'
group by O.CustomerID,O.EmployeeID,O.OrderDate,O.RequiredDate,O.ShippedDate,O.ShipVia,O.Freight,O.ShipName,O.ShipAddress,O.ShipCity,O.ShipRegion,O.ShipPostalCode,O.ShipCountry
--ORDER BY O.CustomerID
) as VentasOutbackLager
--commit
rollback

--9. El pasado 20 de enero, Margaret Peacock consigui� vender una caja de Nesquick Power Max a todos 
--los clientes que le hab�an comprado algo anteriormente. Los datos de env�o (direcci�n, transportista, etc) 
--son los mismos de alguna de sus ventas anteriores a ese cliente).
go
create view VentasNesquick20Enero as 
select O.OrderID,O.CustomerID,O.EmployeeID,O.OrderDate,O.RequiredDate,O.ShippedDate,O.ShipVia,O.Freight,O.ShipName,O.ShipAddress,O.ShipCity,O.ShipRegion,O.ShipPostalCode,O.ShipCountry
from Orders as O
inner join Employees as E on O.EmployeeID=E.EmployeeID
where E.FirstName='Margaret' and E.LastName='Peacock'

go

begin transaction
insert into [dbo].[Orders]
select CustomerID,[EmployeeID]
           ,'2017-01-20 00:00:00.000'
           ,'2017-01-20 00:00:00.000'
           ,'2017-01-20 00:00:00.000'
           ,[ShipVia]
           ,[Freight]
           ,[ShipName]
           ,[ShipAddress]
           ,[ShipCity]
           ,[ShipRegion]
           ,[ShipPostalCode]
           ,[ShipCountry]
from VentasMargaret
--rollback
select * from Orders
select * from [Order Details]
go
insert into [Order Details]
select VentasMargaret.OrderID,90,2.40,1,0.0
from VentasMargaret