--Написать запросы 1-3 так, чтобы если в каком-то месяце не было продаж, то этот месяц также отображался бы в результатах, но там были нули.
/*1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи
* Месяц продажи
* Средняя цена за месяц по всем товарам
* Общая сумма продаж
Продажи смотреть в таблице Sales.Invoices и связанных таблицах.*/

select
year(i.InvoiceDate) as 'Год продажи',
month(i.InvoiceDate) as 'Месяц продажи',
coalesce(avg(il.ExtendedPrice), '0') as 'Средняя цена',
sum(il.ExtendedPrice) as 'Общая сумма'
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
group by rollup (year(i.InvoiceDate), month(i.InvoiceDate))
order by year(i.InvoiceDate), month(i.InvoiceDate)
-----------------------------------------------------------------------------------------------------------------
/*2. Отобразить все месяцы, где общая сумма продаж превысила 10 000
Вывести:
* Год продажи
* Месяц продажи
* Общая сумма продаж*/

select
year(i.InvoiceDate) as 'Год продажи',
month(i.InvoiceDate) as 'Месяц продажи',
coalesce(sum(il.ExtendedPrice),0) as 'Общая сумма'
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
group by rollup (year(i.InvoiceDate), month(i.InvoiceDate))
having (sum(il.ExtendedPrice)>10000)
-----------------------------------------------------------------------------------------------------------------
/*3. Вывести сумму продаж, дату первой продажи и количество проданного по месяцам, по товарам, продажи которых менее 50 ед в месяц.
Группировка должна быть по году, месяцу, товару.
Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного*/
select
year(i.InvoiceDate) as 'Год продажи',
month(i.InvoiceDate) as 'Месяц продажи',
si.StockItemName as 'Наименование товара',
coalesce(sum(il.ExtendedPrice),0) as 'Сумма продаж',
min(i.InvoiceDate) as 'Дата первой продажи',
sum(il.Quantity) as 'Количество проданного'
from Sales.Invoices as i
join Sales.InvoiceLines as il on i.InvoiceID=il.InvoiceID
join Warehouse.StockItems as si on il.StockItemID=si.StockItemID
group by rollup (year(i.InvoiceDate), month(i.InvoiceDate), si.StockItemName)
having sum(il.Quantity)<50
-----------------------------------------------------------------------------------------------------------------

/*4. Написать рекурсивный CTE sql запрос и заполнить им временную таблицу и табличную переменную
Дано:
CREATE TABLE dbo.MyEmployees
(
EmployeeID smallint NOT NULL,
FirstName nvarchar(30) NOT NULL,
LastName nvarchar(40) NOT NULL,
Title nvarchar(50) NOT NULL,
DeptID smallint NOT NULL,
ManagerID int NULL,
CONSTRAINT PK_EmployeeID PRIMARY KEY CLUSTERED (EmployeeID ASC)
);
INSERT INTO dbo.MyEmployees VALUES
(1, N'Ken', N'Sánchez', N'Chief Executive Officer',16,NULL)
,(273, N'Brian', N'Welcker', N'Vice President of Sales',3,1)
,(274, N'Stephen', N'Jiang', N'North American Sales Manager',3,273)
,(275, N'Michael', N'Blythe', N'Sales Representative',3,274)
,(276, N'Linda', N'Mitchell', N'Sales Representative',3,274)
,(285, N'Syed', N'Abbas', N'Pacific Sales Manager',3,273)
,(286, N'Lynn', N'Tsoflias', N'Sales Representative',3,285)
,(16, N'David',N'Bradley', N'Marketing Manager', 4, 273)
,(23, N'Mary', N'Gibson', N'Marketing Specialist', 4, 16);
-------------------------------------
Результат вывода рекурсивного CTE:
EmployeeID Name Title EmployeeLevel
1 Ken Sánchez Chief Executive Officer 1
273 | Brian Welcker Vice President of Sales 2
16 | | David Bradley Marketing Manager 3
23 | | | Mary Gibson Marketing Specialist 4
274 | | Stephen Jiang North American Sales Manager 3
276 | | | Linda Mitchell Sales Representative 4
275 | | | Michael Blythe Sales Representative 4
285 | | Syed Abbas Pacific Sales Manager 3
286 | | | Lynn Tsoflias Sales Representative 4
*/
-----------------------------------------------------------------------------------------------------------------
--------------создание временной таблицы
CREATE TABLE #HWEmployees
(EmployeeID smallint NOT NULL,
Name nvarchar(40) NOT NULL,
Title nvarchar(50) NOT NULL,
EmployeeLevel smallint NOT NULL);
------------создание cte
WITH CTE_Employees AS
 (select	EmployeeID,
			case
			when DeptID=2 then '|'
			when DeptID=3 then '||'
			when DeptID=4 then '|||'
			else ' '
			end
			+ ' ' + + FirstName + ' ' + LastName as Name,
		Title,
		DeptID as EmployeeLevel
from MyEmployees)

---------вношу во временную таблицу
INSERT INTO #HWEmployees
SELECT EmployeeID, Name, Title, EmployeeLevel
FROM CTE_Employees

select * from #HWEmployees


