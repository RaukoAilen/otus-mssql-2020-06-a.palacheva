/*2) ����� ������� ��������� �� �����-������ ������, ��������������, ���������� dll, ������������������ �������������.*/

--����������
C:\Microsoft.NET\Framework\v2.0.50727\csc.exe /target:library C:\Users\Rauko Ailen\Documents\SplitString.cs

/*
--��� ��� clr
sp_configure 'clr enabled', 1
go
reconfigure
go

--�����������
CREATE ASSEMBLY CLRFunctions FROM 'C:\SplitString.dll'
go

--�������� �-�
CREATE FUNCTION [dbo].SplitStringCLR(@text [nvarchar](max), @delimiter [nchar](1))
RETURNS TABLE (
part nvarchar(max),
ID_ODER int
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME CLRFunctions.UserDefinedFunctions.SplitString*/