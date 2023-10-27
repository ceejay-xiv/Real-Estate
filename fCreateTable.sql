Set Echo on
Set Verify on

DROP TABLE ESTATE_AGENT CASCADE CONSTRAINTS purge;
DROP TABLE STAFF CASCADE CONSTRAINTS purge;
DROP TABLE CONTACT CASCADE CONSTRAINTS purge;
DROP TABLE ADDRESS CASCADE CONSTRAINTS purge;
DROP TABLE BRANCH CASCADE CONSTRAINTS purge;
DROP TABLE CUSTOMER CASCADE CONSTRAINTS purge;
DROP TABLE PROPERTY CASCADE CONSTRAINTS purge;
DROP TABLE PROPERTY_DESC CASCADE CONSTRAINTS purge;
DROP TABLE PROP_RENTED CASCADE CONSTRAINTS purge;
DROP TABLE PROP_SOLD CASCADE CONSTRAINTS purge;
DROP TABLE REGISTERS_PROPERTY CASCADE CONSTRAINTS purge;
DROP TABLE ARRANGED_VIEWING_BY CASCADE CONSTRAINTS purge;
DROP TABLE S_CONTACT CASCADE CONSTRAINTS purge;
DROP TABLE C_CONTACT CASCADE CONSTRAINTS purge;
DROP TABLE B_CONTACT CASCADE CONSTRAINTS purge;
DROP TABLE STAFF_ADDRESS CASCADE CONSTRAINTS purge;
DROP TABLE CUSTOMER_ADDRESS CASCADE CONSTRAINTS purge;
DROP TABLE BRANCH_ADDRESS CASCADE CONSTRAINTS purge;
DROP TABLE PROPERTY_ADDRESS CASCADE CONSTRAINTS purge;


CREATE TABLE ESTATE_AGENT(
    EA_ID CHAR(3),
        CONSTRAINT AGENT_ID PRIMARY KEY(EA_ID),
    EANAME VARCHAR(24) UNIQUE, 
    WEBSITE VARCHAR(24) UNIQUE );
    
CREATE TABLE STAFF(
    STAFF_ID CHAR(6),
        CONSTRAINT STAFF_KEY PRIMARY KEY(STAFF_ID),
    F_NAME VARCHAR(10),
    L_NAME VARCHAR(10),
    DOB DATE, CONSTRAINT CHK_DATE_S CHECK(DOB BETWEEN DATE '1900-01-01' AND DATE '2005-01-01'),
    GENDER CHAR(1),
        CONSTRAINT GEN_STAFF CHECK (GENDER IN ('M','F','O')),
    EA_ID CHAR(3) CONSTRAINT AGENT_FK REFERENCES ESTATE_AGENT(EA_ID),
    BRANCH_ID CHAR(6));

CREATE TABLE BRANCH(
    BRANCH_ID CHAR(3),
        CONSTRAINT BRANCH_KEY PRIMARY KEY(BRANCH_ID),
    BRANCH_TYPE CHAR(2) CONSTRAINT B_TYPE CHECK(BRANCH_TYPE IN ('HQ','BR')),
    EA_ID CHAR(3) CONSTRAINT AGENT_FK_BRANCH REFERENCES ESTATE_AGENT(EA_ID),
    STAFF_ID CHAR(6) CONSTRAINT STAFF_FK_BRANCH REFERENCES STAFF(STAFF_ID));
    
CREATE TABLE CUSTOMER(
    CUSTOMER_ID CHAR(6),
        CONSTRAINT CUST_ID PRIMARY KEY(CUSTOMER_ID),
    F_NAME VARCHAR(10),
    L_NAME VARCHAR(10),
    DOB DATE, CONSTRAINT CHK_DATE_C CHECK(DOB BETWEEN DATE '1900-01-01' AND DATE '2005-01-01'),
    GENDER Char(1)
        CONSTRAINT GEN_CUST CHECK (GENDER IN ('M','F','O')),
    CUST_TYPE CHAR(8) CONSTRAINT CHECK_CUST_TYPE CHECK(CUST_TYPE IN ('LANDLORD','TENANT','BUYER')));

