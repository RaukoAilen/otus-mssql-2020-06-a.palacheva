/*2) ����� ������� ��������� �� �����-������ ������, ��������������, ���������� dll, ������������������ �������������.*/
--����������
--��� ��� clr
sp_configure 'clr enabled', 1
go
reconfigure
go

--�����������
CREATE ASSEMBLY CLRFunctions FROM 'C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\SplitString.dll'
go

--�������� �-�
CREATE FUNCTION [dbo].SplitStringCLR(@text [nvarchar](max), @delimiter [nchar](1))
RETURNS TABLE (
part nvarchar(max),
ID_ODER int
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME CLRFunctions.UserDefinedFunctions.SplitString

----------------------------------------------------------
select* from SplitStringCLR('1/2/3/4/5/6/7/8/9', '/')