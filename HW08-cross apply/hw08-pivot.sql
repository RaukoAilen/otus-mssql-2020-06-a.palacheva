/*1. Требуется написать запрос, который в результате своего выполнения формирует таблицу следующего вида:
Название клиента
МесяцГод Количество покупок

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys
имя клиента нужно поменять так чтобы осталось только уточнение
например исходное Tailspin Toys (Gasport, NY) - вы выводите в имени только Gasport,NY
дата должна иметь формат dd.mm.yyyy например 25.12.2019

Например, как должны выглядеть результаты:
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

/*2. Для всех клиентов с именем, в котором есть Tailspin Toys
вывести все адреса, которые есть в таблице, в одной колонке
Пример результатов
CustomerName AddressLine
Tailspin Toys (Head Office) Shop 38
Tailspin Toys (Head Office) 1877 Mittal Road
Tailspin Toys (Head Office) PO Box 8975
Tailspin Toys (Head Office) Ribeiroville*/

select*from
(	select	CustomerName,
			DeliveryAddressLine1,
			DeliveryAddressLine2
	from Sales.Customers
	where CustomerName like 'Tailspin Toys%') as adresses
UNPIVOT (Adress FOR Name IN(DeliveryAddressLine1,DeliveryAddressLine2))as unpvt
-------------------------------------------------------------------
/*3. В таблице стран есть поля с кодом страны цифровым и буквенным
сделайте выборку ИД страны, название, код - чтобы в поле был либо цифровой либо буквенный код
Пример выдачи
CountryId CountryName Code
1 Afghanistan AFG
1 Afghanistan 4
3 Albania ALB
3 Albania 8*/
select*from
(	select	CountryID,
			CountryName,
			IsoAlpha3Code,
			CAST(IsoNumericCode as nvarchar(3)) as NumericCode
	from Application.Countries) as country
UNPIVOT (Code FOR Name IN(IsoAlpha3Code,NumericCode))as unpvt

-------------------------------------------------------------------
/*4. Перепишите ДЗ из оконных функций через CROSS APPLY
Выберите по каждому клиенту 2 самых дорогих товара, которые он покупал
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки*/
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
/*5. Code review (опционально). Запрос приложен в материалы Hometask_code_review.sql.
Что делает запрос?
Чем можно заменить CROSS APPLY - можно ли использовать другую стратегию выборки\запроса?*/ 
предполагаю, что выборка последней версии файла в папке, которого нет в удаленных или восстановленных файлах
cross apply заменить на оконную ф-ю с top 1 row_number() по условию V.DirVersionId DESC