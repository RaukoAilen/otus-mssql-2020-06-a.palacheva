/*1. ��������� ������ �� ����� StockItems.xml � ������� Warehouse.StockItems.
������������ ������ � ������� ��������, ������������� �������� (������������ ������ �� ���� StockItemName).
���� StockItems.xml � ������ ��������.*/
DECLARE @docHandle int, @docxml xml;  
----���������� � ���
SET @docxml='<StockItems>
<Item Name="&quot;The Gu&quot; red shirt XML tag t-shirt (Black) 3XXL">
<SupplierID>4</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>6</OuterPackageID>
<QuantityPerOuter>12</QuantityPerOuter>
<TypicalWeightPerUnit>0.400</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>7</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>18.000000</UnitPrice>
</Item>
<Item Name="Developer joke mug (Yellow)">
<SupplierID>5</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>10</QuantityPerOuter>
<TypicalWeightPerUnit>0.600</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>12</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>1.500000</UnitPrice>
</Item>
<Item Name="Dinosaur battery-powered slippers (Green) L">
<SupplierID>4</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>1</QuantityPerOuter>
<TypicalWeightPerUnit>0.350</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>12</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>16.000000</UnitPrice>
</Item>
<Item Name="Dinosaur battery-powered slippers (Green) M">
<SupplierID>4</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>1</QuantityPerOuter>
<TypicalWeightPerUnit>0.350</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>12</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>48.000000</UnitPrice>
</Item>
<Item Name="Dinosaur battery-powered slippers (Green) S">
<SupplierID>4</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>1</QuantityPerOuter>
<TypicalWeightPerUnit>0.350</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>12</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>32.000000</UnitPrice>
</Item>
<Item Name="Furry gorilla with big eyes slippers (Black) XL">
<SupplierID>4</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>1</QuantityPerOuter>
<TypicalWeightPerUnit>0.400</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>12</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>32.000000</UnitPrice>
</Item>
<Item Name="Large replacement blades 18mm">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>10</QuantityPerOuter>
<TypicalWeightPerUnit>0.800</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>21</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>2.450000</UnitPrice>
</Item>
<Item Name="Large sized bubblewrap roll 50m">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>10</QuantityPerOuter>
<TypicalWeightPerUnit>10.000</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>36.000000</UnitPrice>
</Item>
<Item Name="Medium sized bubblewrap roll 20m">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>10</QuantityPerOuter>
<TypicalWeightPerUnit>6.000</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>20.000000</UnitPrice>
</Item>
<Item Name="Shipping carton (Brown) 356x229x229mm">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>25</QuantityPerOuter>
<TypicalWeightPerUnit>0.400</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>1.140000</UnitPrice>
</Item>
<Item Name="Shipping carton (Brown) 356x356x279mm">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>25</QuantityPerOuter>
<TypicalWeightPerUnit>0.300</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>3.060000</UnitPrice>
</Item>
<Item Name="Shipping carton (Brown) 413x285x187mm">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>25</QuantityPerOuter>
<TypicalWeightPerUnit>0.350</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>0.335000</UnitPrice>
</Item>
<Item Name="Shipping carton (Brown) 457x279x279mm">
<SupplierID>7</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>25</QuantityPerOuter>
<TypicalWeightPerUnit>0.400</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>1.920000</UnitPrice>
</Item>
<Item Name="USB food flash drive - sushi roll">
<SupplierID>12</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>1</QuantityPerOuter>
<TypicalWeightPerUnit>0.050</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>32.000000</UnitPrice>
</Item>
<Item Name="USB missile launcher (Green)">
<SupplierID>12</SupplierID>
<Package>
<UnitPackageID>7</UnitPackageID>
<OuterPackageID>7</OuterPackageID>
<QuantityPerOuter>1</QuantityPerOuter>
<TypicalWeightPerUnit>0.300</TypicalWeightPerUnit>
</Package>
<LeadTimeDays>14</LeadTimeDays>
<IsChillerStock>0</IsChillerStock>
<TaxRate>20.000</TaxRate>
<UnitPrice>25.000000</UnitPrice>
</Item>
</StockItems>';
EXEC sp_xml_preparedocument @docHandle OUTPUT, @docxml

