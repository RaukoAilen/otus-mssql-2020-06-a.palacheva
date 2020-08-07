/*1. �������� ������ � ��������� �������� � ���������� ��� � ��������� ����������. �������� �����.
� �������� ������� � ��������� �������� � ��������� ���������� ����� ����� ���� ������ ��� ��������� ������:
������� ������ ����� ������ ����������� ������ �� ������� � 2015 ���� (� ������ ������ ������ �� ����� ����������, ��������� ����� � ������� ������� �������)
�������� id �������, �������� �������, ���� �������, ����� �������, ����� ����������� ������
������
���� ������� ����������� ���� �� ������
2015-01-29 4801725.31
2015-01-30 4801725.31
2015-01-31 4801725.31
2015-02-01 9626342.98
2015-02-02 9626342.98
2015-02-03 9626342.98
������� ����� ����� �� ������� Invoices.
����������� ���� ������ ���� ��� ������� �������.*/

with cte_montsum
as (
select	sum(sil.ExtendedPrice) as monthsum
		,month(si.InvoiceDate) as monthdate
from Sales.InvoiceLines as sil
join Sales.Invoices as si on sil.ExtendedPrice=si.InvoiceID
group by month(si.InvoiceDate))

select
i.InvoiceID,
c.CustomerName,
i.InvoiceDate,
il.ExtendedPrice,
(select sum(ct.monthsum) from cte_montsum as ct
where ct.monthdate<=month(i.InvoiceDate) )
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
join Sales.Customers as c on c.CustomerID=i.CustomerID
where year(i.InvoiceDate)>=2015
order by  c.CustomerName, i.InvoiceDate asc
---------------------------------------------------------------------------
/*2. ���� �� ����� ������������ ���� ������, �� �������� ������ ����� ����������� ������ � ������� ������� �������.
�������� 2 �������� ������� - ����� windows function � ��� ���. �������� ����� ������� �����������, �������� �� set statistics time on;*/
select i.InvoiceID, c.CustomerName, i.InvoiceDate, il.ExtendedPrice,
	SUM(il.ExtendedPrice) OVER (PARTITION BY month(i.InvoiceDate)) as totalmonth
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
join Sales.Customers as c on c.CustomerID=i.CustomerID
where year(i.InvoiceDate)>=2015
order by  i.InvoiceDate asc


/*3. ������� ������ 2� ����� ���������� ��������� (�� ���-�� ���������) � ������ ������ �� 2016� ��� (�� 2 ����� ���������� �������� � ������ ������)*/
select*from(
			select	s.StockItemName, month(o.OrderDate),
				row_number() OVER (partition by month(OrderDate) order by ol.Quantity desc) AS topmonth
			from Sales.Orders as o
			join Sales.OrderLines as ol on o.OrderID=ol.OrderID
			join Warehouse.StockItems as s on ol.StockItemID=s.StockItemID
			where year(o.OrderDate)=2016)
where topmonth <= 2;
------------------------------------------------
select top(2) with ties 
s.StockItemName, month(o.OrderDate),row_number() OVER (partition by month(OrderDate) order by ol.Quantity desc)
from Sales.Orders as o
				join Sales.OrderLines as ol on o.OrderID=ol.OrderID
				join Warehouse.StockItems as s on ol.StockItemID=s.StockItemID
				where year(o.OrderDate)=2016
order by row_number() OVER (partition by month(OrderDate) order by ol.Quantity desc)


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


/*5. �� ������� ���������� �������� ���������� �������, �������� ��������� ���-�� ������
� ����������� ������ ���� �� � ������� ����������, �� � �������� �������, ���� �������, ����� ������*/


/*6. �������� �� ������� ������� 2 ����� ������� ������, ������� �� �������
� ����������� ������ ���� �� ������, ��� ��������, �� ������, ����, ���� �������*/