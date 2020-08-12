/*1. ��������� �������� ������, ������� � ���������� ������ ���������� ��������� ������� ���������� ����:
�������� �������
�������� ���������� �������

�������� ����� � ID 2-6, ��� ��� ������������� Tailspin Toys
��� ������� ����� �������� ��� ����� �������� ������ ���������
�������� �������� Tailspin Toys (Gasport, NY) - �� �������� � ����� ������ Gasport,NY
���� ������ ����� ������ dd.mm.yyyy �������� 25.12.2019

��������, ��� ������ ��������� ����������:
InvoiceMonth Peeples Valley, AZ Medicine Lodge, KS Gasport, NY Sylvanite, MT Jessie, ND
01.01.2013 3 1 4 2 2
01.02.2013 7 3 4 2 1*/
------------------------------------------------------------------------------------------------------------
WITH cte_Customers as (
SELECT  TRIM(REPLACE(REPLACE(REPLACE(cust.CustomerName, 'Tailspin Toys', ''), '(',''), ')', '')) Customer,
		CONVERT(nvarchar, DATEFROMPARTS(YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), 1 ), 104) as PurchaseMonth,
		COUNT(*) as QuantityPurchases
FROM Sales.Customers cust
	INNER JOIN Sales.Invoices AS inv
		ON inv.CustomerID = cust.CustomerID
WHERE cust.CustomerID between 2 and 6
GROUP BY cust.CustomerName, DATEFROMPARTS(YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), 1 ))

SELECT *
FROM cte_Customers
PIVOT (SUM(QuantityPurchases)
	FOR Customer IN ([Gasport, NY], [Jessie, ND], [Medicine Lodge, KS], [Peeples Valley, AZ], [Sylvanite, MT])) as PVT
ORDER BY PurchaseMonth

/*2. ��� ���� �������� � ������, � ������� ���� Tailspin Toys
������� ��� ������, ������� ���� � �������, � ����� �������
������ �����������
CustomerName AddressLine
Tailspin Toys (Head Office) Shop 38
Tailspin Toys (Head Office) 1877 Mittal Road
Tailspin Toys (Head Office) PO Box 8975
Tailspin Toys (Head Office) Ribeiroville*/

select c.CustomerName, t.*
from Sales.Customers as c
cross apply
(select DeliveryAddressLine1 as Adress
	from Sales.Customers
union
select DeliveryAddressLine2
from Sales.Customers
	where CustomerID=c.CustomerID) as t
where c.CustomerName like 'Tailspin Toys%'
order by c.CustomerName asc, Adress asc
-------------------------------------------------------------------
/*3. � ������� ����� ���� ���� � ����� ������ �������� � ���������
�������� ������� �� ������, ��������, ��� - ����� � ���� ��� ���� �������� ���� ��������� ���
������ ������
CountryId CountryName Code
1 Afghanistan AFG
1 Afghanistan 4
3 Albania ALB
3 Albania 8*/
select	c.CountryID,
		c.CountryName, t.*
from Application.Countries as c
cross apply
(select IsoAlpha3Code as Code
	from Application.Countries
union
select CAST(IsoNumericCode as nvarchar(3))
from Application.Countries
	where CountryID=c.CountryID) as t
order by c.CountryID
-------------------------------------------------------------------
/*4. ���������� �� �� ������� ������� ����� CROSS APPLY
�������� �� ������� ������� 2 ����� ������� ������, ������� �� �������
� ����������� ������ ���� �� ������, ��� ��������, �� ������, ����, ���� �������*/
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
-------------------------------------------------------------------
/*5. Code review (�����������). ������ �������� � ��������� Hometask_code_review.sql.
��� ������ ������?
��� ����� �������� CROSS APPLY - ����� �� ������������ ������ ��������� �������\�������?*/ 
�����������, ��� ������� ��������� ������ ����� � �����, �������� ��� � ��������� ��� ��������������� ������
cross apply �������� �� ������� �-� � top 1 row_number() �� ������� V.DirVersionId DESC