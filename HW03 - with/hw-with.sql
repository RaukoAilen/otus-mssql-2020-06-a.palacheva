/*1. �������� ����������� (Application.People), ������� �������� ������������ (IsSalesPerson), � �� ������� �� ����� ������� 04 ���� 2015 ����. 
������� �� ���������� � ��� ������ ���. ������� �������� � ������� Sales.Invoices.*/
--� ��������� �����������
select	t1.PersonID, t1.FullName
from Application.People as t1
join	(select SalespersonPersonID, InvoiceDate from Sales.Invoices
		where InvoiceDate<>'2015-04-07') as t2
on t1.PersonID=t2.SalespersonPersonID
group by t1.PersonID, t1.FullName /*����� �������� ������ ������������, ����� ����� with � ������� distinct*/
order by t1.PersonID asc
����� WITH
with cte_invoices
as (select SalespersonPersonID, InvoiceDate from Sales.Invoices
	where InvoiceDate<>'2015-04-07')
select distinct t1.PersonID, t1.FullName
from Application.People as t1
join cte_invoices on t1.PersonID=cte_invoices.SalespersonPersonID
order by t1.PersonID asc

/*2. �������� ������ � ����������� ����� (�����������). �������� ��� �������� ����������. �������: �� ������, ������������ ������, ����.*/
select StockItemID, StockItemName, UnitPrice
from Warehouse.StockItems
where UnitPrice=(select min(UnitPrice) from Warehouse.StockItems)
--�� ������ ���������, ����� ��� ������� ���������� �������

/*3. �������� ���������� �� ��������, ������� �������� �������� ���� ������������ �������� �� Sales.CustomerTransactions. 
����������� ��������� �������� (� ��� ����� � CTE).*/
--1�������
with cte_topmax
as (select top (5) CustomerID, TransactionAmount from Sales.CustomerTransactions
	order by TransactionAmount desc )
select t1.CustomerID, t1.CustomerName from Sales.Customers as t1
join cte_topmax on t1.CustomerID=cte_topmax.CustomerID
--2�������
select t1.CustomerID, t1.CustomerName from Sales.Customers as t1
join (select top (5) CustomerID, TransactionAmount from Sales.CustomerTransactions
		order by TransactionAmount desc ) as t2
on t1.CustomerID=t2.CustomerID
--3�������
with cte_customers
as (select CustomerID, CustomerName from Sales.Customers)
select top(5) t1.CustomerID, t2.CustomerName
from Sales.CustomerTransactions as t1
join cte_customers as t2
on t1.CustomerID=t2.CustomerID
order by t1.TransactionAmount desc

/*4. �������� ������ (�� � ��������), � ������� ���� ���������� ������, �������� � ������ ����� ������� �������, � �����
��� ����������, ������� ����������� �������� ������� (PickedByPersonID).*/
with cte_orders
as (select	t1.OrderID,
			t1.StockItemID,
			t2.CustomerID,
			t2.PickedByPersonID,
			t3.DeliveryCityID
	from Sales.OrderLines as t1
	join Sales.Orders as t2  on t1.OrderID=t2.OrderID
	join Sales.Customers as t3 on t2.CustomerID=t3.CustomerID)

select t4.CityID, t4.CityName, P.FullName
from Application.Cities as t4
join cte_orders as O on t4.CityID=O.DeliveryCityID
join Application.People as P on O.PickedByPersonID=P.PersonID
where O.StockItemID in (select top (3) StockItemID from Warehouse.StockItems
	order by UnitPrice desc)

/*5. ���������, ��� ������ � ������������� ������:*/
������� ���������� (id, ����, ��������), �������������� ����� ������(����������������) � ������������ ����,
��� ����� ��������� 27.000
�� ���� ����������� � ���, ��� ��� ��������� ����������� � having, � ��������� ������.
- ������� ���������� �� �����, ����� ���������� � Application.People,
�� ���������� � ��� ������ ���� ������ ��������


select
i.InvoiceID,
i.InvoiceDate,
(select People.FullName from Application.People
where People.PersonID = Invoices.SalespersonPersonID) AS SalesPersonName,
sum(o1.PickedQuantity*o1.UnitPrice) as TotalSummForPickedItems,
sum(i1.Quantity*i1.UnitPrice) as TotalSummByInvoice
from Sales.Invoices as i
join Sales.Orders as o on i.OrderId = o.OrderId
join Sales.OrderLines as o1 on o.OrderId=o1.OrderId
join Sales.InvoiceLines as i1 on i.InvoiceID=i1.InvoiceID
where o.PickingCompletedWhen IS NOT NULL
group by i.InvoiceID, i.InvoiceDate, p.FullName
HAVING sum(o1.PickedQuantity*o1.UnitPrice) > 27000 and sum(i1.Quantity*i1.UnitPrice)> 27000
ORDER BY TotalSummByInvoice DESC








