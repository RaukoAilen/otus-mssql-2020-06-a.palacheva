------------------------------------------------------1-------------------------------------------------------------------
/*��� ������, � �������� ������� ���� "urgent" ��� �������� ���������� � "Animal"
�������: Warehouse.StockItems.*/
select StockItemName from Warehouse.StockItems
--where StockItemName IN ('%urgent%' , 'Animal%') /*�� �������� � IN, �� ������� ������ */
where StockItemName like '%urgent%' or StockItemName like  'Animal%'

------------------------------------------------------2-------------------------------------------------------------------
/*����������� (Suppliers), � ������� �� ���� ������� �� ������ ������ (PurchaseOrders). ������� ����� JOIN, � ����������� ������� ������� �� �����.
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders.*/
select t1.SupplierName as Suppliers
from Purchasing.Suppliers AS t1
left join Purchasing.PurchaseOrders as t2 on t1.SupplierID=t2.SupplierID
where t2.SupplierID is null
------------------------------------------------------3-------------------------------------------------------------------
/*������ (Orders) � ����� ������ ����� 100$ ���� ����������� ������ ������ ����� 20 ���� � �������������� ����� ������������ ����� ������ (PickingCompletedWhen).
�������:
* OrderID
* ���� ������ � ������� ��.��.����
* �������� ������, � ������� ���� �������
* ����� ��������, � �������� ��������� �������
* ����� ����, � ������� ��������� ���� ������� (������ ����� �� 4 ������)
* ��� ��������� (Customer)
�������: Sales.Orders, Sales.OrderLines, Sales.Customers.*/
select t1.OrderID,
	   convert(char(10),t1.OrderDate,104) as DateOrders,
	   datename(month, t1.OrderDate) as MonthOrder,
	   datepart(q, t1.OrderDate) as QuarterOrder,
			case	when month(t1.OrderDate) between 1 AND 4 then '1'
				when month(t1.OrderDate) between 5 AND 8 then '2'
				else '3'
			end  AS thirdOTyear,
		t2.CustomerName AS Customer
from Sales.Orders as t1
join Sales.Customers as t2 ON t1.CustomerID=t2.CustomerID
join Sales.OrderLines as t3 ON t1.OrderID=t3.OrderID
where (t3.UnitPrice>100 or t3.Quantity>20) AND t3.PickingCompletedWhen is not null
order by QuarterOrder ASC, thirdOTyear ASC, DateOrders ASC

------------------------------------------------------3.1----------------------------------------------------------------
/*�������� ������� ����� ������� � ������������ ��������, ��������� ������ 1000 � ��������� ��������� 100 �������. ���������� ������ ���� �� ������ ��������, ����� ����, ���� ������ (����� �� �����������).*/
select	t1.OrderID,
		convert(char(10),t1.OrderDate,104) as DateOrders,
		datename(month, t1.OrderDate) as MonthOrder,
		datepart(q, t1.OrderDate) as QuarterOrder,
			case	when month(t1.OrderDate) between 1 AND 4 then '1'
					when month(t1.OrderDate) between 5 AND 8 then '2'
					else '3'
			end  AS thirdOTyear,
		t2.CustomerName AS Customer
from Sales.Orders as t1
join Sales.Customers as t2 ON t1.CustomerID=t2.CustomerID
join Sales.OrderLines as t3 ON t1.OrderID=t3.OrderID
where (t3.UnitPrice>100 or t3.Quantity>20) AND t3.PickingCompletedWhen is not null
order by QuarterOrder ASC, thirdOTyear ASC, DateOrders ASC
offset 1000 rows fetch next 100 rows only

------------------------------------------------------4-------------------------------------------------------------------
/*������ ����������� (Purchasing.Suppliers), ������� ���� ��������� � ������ 2014 ���� � ��������� Air Freight ��� Refrigerated Air Freight (DeliveryMethodName).
�������:
* ������ �������� (DeliveryMethodName)
* ���� ��������
* ��� ����������
* ��� ����������� ���� ������������ ����� (ContactPerson)
�������: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.*/
select	t1.DeliveryMethodName,
		t.OrderDate,
		t2.SupplierName,
		t3.FullName
from Purchasing.PurchaseOrders as t
join Application.DeliveryMethods as t1 ON t.DeliveryMethodID=t1.DeliveryMethodID
join Purchasing.Suppliers as t2 on t.SupplierID=t2.SupplierID
join Application.People as t3 on t.ContactPersonID=t3.PersonID
where year(t.OrderDate)=2014 AND t1.DeliveryMethodName IN ('Air Freight','Refrigerated Air Freight')

------------------------------------------------------5-------------------------------------------------------------------
/*������ ��������� ������ (�� ����) � ������ ������� � ������ ����������, ������� ������� ����� (SalespersonPerson).*/
select top(10)	t.OrderDate,
				t1.Description,
				t2.FullName AS Salesperson,
				t3.CustomerName
from Sales.Orders as t
join Sales.OrderLines as t1 on t.OrderId=t1.OrderID
join Application.People as t2 on t.SalespersonPersonID=t2.PersonID
join Sales.Customers as t3 on t.CustomerID=t3.CustomerID
order by t.OrderDate desc
------------------------------------------------------6-------------------------------------------------------------------
/*��� �� � ����� �������� � �� ���������� ��������, ������� �������� ����� Chocolate frogs 250g. ��� ������ �������� � Warehouse.StockItems.*/
select	t.CustomerID,
		t.CustomerName,
		t.PhoneNumber
from Sales.Customers as t
join Sales.Orders as t1 on t.CustomerID=t1.CustomerID
join Sales.OrderLines as t2 on t1.OrderID=t2.OrderID
join Warehouse.StockItems as t3 on t2.StockItemID=t3.StockItemID
where StockItemName like 'Chocolate frogs 250g'