CREATE TABLE PROPERTY(
    PROP_ID CHAR(6),
        CONSTRAINT PROPERTY_KEY PRIMARY KEY(PROP_ID),
    REGISTERED DATE,
    LANDLORD_ID CHAR(6),
        CONSTRAINT IS_LANDLORD FOREIGN KEY(LANDLORD_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
    ASKINGPRICE NUMBER(6));

CREATE TABLE PROPERTY_DESC(
    PROP_ID CHAR(6) CONSTRAINT PROP_DSC REFERENCES PROPERTY(PROP_ID),
    PROPDESC_ID CHAR(6),
        CONSTRAINT PROPDESC_KEY PRIMARY KEY(PROPDESC_ID),
    PROP_TYPE VARCHAR(25),
        CONSTRAINT PROP_CTGR CHECK (PROP_TYPE IN ('Purpose-built flat','Converted flat','Studio flat','Maisonette','Bungalow','Cottage','Terraced House','Semi-detached house','Detached house','Mansion house')),
    PROP_DESC VARCHAR(255),
    FURNISHED CHAR(1),
        CONSTRAINT FURNISH_CHK CHECK (FURNISHED IN ('Y','N')),
    AREA FLOAT(2),
    ACCESSIBILITY CHAR(4) CONSTRAINT ACCESSIBILITY_CHK CHECK (ACCESSIBILITY IN ('GOOD','MED','BAD')),
    NO_OF_ROOMS CHAR(2) );

CREATE TABLE ARRANGED_VIEWING_BY(
    PROP_ID CHAR(6) CONSTRAINT PROP_AVB REFERENCES PROPERTY(PROP_ID),
    CUSTOMER_ID CHAR(6) CONSTRAINT BUYER_AVB REFERENCES CUSTOMER (CUSTOMER_ID),
    BRANCH_ID CHAR(3)
      CONSTRAINT BRANCH_AVB REFERENCES BRANCH (BRANCH_ID),
    VIEW_DATE TIMESTAMP,
    APPRECIATION VARCHAR(8),
	CONSTRAINT APPRECIATION_CHK CHECK (APPRECIATION IN ('GREAT','GOOD','OKAY','BAD','TERRIBLE')),
    CONSTRAINT ARRANGED_VIEWING_BY_ID PRIMARY KEY (PROP_ID, CUSTOMER_ID, BRANCH_ID)   );

CREATE TABLE PROP_RENTED(
    PROP_ID CHAR(6) CONSTRAINT PROP_RFK REFERENCES PROPERTY(PROP_ID),
    TENANT_ID CHAR(6),
        CONSTRAINT TENANT_RFK FOREIGN KEY(TENANT_ID) REFERENCES CUSTOMER (CUSTOMER_ID),
    CONSTRAINT PROP_RENTED_ID PRIMARY KEY (PROP_ID, TENANT_ID),
    START_DATE DATE,
    END_DATE DATE,
    CONSTRAINT CHK_LEASE_PERIOD CHECK (START_DATE < END_DATE ),
    RENT_PCM NUMBER(6),
    DEPOSIT NUMBER(5),
    CONSTRAINT DEP CHECK (DEPOSIT > (RENT_PCM * 0.05)),
    COMMISSION NUMBER(5),
    CONSTRAINT COM CHECK (COMMISSION > (RENT_PCM * 0.014)) );

CREATE TABLE PROP_SOLD(
    PROP_ID CHAR(6) CONSTRAINT PROP_SFK REFERENCES PROPERTY(PROP_ID),
    BUYER_ID CHAR(6) CONSTRAINT BUYER_SFK REFERENCES CUSTOMER (CUSTOMER_ID),
    CONSTRAINT PROP_SOLD_ID PRIMARY KEY (PROP_ID, BUYER_ID),
	SOLDDATE DATE,
    SELLING_PRICE NUMBER(6),
    COMMISSION NUMBER(5),
    CONSTRAINT COM_S CHECK (COMMISSION > (SELLING_PRICE * 0.014)),
    STAMPDUTY NUMBER(5),
    CONSTRAINT STMPDT CHECK (STAMPDUTY >= (SELLING_PRICE * 0.02)) );
    
CREATE TABLE S_CONTACT(
    STAFF_ID CHAR(6),
        CONSTRAINT STAFF_C_FK FOREIGN KEY(STAFF_ID) REFERENCES STAFF(STAFF_ID),
    S_CONTACT_ID CHAR(6), CONSTRAINT S_CONTACT_KEY PRIMARY KEY (S_CONTACT_ID),
    S_TEL_NUMBER CHAR(11) CONSTRAINT S_PHONE CHECK(REGEXP_LIKE(S_TEL_NUMBER, '[0-9] {11}')) UNIQUE,
    S_EMAIL VARCHAR(30) CONSTRAINT S_CHK_EMAIL CHECK(S_EMAIL LIKE '%_@__%.__%') UNIQUE);

CREATE TABLE C_CONTACT(
    CUSTOMER_ID CHAR(6),
        CONSTRAINT CUSTOMER_C_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
    C_CONTACT_ID CHAR(6), CONSTRAINT C_CONTACT_KEY PRIMARY KEY (C_CONTACT_ID),
    C_TEL_NUMBER CHAR(11) CONSTRAINT C_PHONE CHECK(REGEXP_LIKE(C_TEL_NUMBER, '[0-9] {11}')) UNIQUE,
    C_EMAIL VARCHAR(30) CONSTRAINT C_CHK_EMAIL CHECK(C_EMAIL LIKE '%_@__%.__%') UNIQUE);
    
CREATE TABLE B_CONTACT(
    BRANCH_ID CHAR(6),
        CONSTRAINT BRANCH_C_FK FOREIGN KEY(BRANCH_ID) REFERENCES BRANCH(BRANCH_ID),
    B_CONTACT_ID CHAR(6), CONSTRAINT B_CONTACT_KEY PRIMARY KEY (B_CONTACT_ID),
    B_TEL_NUMBER CHAR(11) CONSTRAINT B_PHONE CHECK(REGEXP_LIKE(B_TEL_NUMBER, '[0-9] {11}')) UNIQUE,
    B_EMAIL VARCHAR(30) CONSTRAINT B_CHK_EMAIL CHECK(B_EMAIL LIKE '%_@__%.__%') UNIQUE);
                                         
CREATE TABLE STAFF_ADDRESS(
    STAFF_ID CHAR(6),
        CONSTRAINT STAFF_A_FK FOREIGN KEY(STAFF_ID) REFERENCES STAFF(STAFF_ID),
    S_ADDRESS_ID CHAR(6) CONSTRAINT S_ADDRESS_KEY PRIMARY KEY,
    SUBURB VARCHAR(20),
    CITY VARCHAR(20),
    POSTCODE VARCHAR(7) );
    
CREATE TABLE CUSTOMER_ADDRESS(
    CUSTOMER_ID CHAR(6),
        CONSTRAINT CUSTOMER_A_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
    C_ADDRESC_ID CHAR(6) CONSTRAINT C_ADDRESC_KEY PRIMARY KEY,
    SUBURB VARCHAR(20),
    CITY VARCHAR(20),
    POSTCODE VARCHAR(7) );
    
CREATE TABLE BRANCH_ADDRESS(
    BRANCH_ID CHAR(6),
        CONSTRAINT BRANCH_A_FK FOREIGN KEY(BRANCH_ID) REFERENCES BRANCH(BRANCH_ID),
    B_ADDRESB_ID CHAR(6) CONSTRAINT B_ADDRESB_KEY PRIMARY KEY,
    SUBURB VARCHAR(20),
    CITY VARCHAR(20),
    POSTCODE VARCHAR(7) );
    
CREATE TABLE PROPERTY_ADDRESS(
    PROP_ID CHAR(6),
        CONSTRAINT PROPERTY_A_FK FOREIGN KEY(PROP_ID) REFERENCES PROPERTY(PROP_ID),
    P_ADDRESP_ID CHAR(6) CONSTRAINT P_ADDRESP_KEY PRIMARY KEY,
    SUBURB VARCHAR(20),
    CITY VARCHAR(20),
    POSTCODE VARCHAR(7) );
               
                                                    
ALTER TABLE STAFF ADD CONSTRAINT BRANCH_ID_STAFF FOREIGN KEY(STAFF_ID) REFERENCES BRANCH(BRANCH_ID);


