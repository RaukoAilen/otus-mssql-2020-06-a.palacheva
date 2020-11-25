--�-� ��� ������, �������������� ��������, ���� ������� � �-� ��������� ������� �� ����� ���������,
--������� ������ �� ������������� ��������
create procedure PR_fraudcheck
@Fraudrule nvarchar(30)
WITH EXECUTE AS CALLER  
AS   
    set NOCOUNT ON;  
	select 	c.PaymentID,
			p.PaymentDate,
			p.UserName,
			p.PaymentCard,
			b.Bank
	from CheckPayments as c
			join Payments as p on c.PaymentID=p.PaymentID
			join Cards as b on b.CardID=p.PaymentCard
	where c.Fraudrule = @Fraudrule
GO 

exec PR_fraudcheck('')

--��������
--��� ���������� ������� ��������� ������ � ������� ��������, � ��������� �� ������ ������� ��� ������ ����
-- ������� ������������� �� ���������� ����� 20 �������� �� �����.
create trigger CHECK20paysday on Payments
after insert
	as
	begin
	if
	(
	select count(PaymentID)
	from Payments
	where	(select PaymentCard from inserted)  = PaymentCard
			and CAST(PaymentDate AS date) = (select CAST(PaymentDate AS date) from inserted)
	) > 20
	insert into CheckPayments(PaymentID,CheckPayRule)
	select PaymentID, 'CHECK20paysday' from inserted
	end

-- ������� �� �������������� ������ ����� 10 000
create trigger CHECKonepay on Payments
after insert
	as
	begin
	if 
	(select PaymentAmount from inserted) > 10000
	insert into CheckPayments(PaymentID,CheckPayRule)
	select PaymentID, 'CHECKonepay' from inserted
	end

-- ������� �� ����� �������� � ����� ����� 30 000
create trigger CHECKsumm30sday on Payments
after insert
	as
	begin
	if 
	(
	select sum(PaymentAmount)
	from Payments
	where	(select PaymentCard from inserted)  = PaymentCard
			and CAST(PaymentDate AS date) = (select CAST(PaymentDate AS date) from inserted)
	)
	> 30000
	insert into CheckPayments(PaymentID,CheckPayRule)
	select PaymentID, 'CHECK20paysday' from inserted
	end

-- ����� ������ ��� �� ����� �����
create trigger CHECKcards_user on Payments
after insert
	as
	begin
	if 
	(select distinct count(UserName)
	from Payments
	where (select PaymentCard from inserted)  = PaymentCard) >= 2
	insert into CheckPayments(PaymentID,CheckPayRule)
	select PaymentID, 'CHECKcards_user' from inserted
	end