-- There are some differences from the original queries in the book, Here's why:
-- To fix the conflict problem when inserting Employees, we allow the Dno value in employee table to be NULL.
-- Another change we made was adding EmpDeptFK constraint after creating Department table.

create table Company.Employee (
	Fname varchar(15) not null,
	Minit char,
	Lname varchar(15) not null,
	Ssn char(9) not null,
	Bdate date,
	Address varchar(30),
	Sex char,
	Salary decimal(10,2),
	Super_ssn char(9),
	Dno int,
	constraint EmpPK primary key (Ssn),
	constraint EmpSuperFK foreign key (Super_ssn) references Company.Employee(Ssn)
);

create table Company.Department (
	Dname varchar(15) not null,
	Dnumber int not null,
	Mgr_ssn char(9) not null default '888665555',
	Mgr_start_date date,
	constraint DeptPK primary key (Dnumber),
	constraint DeptSK unique (Dname),
	constraint DeptMgrFK foreign key (Mgr_ssn) references Company.Employee(Ssn)
);

alter table Company.Employee add constraint EmpDeptFK foreign key (Dno) references Company.Department(Dnumber) on delete set default on update cascade;

create table Company.Dept_Locations (
	Dnumber int not null,
	Dlocation varchar(15) not null,
	constraint DeptLocPK primary key (Dnumber, Dlocation),
	constraint DeptLocDnoFK foreign key (Dnumber) references Company.Department(Dnumber)
		on delete cascade
		on update cascade
);

create table Company.Project (
	Pname varchar(15) not null,
	Pnumber int not null,
	Plocation varchar(15),
	Dnum int not null,
	constraint ProjPK primary key (Pnumber),
	unique (Pname),
	constraint ProjDnoFK foreign key (Dnum) references Company.Department(Dnumber)
);

create table Company.Works_On (
	Essn char(9) not null,
	Pno int not null,
	Hours decimal(3,1),
	constraint WOPK primary key (Essn, Pno),
	constraint WOEmpFK foreign key (Essn) references Company.Employee(Ssn)
		on delete cascade
		on update cascade,
	constraint WOProjFK foreign key (Pno) references Company.Project(Pnumber)
		on delete cascade
		on update cascade
);

create table Company.Dependent (
	Essn char(9) not null,
	Dependent_name varchar(15) not null,
	Sex char,
	Bdate date,
	Relationship varchar(8),
	constraint DepPK primary key (Essn, Department_name),
	constraint DepEmpFK foreign key (Essn) references Company.Employee(Ssn)
		on delete cascade
		on update cascade
);