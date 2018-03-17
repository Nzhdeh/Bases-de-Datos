use Northwind
go

--1. Deseamos incluir un producto en la tabla Products llamado "Cruzcampo lata” pero no estamos seguros si se ha insertado o no.
--El precio son 4,40, el proveedor es el 16, la categoría 1 y la cantidad por unidad es "Pack 6 latas” "Discontinued” 
--toma el valor 0 y el resto de columnas se dejarán a NULL.
--Escribe un script que compruebe si existe un producto con ese nombre. En caso afirmativo, 
--actualizará el precio y en caso negativo insertarlo. 


--SET IDENTITY_INSERT Products ON  --para desactivar el identity temporalmente
--SET IDENTITY_INSERT Products OFF	--para volver a activarlo

begin transaction

 if exists (select * from Products
			where ProductName='Cruzcampo lata')
		begin
			update Products
			set UnitPrice=4.40
			where ProductName='Cruzcampo lata'
		end
else
	begin
		print 'El producto no existe, vamo a crearlo'
		insert into Products
		(ProductID,ProductName,SupplierID,CategoryID,QuantityPerUnit,UnitPrice,UnitsInStock,UnitsOnOrder,ReorderLevel,Discontinued)
		values(92,'Cruzcampo lata',16,1,'Pack 6 latas',4.40,null,null,null,0)
	end

rollback
select * from Products
--2. Comprueba si existe una tabla llamada ProductSales. Esta tabla ha de tener de cada producto el ID, el Nombre, 
--el Precio unitario, el número total de unidades vendidas y el total de dinero facturado con ese producto. Si no existe, créala

begin transaction

if exists (select * from SYSOBJECTS where type='U' and name='ProductSales')
	begin 
		print 'La tabla ya esta creada'
	end 

else

	begin 
		create table ProductSales
		(
			IDProducto int not null,
			NombreProducto varchar (40) not null,
			PrecioUnitario money null,
			NumTotalVendidas int null,
			TotalFacturadoPorProducto money null		
		)
end

rollback

select * from ProductSales

--3. Comprueba si existe una tabla llamada ShipShip. Esta tabla ha de tener de cada Transportista el ID, 
--el Nombre de la compañía, el número total de envíos que ha efectuado y el número de países diferentes 
--a los que ha llevado cosas. Si no existe, créala
begin transaction

if exists (select * from SYSOBJECTS where type='U' and name='ShipShip')
	begin 
		print 'La tabla ya esta creada'
	end 

else

	begin 
		create table ShipShip
		(
			IDTransportista int not null,
			NombreTransportista varchar (40) null,
			NombreCompania varchar (40) null,
			TotalEnvios int null,
			TotalPaises int null		
		)
	end

rollback
select * from ShipShip

--4. Comprueba si existe una tabla llamada EmployeeSales. Esta tabla ha de tener de cada empleado su ID, 
--el Nombre completo, el número de ventas totales que ha realizado, el número de clientes diferentes 
--a los que ha vendido y el total de dinero facturado. Si no existe, créala
begin transaction

if exists (select * from SYSOBJECTS where type='U' and name='EmployeeSales')
	begin 
		print 'La tabla ya esta creada hermano'
	end 

else

	begin 
		create table EmployeeSales
		(
			IDEmpleado int not null,
			NombreEmpleado varchar (10) null,
			ApellidoCompania varchar (20) null,
			TotalVentas int null,
			NumeroClientes int null,
			TotalFacturado money null		
		)
	end

rollback
select * from EmployeeSales

--5. Entre los años 96 y 97 hay productos que han aumentado sus ventas y otros que las han disminuido. 
--Queremos cambiar el precio unitario según la siguiente tabla:

--Negativo-------------------------	-10%
--Entre 0 y 10%--------------------	No varía
--Entre 10% y 50%------------------	+5%
--Mayor del 50%--------------------	10% con un máximo de 2,25
go
create view [Ventas del 97] as

select OD.ProductID,cast(sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as decimal (10,2)) as [Ventas97],year(O.OrderDate) as [Año] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
where year(O.OrderDate)=1997
group by  OD.ProductID, year(O.OrderDate)

go

go
create view [Ventas del 96] as

select OD.ProductID,cast(sum(OD.Quantity*(OD.UnitPrice*(1-OD.Discount))) as decimal (10,2)) as [Ventas96],year(O.OrderDate) as [Año] from Orders as O
inner join [Order Details] as OD on O.OrderID=OD.OrderID
where year(O.OrderDate)=1996
group by  OD.ProductID, year(O.OrderDate)

go

go
alter view [IncrementoDecrementoVentas] as

select V7.ProductID as IDProducto, ((V7.[Ventas97] / CAST ((V6.[Ventas96]) as decimal (10,2)) - 1) * 100) as [Incremento] from [Ventas del 96] as V6
inner join [Ventas del 97] as V7 on V6.ProductID=V7.ProductID
go

begin transaction 

	update Products
	set UnitPrice=	case
						when IncrementoDecrementoVentas.Incremento < 0 then (UnitPrice-UnitPrice*0.1)
						when IncrementoDecrementoVentas.Incremento between 0 and 10 then UnitPrice
						when IncrementoDecrementoVentas.Incremento between 11 and 50 then (UnitPrice+UnitPrice*0.05)
						else (UnitPrice + UnitPrice * 0.1) -- Con un maximo de 2,25 ???
					end
	from IncrementoDecrementoVentas
	where Products.ProductID = [IncrementoDecrementoVentas].IDProducto

rollback


select * from Products