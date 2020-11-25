create database Payments
use Payments
GO
--таблица с информацией о пользователях
create table PaymentsUsers
(UserId INT IDENTITY PRIMARY KEY,
FullName NVARCHAR(50) NOT NULL,
Email NVARCHAR(20) NOT NULL,
Adress NVARCHAR(20) NOT NULL)

--таблица с информацией о карте
create table Cards
(CardID INT IDENTITY PRIMARY KEY NOT NULL,
CardNumber real NOT NULL,
CardUser INT FOREIGN KEY REFERENCES PaymentsUsers(UserId) NOT NULL,
Validity DATE NOT NULL,
Bank NVARCHAR(20) NOT NULL)

--таблица о внутренних статусах платежа
create table PaymentsStatus
(StatusID INT IDENTITY PRIMARY KEY NOT NULL,
StatusInfo NVARCHAR(20) NOT NULL,
ErrorDescription NVARCHAR(30) )

--таблица с информацией о платеже
create table Payments
(PaymentID INT IDENTITY PRIMARY KEY NOT NULL,
PaymentCard INT FOREIGN KEY REFERENCES Cards(CardID) NOT NULL,
UserName INT FOREIGN KEY REFERENCES PaymentsUsers(UserId) NOT NULL,
StatusInfo INT FOREIGN KEY REFERENCES PaymentsStatus(StatusID) NOT NULL,
PaymentDate DATETIME DEFAULT GETDATE() NOT NULL,
PaymentAmount MONEY NOT NULL)

--таблица с выведенными на проверку платежами
create table CheckPayments
(CheckPayID INT IDENTITY PRIMARY KEY NOT NULL,
PaymentID INT FOREIGN KEY REFERENCES Payments(PaymentID) NOT NULL,
CheckPayRule NVARCHAR(30) NOT NULL)

--ограничения по картам и пользователям
alter table Cards
ADD CONSTRAINT UQ_Cards UNIQUE (CardNumber)
alter table Cards
ADD CONSTRAINT CH_Date CHECK( Validity > CAST(GETDATE() as DATE)) 

alter table PaymentsUsers
ADD CONSTRAINT UQ_Email UNIQUE (Email)
--индексы на поля пользователей и банков
create index idx_fullname on PaymentsUsers(FullName)
create index idx_PaymentsBank on Cards(Bank)


