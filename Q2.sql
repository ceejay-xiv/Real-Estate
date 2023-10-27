SPOOL D:\Q2.TXT

SET VERIFY ON
SET ECHO ON
SET SERVEROUTPUT ON

DROP VIEW CRF_MINING_DATA_APPLY_V;
DROP VIEW CRF_MINING_DATA_BUILD_V;
DROP VIEW CRF_MINING_DATA_TEST_V;
DROP TABLE CREDITCARDS CASCADE CONSTRAINT PURGE;

REM CLEANING THE DATASET TO REMOVE ERRONEOUS DATA SUCH AS UNLISTED EDUCATION LEVELS AND MARITAL_STATUS

CREATE TABLE CREDITCARDS AS 
SELECT * FROM CREDITCARDSV2 WHERE MARITAL_STATUS !=0 AND EDULEVEL BETWEEN 1 AND 4;

REM CREATING BUILD TEST AND APPLY VIEWS

CREATE OR REPLACE VIEW CRF_MINING_DATA_APPLY_V AS
SELECT * FROM (SELECT CRF.*, ROW_NUMBER() OVER (ORDER BY CRF.CARD) AS SPLIT_DT FROM CREDITCARDS CRF) WHERE SPLIT_DT<= 20000; 

CREATE OR REPLACE VIEW CRF_MINING_DATA_BUILD_V AS
SELECT * FROM (SELECT CRF.*, ROW_NUMBER() OVER (ORDER BY CRF.CARD) AS SPLIT_DT FROM CREDITCARDS CRF) WHERE SPLIT_DT BETWEEN 20001 AND 25000;  

CREATE OR REPLACE VIEW CRF_MINING_DATA_TEST_V AS
SELECT * FROM (SELECT CRF.*, ROW_NUMBER() OVER (ORDER BY CRF.CARD) AS SPLIT_DT FROM CREDITCARDS CRF) WHERE SPLIT_DT BETWEEN 25001 AND 30000;

SPOOL OFF