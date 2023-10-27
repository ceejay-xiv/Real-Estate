SPOOL D:\GLM.TXT

SET VERIFY ON
SET ECHO ON
SET SERVEROUTPUT ON
REM Creating and Populating a table for setting target models attributes

DROP TABLE glm_model_crf_settings CASCADE CONSTRAINTS PURGE;

CREATE TABLE glm_model_crf_settings(
setting_name VARCHAR2(30),
setting_value VARCHAR2(30)
);

REM POPULATE THE SETTINGS TABLE

BEGIN
    insert into glm_model_crf_settings VALUES
        (dbms_data_mining.algo_name, dbms_data_mining.algo_generalized_linear_model);
    insert into glm_model_crf_settings VALUES
        (dbms_data_mining.prep_auto, dbms_data_mining.prep_auto_on);
    COMMIT;
END;
/

BEGIN
  DBMS_DATA_MINING.DROP_MODEL(model_name => 'glm_model_crf');
END;
/

REM Creating the model using the specified settings

BEGIN
    DBMS_DATA_MINING.CREATE_MODEL(
    model_name => 'glm_model_crf',
    mining_function => DBMS_DATA_MINING.classification,
    data_table_name => 'crf_mining_data_build_v',
    case_id_column_name => 'card',
    target_column_name => 'DEFAULTPAYNXTMNT',
    settings_table_name => 'glm_model_crf_settings');
END;
/

REM Testing the model 

SELECT DEFAULTPAYNXTMNT AS Actuals,
    PREDICTION(glm_model_crf USING*) AS Predicted,
    COUNT(*) AS TOTALS
FROM crf_mining_data_test_v
GROUP BY DEFAULTPAYNXTMNT, PREDICTION(glm_model_crf USING*)
ORDER BY 1,2;

REM calculating model accuracy

COLUMN ACCURACY FORMAT 99.99
SELECT (SUM(CORRECT)/COUNT(*))*100 AS ACCURACY
FROM (SELECT DECODE(DEFAULTPAYNXTMNT, PREDICTION(glm_model_crf using *), 1, 0)AS CORRECT
     FROM crf_mining_data_test_v);
     
SPOOL OFF