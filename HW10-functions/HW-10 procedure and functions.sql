/*1) �������� ������� ������������ ������� � ���������� ������ �������.*/
create function dbo.fn_maxsales ()  
returns table  
AS  
return   
(  
		select top(1)	c.CustomerName,
				il.Quantity*il.UnitPrice as total
		from Sales.Customers as c
			join Sales.Invoices as i on c.CustomerID=i.CustomerID
			join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID 
		order by il.Quantity*il.UnitPrice desc 
);  
GO    
SELECT * FROM dbo.fn_maxsales(); 

/*2) �������� �������� ��������� � �������� ���������� �ustomerID, ��������� ����� ������� �� ����� �������.
������������ ������� :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines*/

create procedure PR_customersalessum
@customerid int
WITH EXECUTE AS CALLER  
AS   
    set NOCOUNT ON;  
	select 	c.CustomerName,
			sum(il.Quantity*il.UnitPrice) as total
	from Sales.Customers as c
			join Sales.Invoices as i on c.CustomerID=i.CustomerID
			join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
	where c.CustomerID = @customerid
	group by c.CustomerName
GO 
--������
EXEC PR_customersalessum 10;

/*3) ������� ���������� ������� � �������� ���������, ���������� � ��� ������� � ������������������ � ������.*/
--����� �� �������, ��� � ����.���������
create function FN_customersalessum (@customerid int)  
RETURNS TABLE  
AS  
RETURN   
(  
		select 	c.CustomerName,
			sum(il.Quantity*il.UnitPrice) as total
		from Sales.Customers as c
			join Sales.Invoices as i on c.CustomerID=i.CustomerID
			join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
		where c.CustomerID = @customerid 
		group by c.CustomerName
);  
GO
--��� ��������� ������ ������� ������, � ��� ���������� ����� ��������

SELECT * FROM FN_customersalessum(10);
EXEC PR_customersalessum 10

/*4) �������� ��������� ������� �������� ��� �� ����� ������� ��� ������ ������ result set'� ��� ������������� �����.*/

create function dbo.fn_totalsales (@CustomerID int)  
returns table  
AS  
return   
(		select sum(il.Quantity*il.UnitPrice) as total
		from Sales.Customers as c
			join Sales.Invoices as i on c.CustomerID=i.CustomerID
			join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
		where c.CustomerID = @CustomerID
)

SELECT c.CustomerID, fnTotal.total as TotalSUM
from Sales.Customers as c
CROSS APPLY dbo.fn_totalsales(c.CustomerID) AS fnTotal
order by  c.CustomerID desc