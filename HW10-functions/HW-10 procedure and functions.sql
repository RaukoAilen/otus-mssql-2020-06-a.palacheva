/*1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.*/
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

/*2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
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
--запуск
EXEC PR_customersalessum 10;

/*3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.*/
--такая же функция, как и пред.процедура
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
--для сравнения планов запроса вместе, у них одинаковые планы запросов

SELECT * FROM FN_customersalessum(10);
EXEC PR_customersalessum 10

/*4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла.*/

create function dbo.fn_tableTotalPrice()
returns @PriceTable table (CustomerName nvarchar(100),TotalPrice decimal)
as
begin
		insert @PriceTable
		select 	c.CustomerName as CustomerName,
			sum(il.Quantity*il.UnitPrice) as TotalPrice
			from Sales.Customers as c
			join Sales.Invoices as i on c.CustomerID=i.CustomerID
			join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
			group by c.CustomerName
		return
end

SELECT * FROM dbo.fn_TotalPrice()