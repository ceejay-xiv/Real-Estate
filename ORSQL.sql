drop type cust_typ force;
drop type property_nt force;
drop type prop_rented_nt force;
drop type prop_sold_nt force;
drop type Prop_reg;
drop type Prop_bought;
drop type Prop_leased;
drop type landlord;
drop type tenant;
drop type buyer;
drop table landlord_tab cascade constraints purge;
drop table buyer_tab cascade constraints purge;
drop table tenant_tab cascade constraints purge;
drop table PROPERTY_tab cascade constraints purge;
drop table PropSold_tab cascade constraints purge;
drop table PropRented_tab cascade constraints purge;


CREATE OR Replace Type Property_NT as Object
		(propID char(3),
		 regDate Date,
		 askingPrice number(6))NOT FINAL;	 
/

Create or replace Type Prop_sold_NT UNDER Property_NT
    (soldDate Date,
    sellingPrice number(6),
    commission number(5),
    stampDuty number(5));
/

Create or replace type Prop_rented_NT UNDER Property_NT
        (startDate Date,
        EndDate Date,
        rentPCM number(6),
        commission number(5),
        Deposit number(5))
/

Create type Prop_reg as Table of REF Property_NT
/
Create type Prop_bought as Table of REF Prop_sold_NT
/
Create type Prop_leased as Table of REF Prop_rented_NT
/

Create or replace Type Cust_typ AS OBJECT(
CustomerID char(3),
Fname varchar(12),
Lname varchar(12),
DOB date,
Gender char(1))NOT FINAL;
/

CREATE or replace Type landlord under Cust_typ
    (ownership char(10),
    reg Prop_reg)
/

CREATE or replace Type buyer under Cust_typ
    (dbs char(10),
    bought Prop_bought)
/

CREATE or replace Type tenant under Cust_typ
    (guarantor char(10),
     leased Prop_leased)
/


Alter Type Property_NT add attribute reg_by ref landlord cascade
/
Alter Type Prop_sold_NT add attribute bought_by ref buyer cascade
/
Alter Type Prop_rented_NT add attribute rented_by ref tenant cascade
/



Create Table landlord_tab of landlord (PRIMARY KEY(CustomerID))
Nested Table reg store As RegisteredProp
/

Create Table buyer_tab of buyer (PRIMARY KEY(CustomerID))
Nested Table bought store As BoughtProp
/

Create Table tenant_tab of tenant (PRIMARY KEY(CustomerID))
Nested Table leased store As LeasedProp
/

Create Table PropSold_tab of Prop_sold_NT 
(PRIMARY KEY(PropID),
 FOREIGN KEY(bought_by) references buyer_tab)
/

Create Table PropRented_tab of Prop_rented_NT 
(PRIMARY KEY(PropID),
 FOREIGN KEY(rented_by) references tenant_tab)
/

Create Table Property_tab of Property_NT 
(PRIMARY KEY(PropID),
 FOREIGN KEY(reg_by) references landlord_tab)
/
