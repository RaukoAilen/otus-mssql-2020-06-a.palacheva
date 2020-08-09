/*1. �������� ������ � ��������� �������� � ���������� ��� � ��������� ����������. �������� �����.
� �������� ������� � ��������� �������� � ��������� ���������� ����� ����� ���� ������ ��� ��������� ������:
������� ������ ����� ������ ����������� ������ �� ������� � 2015 ���� (� ������ ������ ������ �� ����� ����������, ��������� ����� � ������� ������� �������)
�������� id �������, �������� �������, ���� �������, ����� �������, ����� ����������� ������*/
------------------------------------------------------------------------------
set statistics time on;
--381982 �� � ������ ��������, 1755 �� �� ������ ����� ������� �������, ��� ����������� ������� �������
declare @suminvoices table
(idInvoice int,
CustomerName nvarchar(50),
DateInvoice date,
SUMPrice decimal);

insert into @suminvoices (idInvoice, CustomerName, DateInvoice, SUMPrice)
select	i.InvoiceID,
		c.CustomerName,
		i.InvoiceDate,
		sum(il.Quantity*il.UnitPrice) as Total
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
join Sales.Customers as c on c.CustomerID=i.CustomerID
where i.InvoiceDate>='20150101'
group by i.InvoiceID, c.CustomerName,i.InvoiceDate

select t.idInvoice,t.CustomerName,t.DateInvoice,t.SUMPrice,
	(select sum(tt.SUMPrice) from @suminvoices as tt
	where month(tt.DateInvoice) <= month(t.DateInvoice) )
from @suminvoices as t
group by t.idInvoice, t.CustomerName,t.DateInvoice, t.SUMPrice
order by t.DateInvoice;
------------------------------------------------------------------------------
/*2. ���� �� ����� ������������ ���� ������, �� �������� ������ ����� ����������� ������ � ������� ������� �������.
�������� 2 �������� ������� - ����� windows function � ��� ���. �������� ����� ������� �����������, �������� �� set statistics time on;*/
select i.InvoiceID, c.CustomerName, i.InvoiceDate, il.ExtendedPrice,
	sum(il.Quantity*il.UnitPrice) OVER (PARTITION BY month(i.InvoiceDate)) as totalmonth
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
join Sales.Customers as c on c.CustomerID=i.CustomerID
where i.InvoiceDate>='20150101'
order by  i.InvoiceDate asc;

------------------------------------------------------------------------------
/*3. ������� ������ 2� ����� ���������� ��������� (�� ���-�� ���������) � ������ ������ �� 2016� ��� (�� 2 ����� ���������� �������� � ������ ������)*/
-----------------------------------� ������� cross apply
---------573 �� ��� ������� �-�, � 51 �� � ���, ��� �� ������� ������� � ������ ������� �-�
declare @topsales table
(OrderID int,
ItemName nvarchar(100),
SaleDate int,
SalesQuantity int);
insert into @topsales(OrderID,ItemName,SaleDate,SalesQuantity)
select	o.OrderID
		,s.StockItemName
		,month(o.OrderDate)
		,ol.Quantity
from Sales.Orders as o
			join Sales.OrderLines as ol on o.OrderID=ol.OrderID
			join Warehouse.StockItems as s on ol.StockItemID=s.StockItemID
			where year(o.OrderDate)=2016;

select distinct month(t.OrderDate) as mnth,
c.ItemName
from Sales.Orders as t
cross apply
(select top(2) tt.ItemName as ItemName
from @topsales as tt
where month(t.OrderDate)=tt.SaleDate
order by SalesQuantity desc) as c
where year(t.OrderDate)=2016
order by month(t.OrderDate) asc
----------------------------------- � ������� ��������

select * from (
			select	s.StockItemName, month(o.OrderDate) as m,
				row_number() OVER (partition by month(OrderDate) order by ol.Quantity desc) AS topmonth
			from Sales.Orders as o
			join Sales.OrderLines as ol on o.OrderID=ol.OrderID
			join Warehouse.StockItems as s on ol.StockItemID=s.StockItemID
			where year(o.OrderDate)=2016) as t
where t.topmonth <= 2;

/*4. ������� ����� ��������
���������� �� ������� �������, � ����� ����� ������ ������� �� ������, ��������, ����� � ����
������������ ������ �� �������� ������, ��� ����� ��� ��������� ����� �������� ��������� ���������� ������
���������� ����� ���������� ������� � �������� ����� � ���� �� �������
���������� ����� ���������� ������� � ����������� �� ������ ����� �������� ������
���������� ��������� id ������ ������ �� ����, ��� ������� ����������� ������� �� �����
���������� �� ������ � ��� �� �������� ����������� (�� �����)
�������� ������ 2 ������ �����, � ������ ���� ���������� ������ ��� ����� ������� "No items"
����������� 30 ����� ������� �� ���� ��� ������ �� 1 ��
��� ���� ������ �� ����� ������ ������ ��� ������������� �������*/

