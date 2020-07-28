use master
go
if DB_ID('TestWork') is not null
	drop database TestWork
create database TestWork
go
use TestWork
go
if OBJECT_ID('dbo.Tenants','U') is not null
	drop table dbo.Tenants
create table dbo.Tenants
(
	TenantId int not null identity,
	TenantName nvarchar(128) not null,
	TenantAdress nvarchar(128),
	constraint PK_Tenants primary key(TenantId)
)

if OBJECT_ID('dbo.Contracts','U') is not null
	drop table dbo.Contracts
create table dbo.Contracts
(
	ContractId int not null identity,
	ContracNumber nvarchar(64) not null,
	ContractStartRent date,
	ContractEndRent date,
	ContractRatePerMonth decimal,
	DecisionNumber nvarchar(128),	
	TenantId int not null,
	constraint PK_Contract primary key(ContractId),	
	constraint FK_TenantId  foreign key (TenantId ) references Tenants(TenantId )	
)
if OBJECT_ID('dbo.RentObjects','U') is not null
	drop table dbo.RentObjects
create table dbo.RentObjects
(
	RentObjectId int not null identity,
	RentObjectAdress nvarchar(128) not null,
	RentObjectSquare decimal default 0,	
	constraint PK_RentObject primary key(RentObjectId)
)
if OBJECT_ID('dbo.RentObjectContracts','U') is not null
	drop table dbo.RentObjectContracts
create table dbo.RentObjectContracts
(
	RentObjectId int not null,	
	ContractId int not null	
	constraint PK_RentObjectContracts primary key(RentObjectId,ContractId),
	constraint FK_RentObjectContracts_RentObjectId foreign key (RentObjectId) references RentObjects(RentObjectId),
	constraint FK_RentObjectContracts_ContractId  foreign key (ContractId) references Contracts(ContractId )	
)

if OBJECT_ID('dbo.RentalAccrual','U') is not null
	drop table dbo.RentalAccrual
create table dbo.RentalAccrual
(
	RentalAccrualId int not null identity,
	Period date not null,
	AccrualDate date not null,
	ContractId int not null,	
	SumAccural decimal,	
	constraint PK_RentalAccrual primary key(RentalAccrualId),	
	constraint FK_RentalAccrual_ContractId  foreign key (ContractId ) references Contracts(ContractId )	
)
if OBJECT_ID('dbo.RentPayments','U') is not null
	drop table dbo.RentPayments
create table dbo.RentPayments
(
	RentPaymentId int not null identity,	
	PaymentDate date not null,	
	TenantId int not null,		
	SumPayment decimal,
	RentalAccrualId int not null,
	constraint PK_RentPayments primary key(RentPaymentId),
	constraint FK_RentPayments_RentalAccrualId  foreign key (RentalAccrualId ) references RentalAccrual(RentalAccrualId ),
	constraint FK_RentPayments_TenantId foreign key (TenantId) references Tenants(TenantId)
)

