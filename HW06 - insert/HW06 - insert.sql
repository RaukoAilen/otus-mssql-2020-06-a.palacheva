/*1. ����������� � ���� 5 ������� ��������� insert � ������� Customers ��� Suppliers*/

INSERT INTO Purchasing.Suppliers
			(SupplierID
           ,SupplierName
           ,SupplierCategoryID
           ,PrimaryContactPersonID
           ,AlternateContactPersonID
           ,DeliveryMethodID
           ,DeliveryCityID
           ,PostalCityID
           ,SupplierReference
           ,BankAccountName
           ,BankAccountBranch
           ,BankAccountCode
           ,BankAccountNumber
           ,BankInternationalCode
           ,PaymentDays
           ,InternalComments
           ,PhoneNumber
           ,FaxNumber
           ,WebsiteURL
           ,DeliveryAddressLine1
           ,DeliveryAddressLine2
           ,DeliveryPostalCode
           ,PostalAddressLine1
           ,PostalAddressLine2
           ,PostalPostalCode
           ,LastEditedBy)
VALUES
	(NEXT VALUE FOR Sequences.SupplierID,'NEW1',1,1,1,1,1,1,'NEW','NEW','NEW','NEW','NEW','NEW',1,'NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW' ,'NEW',1),
	(NEXT VALUE FOR Sequences.SupplierID,'NEW2',1,1,1,1,1,1,'NEW','NEW','NEW','NEW','NEW','NEW',1,'NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW' ,'NEW',1),
	(NEXT VALUE FOR Sequences.SupplierID,'NEW3',1,1,1,1,1,1,'NEW','NEW','NEW','NEW','NEW','NEW',1,'NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW' ,'NEW',1),
	(NEXT VALUE FOR Sequences.SupplierID,'NEW4',1,1,1,1,1,1,'NEW','NEW','NEW','NEW','NEW','NEW',1,'NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW' ,'NEW',1),
	(NEXT VALUE FOR Sequences.SupplierID,'NEW5',1,1,1,1,1,1,'NEW','NEW','NEW','NEW','NEW','NEW',1,'NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW','NEW' ,'NEW',1);

/*2. ������� 1 ������ �� Customers, ������� ���� ���� ���������*/

DELETE FROM Purchasing.Suppliers
WHERE EXISTS (SELECT 1 
	FROM Purchasing.Suppliers
	WHERE SupplierName LIKE 'NEW%');


/*3. �������� ���� ������, �� ����������� ����� UPDATE*/

Update Purchasing.Suppliers
SET 
	DeliveryAddressLine1 = 'mirkwood'
WHERE EXISTS (SELECT 1 
	FROM Purchasing.Suppliers
	WHERE SupplierName LIKE 'NEW%');

/*4. �������� MERGE, ������� ������� ������� ������ � �������, ���� �� ��� ���, � ������� ���� ��� ��� ����*/

MERGE Application.People AS target 
	USING (SELECT SupplierID
      ,SupplierName
  FROM Purchasing.Suppliers
		) 
		AS source (SupplierID,SupplierName) 
		ON
	 (target.PersonID = source.SupplierID) 
	WHEN MATCHED 
		THEN UPDATE SET FullName = source.SupplierName
	WHEN NOT MATCHED 
		THEN INSERT (PersonID,FullName,PreferredName,IsPermittedToLogon,IsExternalLogonProvider,IsSystemUser,IsEmployee,IsSalesperson,LastEditedBy) 
			VALUES (source.SupplierID,source.SupplierName,source.SupplierName,0,0,0,0,0,1);

/*5. �������� ������, ������� �������� ������ ����� bcp out � ��������� ����� bulk insert */

 
EXEC sp_configure 'show advanced options', 1;  
GO  

RECONFIGURE;  
GO  

EXEC sp_configure 'xp_cmdshell', 1;  
GO  

RECONFIGURE;  
GO  

SELECT @@SERVERNAME
--JACK\SQL2017
exec master..xp_cmdshell 'bcp "[WideWorldImporters].[Application].[People]" out  "C:\Users\Rauko Ailen\Documents\SQL Server Management Studio\EXZ\wwi.ap.txt" -T -w -t"@eu&$1&" -S VIC-JACK\SQL2017'

---------------------------------------------
CREATE TABLE Application.PeopleNew(
	[PersonID] [int] NOT NULL,
	[FullName] [nvarchar](50) NOT NULL,
	[PreferredName] [nvarchar](50) NOT NULL,
	[SearchName]  AS (concat([PreferredName],N' ',[FullName])) PERSISTED NOT NULL,
	[IsPermittedToLogon] [bit] NOT NULL,
	[LogonName] [nvarchar](50) NULL,
	[IsExternalLogonProvider] [bit] NOT NULL,
	[HashedPassword] [varbinary](max) NULL,
	[IsSystemUser] [bit] NOT NULL,
	[IsEmployee] [bit] NOT NULL,
	[IsSalesperson] [bit] NOT NULL,
	[UserPreferences] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](256) NULL,
	[Photo] [varbinary](max) NULL,
	[CustomFields] [nvarchar](max) NULL,
	[OtherLanguages]  AS (json_query([CustomFields],N'$.OtherLanguages')),
	[LastEditedBy] [int] NOT NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [PK_Application_PeopleNew] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [USERDATA],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [USERDATA] TEXTIMAGE_ON [USERDATA]
-----------------------------------------------------------------
BULK INSERT [WideWorldImporters].Application.PeopleNew
				   FROM "C:\Users\Rauko Ailen\Documents\SQL Server Management Studio\EXZ\wwi.ap.txt"
				   WITH 
					 (
						BATCHSIZE = 1000, 
						DATAFILETYPE = 'widechar',
						FIELDTERMINATOR = '@eu&$1&',
						ROWTERMINATOR ='\n',
						KEEPNULLS,
						TABLOCK        
					  );