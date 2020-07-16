/*1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. Продажи смотреть в таблице Sales.Invoices.*/
--с вложенным подзапросом
select	t1.PersonID, t1.FullName
from Application.People as t1
join	(select SalespersonPersonID, InvoiceDate from Sales.Invoices
		where InvoiceDate<>'2015-04-07') as t2
on t1.PersonID=t2.SalespersonPersonID
group by t1.PersonID, t1.FullName /*здесь избежала дублей группировкой, делая через with с помощью distinct*/
order by t1.PersonID asc
через WITH
with cte_invoices
as (select SalespersonPersonID, InvoiceDate from Sales.Invoices
	where InvoiceDate<>'2015-04-07')
select distinct t1.PersonID, t1.FullName
from Application.People as t1
join cte_invoices on t1.PersonID=cte_invoices.SalespersonPersonID
order by t1.PersonID asc

/*2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. Вывести: ИД товара, наименование товара, цена.*/
select StockItemID, StockItemName, UnitPrice
from Warehouse.StockItems
where UnitPrice=(select min(UnitPrice) from Warehouse.StockItems)
--не смогла придумать, какой еще вариант подзапроса сделать

/*3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE).*/
--1вариант
with cte_topmax
as (select top (5) CustomerID, TransactionAmount from Sales.CustomerTransactions
	order by TransactionAmount desc )
select t1.CustomerID, t1.CustomerName from Sales.Customers as t1
join cte_topmax on t1.CustomerID=cte_topmax.CustomerID
--2вариант
select t1.CustomerID, t1.CustomerName from Sales.Customers as t1
join (select top (5) CustomerID, TransactionAmount from Sales.CustomerTransactions
		order by TransactionAmount desc ) as t2
on t1.CustomerID=t2.CustomerID
--3вариант
with cte_customers
as (select CustomerID, CustomerName from Sales.Customers)
select top(5) t1.CustomerID, t2.CustomerName
from Sales.CustomerTransactions as t1
join cte_customers as t2
on t1.CustomerID=t2.CustomerID
order by t1.TransactionAmount desc

/*4. Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров, а также
имя сотрудника, который осуществлял упаковку заказов (PickedByPersonID).*/
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

/*5. Объясните, что делает и оптимизируйте запрос:*/
Выводит информацию (id, дата, продавец), сопоставляющую сумму заказа(укомплектованный) и выставленный счет,
где сумма превышает 27.000
Не могу разобраться с тем, как там сработала группировка и having, в последнем джоине.
- заменяю подзапросы на джоин, кроме подзапроса к Application.People,
тк обращаемся к ней только ради одного значения


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








