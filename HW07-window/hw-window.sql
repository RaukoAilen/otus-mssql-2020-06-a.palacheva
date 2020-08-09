/*1. Напишите запрос с временной таблицей и перепишите его с табличной переменной. Сравните планы.
В качестве запроса с временной таблицей и табличной переменной можно взять свой запрос или следующий запрос:
Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года (в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки)
Выведите id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом*/
------------------------------------------------------------------------------
set statistics time on;
--381982 мс в первом варианте, 1755 мс во втором через оконную функцию, что определенно намного быстрее
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
/*2. Если вы брали предложенный выше запрос, то сделайте расчет суммы нарастающим итогом с помощью оконной функции.
Сравните 2 варианта запроса - через windows function и без них. Написать какой быстрее выполняется, сравнить по set statistics time on;*/
select i.InvoiceID, c.CustomerName, i.InvoiceDate, il.ExtendedPrice,
	sum(il.Quantity*il.UnitPrice) OVER (PARTITION BY month(i.InvoiceDate)) as totalmonth
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
join Sales.Customers as c on c.CustomerID=i.CustomerID
where i.InvoiceDate>='20150101'
order by  i.InvoiceDate asc;

------------------------------------------------------------------------------
/*3. Вывести список 2х самых популярных продуктов (по кол-ву проданных) в каждом месяце за 2016й год (по 2 самых популярных продукта в каждом месяце)*/
-----------------------------------с помощью cross apply
---------573 мс без оконной ф-и, и 51 мс с ней, так же большая разница в пользу оконной ф-и
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
----------------------------------- с оконной функцией

select * from (
			select	s.StockItemName, month(o.OrderDate) as m,
				row_number() OVER (partition by month(OrderDate) order by ol.Quantity desc) AS topmonth
			from Sales.Orders as o
			join Sales.OrderLines as ol on o.OrderID=ol.OrderID
			join Warehouse.StockItems as s on ol.StockItemID=s.StockItemID
			where year(o.OrderDate)=2016) as t
where t.topmonth <= 2;

/*4. Функции одним запросом
Посчитайте по таблице товаров, в вывод также должен попасть ид товара, название, брэнд и цена
пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
посчитайте общее количество товаров и выведете полем в этом же запросе
посчитайте общее количество товаров в зависимости от первой буквы названия товара
отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
предыдущий ид товара с тем же порядком отображения (по имени)
названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций*/

select StockItemID, StockItemName, Brand, UnitPrice,
	ROW_NUMBER() OVER (PARTITION BY LEFT(StockItemName,1) ORDER BY StockItemName desc) as NameRank,				--нумерация с каждой буквы алфавита
	COUNT(StockItemID) OVER () as ItemsCount,																	--общее количество товаров
	COUNT(StockItemID) OVER (PARTITION BY LEFT(StockItemName,1) ORDER BY StockItemName desc) as NameCount,		--общее количество товаров в зависимости от первой буквы названия товара
	LEAD(StockItemID) OVER (ORDER BY StockItemName desc) as NextID,												--следующий id товара
	LAG(StockItemID) OVER (ORDER BY StockItemName desc) as PrevID,												--предыдущий ид товара
	LAG(StockItemName,2,'No items') OVER (ORDER BY StockItemName desc) as Prev2Name,							--названия товара 2 строки назад
	NTILE(30) OVER (ORDER BY TypicalWeightPerUnit) AS GroupNumberWeight											--30 групп товаров по полю вес товара
from Warehouse.StockItems
------------------------------------------------------------------------------
/*5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки*/
-----------------------------------с помощью cross apply
---------6019 мс мс без оконной ф-и, и 181 мс с ней, так же большая разница в пользу оконной ф-и
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
----------------------------------- с оконной функцией
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

/*6. Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки*/
-----------------------------------с помощью cross apply
---------1636 мс без оконной ф-и, и 313 мс с ней, так же большая разница в пользу оконной ф-и
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
----------------------------------- с оконной функцией
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