/*2) ¬з€ть готовые исходники из какой-нибудь статьи, скомпилировать, подключить dll, продемонстрировать использование.*/
--компил€ци€
--вкл исп clr
sp_configure 'clr enabled', 1
go
reconfigure
go

--подключение
CREATE ASSEMBLY CLRFunctions FROM 'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\SplitString.dll'
go

--создание ф-и
CREATE FUNCTION [dbo].SplitStringCLR(@text [nvarchar](max), @delimiter [nchar](1))
RETURNS TABLE (
part nvarchar(max),
ID_ODER int
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME CLRFunctions.UserDefinedFunctions.SplitString

----------------------------------------------------------
select* from SplitStringCLR('1/2/3/4/5/6/7/8/9', '/')