CREATE TABLE #StockitemsXML
([ItemName] nvarchar(100),
	[SupplierID] int,
	[UnitPackageID] int,
	[OuterPackageID] int,
	[QuantityPerOuter] int,
	[TypicalWeightPerUnit] decimal,
	[LeadTimeDays] int,
	[IsChillerStock] bit,
	[TaxRate] decimal,
	[UnitPrice]decimal)
INSERT INTO #StockitemsXML
SELECT *
FROM OPENXML(@docHandle, N'/StockItems/Item')
WITH ( 
	[ItemName] nvarchar(100)  '@Name',
	[SupplierID] int 'SupplierID',
	[UnitPackageID] int 'Package/UnitPackageID',
	[OuterPackageID] int 'Package/OuterPackageID',
	[QuantityPerOuter] int 'Package/QuantityPerOuter',
	[TypicalWeightPerUnit] decimal 'Package/TypicalWeightPerUnit',
	[LeadTimeDays] int 'LeadTimeDays',
	[IsChillerStock] bit 'IsChillerStock',
	[TaxRate] decimal 'TaxRate',
	[UnitPrice]decimal 'UnitPrice'
	)
--��������� ��������� �� ���������� � ������� ���
--select*from #StockitemsXML

MERGE Warehouse.StockItems AS target 
	USING (SELECT	ItemName
					,SupplierID
					,UnitPackageID
					,OuterPackageID
					,QuantityPerOuter
					,TypicalWeightPerUnit
					,LeadTimeDays
					,IsChillerStock
					,TaxRate
					,UnitPrice
  FROM #StockitemsXML
		) 
		AS source (ItemName,SupplierID,UnitPackageID,OuterPackageID,QuantityPerOuter,TypicalWeightPerUnit,LeadTimeDays,IsChillerStock,TaxRate,UnitPrice) 
		ON
	 (target.StockItemName = source.ItemName) 
	WHEN MATCHED 
		THEN UPDATE 
		SET  SupplierID= source.SupplierID
		,UnitPackageID= source.UnitPackageID
		,OuterPackageID= source.OuterPackageID
		,QuantityPerOuter= source.QuantityPerOuter
		,TypicalWeightPerUnit= source.TypicalWeightPerUnit
		,LeadTimeDays= source.LeadTimeDays
		,IsChillerStock= source.IsChillerStock
		,TaxRate= source.TaxRate
		,UnitPrice= source.UnitPrice
	WHEN NOT MATCHED 
THEN INSERT (StockItemID,StockItemName,SupplierID,UnitPackageID,OuterPackageID,LeadTimeDays,QuantityPerOuter,IsChillerStock,TaxRate,UnitPrice,TypicalWeightPerUnit,LastEditedBy) 
VALUES (NEXT VALUE FOR Sequences.StockItemID,source.ItemName,source.SupplierID,source.UnitPackageID,source.OuterPackageID,source.LeadTimeDays
,source.QuantityPerOuter,source.IsChillerStock,source.TaxRate,source.UnitPrice,source.TypicalWeightPerUnit,1);

EXEC sp_xml_removedocument @docHandle


/*2. ��������� ������ �� ������� StockItems � ����� �� xml-����, ��� StockItems.xml*/
SELECT TOP 100
    StockItemName AS [@Name],
    SupplierID AS [SupplierID],
    ColorID AS [ColorID],
    UnitPackageID AS [Package/UnitPackageID],
    OuterPackageID [Package/OuterPackageID],
	QuantityPerOuter AS [Package/QuantityPerOuter],
	TypicalWeightPerUnit AS [Package/TypicalWeightPerUnit],
    LeadTimeDays AS [LeadTimeDays],
	IsChillerStock AS [IsChillerStock],
	TaxRate AS [TaxRate],
	UnitPrice AS [UnitPrice]	
FROM Warehouse.StockItems
FOR XML PATH('Item'), ROOT('StockItems')

/*3. � ������� Warehouse.StockItems � ������� CustomFields ���� ������ � JSON.
�������� SELECT ��� ������:
- StockItemID
- StockItemName
- CountryOfManufacture (�� CustomFields)
- FirstTag (�� ���� CustomFields, ������ �������� �� ������� Tags)*/

select	StockItemID,
		StockItemName,
		JSON_VALUE(CustomFields, '$.CountryOfManufacture') AS CountryOfManufacture,
		JSON_VALUE(CustomFields, '$.Tags[0]') AS FirstTag
from Warehouse.StockItems