select StockItemID, StockItemName, Brand, UnitPrice,
	ROW_NUMBER() OVER (PARTITION BY LEFT(StockItemName,1) ORDER BY StockItemName desc) as NameRank,				--��������� � ������ ����� ��������
	COUNT(StockItemID) OVER () as ItemsCount,																	--����� ���������� �������
	COUNT(StockItemID) OVER (PARTITION BY LEFT(StockItemName,1) ORDER BY StockItemName desc) as NameCount,		--����� ���������� ������� � ����������� �� ������ ����� �������� ������
	LEAD(StockItemID) OVER (ORDER BY StockItemName desc) as NextID,												--��������� id ������
	LAG(StockItemID) OVER (ORDER BY StockItemName desc) as PrevID,												--���������� �� ������
	LAG(StockItemName,2,'No items') OVER (ORDER BY StockItemName desc) as Prev2Name,							--�������� ������ 2 ������ �����
	NTILE(30) OVER (ORDER BY TypicalWeightPerUnit) AS GroupNumberWeight											--30 ����� ������� �� ���� ��� ������
from Warehouse.StockItems
------------------------------------------------------------------------------
/*5. �� ������� ���������� �������� ���������� �������, �������� ��������� ���-�� ������
� ����������� ������ ���� �� � ������� ����������, �� � �������� �������, ���� �������, ����� ������*/
-----------------------------------� ������� cross apply
---------6019 �� �� ��� ������� �-�, � 181 �� � ���, ��� �� ������� ������� � ������ ������� �-�
select	tt.SalespersonPersonID
		,p.FullName as SalesPersonName
		,t.CustomerID
		,t.CustomerName
		,tt.OrderDate
		,t.Total
from Sales.Orders as tt 
cross apply
(select top(1)
o.CustomerID
,c.CustomerName as CustomerName
,ol.Quantity*ol.UnitPrice as Total
from Sales.Orders as o
			join Sales.OrderLines as ol on o.OrderID=ol.OrderID
			join Sales.Customers as c on c.CustomerID=o.CustomerID
where tt.SalespersonPersonID=o.SalespersonPersonID
order by tt.OrderDate asc) as t
join Application.People as p on  tt.SalespersonPersonID=p.PersonID
order by tt.OrderDate asc
----------------------------------- � ������� ��������
select * from (
			select	o.SalespersonPersonID,
			p.FullName as SalesPersonName,
			o.CustomerID,
			c.CustomerName as CustomerName,
			o.OrderDate,
			ol.Quantity*ol.UnitPrice as SumPrice,
				row_number() OVER (partition by o.SalespersonPersonID order by o.OrderDate asc) AS lastsales
			from Sales.Orders as o
			join Sales.OrderLines as ol on o.OrderID=ol.OrderID
			join Application.People as p on  o.SalespersonPersonID=p.PersonID
			join Sales.Customers as c on c.CustomerID=o.CustomerID
			) as t
where t.lastsales = 1;

/*6. �������� �� ������� ������� 2 ����� ������� ������, ������� �� �������
� ����������� ������ ���� �� ������, ��� ��������, �� ������, ����, ���� �������*/
-----------------------------------� ������� cross apply
---------1636 �� ��� ������� �-�, � 313 �� � ���, ��� �� ������� ������� � ������ ������� �-�
select distinct t.CustomerID,
				c.CustomerName,
				tt.StockItemID,
				tt.UnitPrice,
				tt.OrderDate
from Sales.Orders as t
cross apply
(select top(2)	o.CustomerID,
				o.OrderID,
				ol.StockItemID,
				ol.UnitPrice,
				o.OrderDate
from Sales.Orders as o
join Sales.OrderLines as ol on o.OrderID=ol.OrderID
join Sales.Customers as c on c.CustomerID=o.CustomerID
where o.CustomerID=t.CustomerID
order by ol.UnitPrice desc) as tt
join Sales.Customers as c on c.CustomerID=t.CustomerID
order by t.CustomerID asc
----------------------------------- � ������� ��������
select*from
(select	o.CustomerID,
		c.CustomerName,
		ol.StockItemID,
		ol.UnitPrice,
		o.OrderDate,
		row_number() OVER (partition by o.CustomerID order by ol.UnitPrice desc) AS maxprice
from Sales.Orders as o
join Sales.OrderLines as ol on o.OrderID=ol.OrderID
join Sales.Customers as c on c.CustomerID=o.CustomerID) as t
where t.maxprice<=2;