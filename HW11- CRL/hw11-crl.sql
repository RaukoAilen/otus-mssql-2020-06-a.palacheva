/*2) ¬з€ть готовые исходники из какой-нибудь статьи, скомпилировать, подключить dll, продемонстрировать использование.*/

--компил€ци€
C:\Microsoft.NET\Framework\v2.0.50727\csc.exe /target:library C:\Users\Rauko Ailen\Documents\SplitString.cs

/*
--вкл исп clr
sp_configure 'clr enabled', 1
go
reconfigure
go

--подключение
CREATE ASSEMBLY CLRFunctions FROM 'C:\SplitString.dll'
go

--создание ф-и
CREATE FUNCTION [dbo].SplitStringCLR(@text [nvarchar](max), @delimiter [nchar](1))
RETURNS TABLE (
part nvarchar(max),
ID_ODER int
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME CLRFunctions.UserDefinedFunctions.SplitString*/