/*4. ����� � StockItems ������, ��� ���� ��� "Vintage".
�������:
- StockItemID
- StockItemName
- (�����������) ��� ���� (�� CustomFields) ����� ������� � ����� ����*/
select	StockItemID,
		StockItemName,
		tt.Tags
from Warehouse.StockItems
cross apply
(select JSON_QUERY(t.CustomFields, '$.Tags') as Tags
from Warehouse.StockItems as t
where StockItemID=t.StockItemID) as tt
where JSON_VALUE(CustomFields, '$.Tags')='Vintage'
group by StockItemID, StockItemName, tt.Tags

/*5. ����� ������������ PIVOT.
�� ������� �� ������� ���������� CROSS APPLY, PIVOT, CUBE�.
��������� �������� ������, ������� � ���������� ������ ���������� ��������� ������� ���������� ����:
�������� �������
�������� ���������� �������
����� �������� ������, ������� ����� ������������ ���������� ��� ���� ��������.
��� ������� ��������� ��������� �� CustomerName.
���� ������ ����� ������ dd.mm.yyyy �������� 01.12.2019 */
-----------------------------------------------------------------------------------------
create procedure Dynamic_Pivot
   (
        @TableSRC NVARCHAR(100),   --�������� �������
        @ColumnName NVARCHAR(100), --����� ��������
        @Field NVARCHAR(100),      --��� ������ ������� ���.�������
        @FieldRows NVARCHAR(100),  --������ �����������
        @FunctionType NVARCHAR(20),--������� � ������
        @Condition NVARCHAR(200) = '' --������� ���� ����
   )
   AS 
   BEGIN   
--������ �������
declare @Query nvarchar(max);                     
--����� ��������
declare @ColumnNames nvarchar(max);              
--��������� � ����������
declare @ColumnNamesHeader nvarchar(max); 
  
create table #ColumnNames(ColumnName nvarchar(100));
        
--������ ��� ���� ��������
set @Query = N'insert into #ColumnNames (ColumnName)
select distinct coalesce(' + @ColumnName + ', ''null'') 
from ' + @TableSRC + ' ' + @Condition + ';'
--���������
exec (@Query);
--�������� ������ � ������� ��������
select @ColumnNames = isnull(@ColumnNames + ', ','') + QUOTENAME(ColumnName) 
from #ColumnNames;             
--�������� ������ ��� pivot
select @ColumnNamesHeader = isnull(@ColumnNamesHeader + ', ','') 
+ 'coalesce('
+ QUOTENAME(ColumnName) 
+ ', 0) as '
 + QUOTENAME(ColumnName)
from #ColumnNames;       
--��������� ������ � �������� PIVOT
set @Query = N'select ' + @FieldRows + ' , ' + @ColumnNamesHeader + ' 
from (select ' + @FieldRows + ', ' + @ColumnName + ', ' + @Field 
		+ ' from ' + @TableSRC  + ' ' + @Condition + ') AS SRC
PIVOT ( ' + @FunctionType + '(' + @Field + ')' +' FOR ' +  
  @ColumnName + ' IN (' + @ColumnNames + ')) AS PVT
order by ' + @FieldRows + ';'
                
drop table #ColumnNames;
exec (@Query);
end
---------------------------------------------------------------------------------------------  
create table #SourceTable
(Customer nvarchar(100),
PurchaseMonth date,
QuantityPurchases int)
insert into #SourceTable (Customer,PurchaseMonth,QuantityPurchases)
(select TRIM(REPLACE(REPLACE(REPLACE(cust.CustomerName, 'Tailspin Toys', ''), '(',''), ')', '')) as Customer,
		CONVERT(nvarchar, DATEFROMPARTS(YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), 1 ), 104) as PurchaseMonth,
		COUNT(*) as QuantityPurchases
FROM Sales.Customers cust
	INNER JOIN Sales.Invoices AS inv
		ON inv.CustomerID = cust.CustomerID
WHERE cust.CustomerID<12
GROUP BY cust.CustomerName, DATEFROMPARTS(YEAR(inv.InvoiceDate), MONTH(inv.InvoiceDate), 1 ))

EXEC Dynamic_Pivot
@TableSRC= '#SourceTable',
@ColumnName= 'Customer',
@Field= 'QuantityPurchases', 
@FieldRows='PurchaseMonth',
@FunctionType= 'SUM'
