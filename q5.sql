SPOOL D:\q5.TXT
CREATE OR REPLACE VIEW EDU_CUSTOMERS_SVM AS 
SELECT CARD
FROM (SELECT CARD, RANK() OVER (ORDER BY 
        PREDICTION_PROBABILITY(svm_model_crf, 1 USING *) DESC, CARD) SPLIT_DT
    FROM CRF_MINING_DATA_APPLY_V)
WHERE SPLIT_DT<=1000
ORDER BY SPLIT_DT;

CREATE OR REPLACE VIEW EDU_CUSTOMERS_DT AS 
SELECT CARD
FROM (SELECT CARD, RANK() OVER (ORDER BY 
        PREDICTION_PROBABILITY(dt_model_crf, 1 USING *) DESC, CARD) SPLIT_DT
    FROM CRF_MINING_DATA_APPLY_V)
WHERE SPLIT_DT<=1000
ORDER BY SPLIT_DT;

CREATE OR REPLACE VIEW EDU_CUSTOMERS_RF AS 
SELECT CARD
FROM (SELECT CARD, RANK() OVER (ORDER BY 
        PREDICTION_PROBABILITY(rf_model_crf, 1 USING *) DESC, CARD) SPLIT_DT
    FROM CRF_MINING_DATA_APPLY_V)
WHERE SPLIT_DT<=1000
ORDER BY SPLIT_DT;

CREATE OR REPLACE VIEW EDU_CUSTOMERS_NB AS 
SELECT CARD
FROM (SELECT CARD, RANK() OVER (ORDER BY 
        PREDICTION_PROBABILITY(nb_model_crf, 1 USING *) DESC, CARD) SPLIT_DT
    FROM CRF_MINING_DATA_APPLY_V)
WHERE SPLIT_DT<=1000
ORDER BY SPLIT_DT;

CREATE OR REPLACE VIEW EDU_CUSTOMERS_GLM AS 
SELECT CARD
FROM (SELECT CARD, RANK() OVER (ORDER BY 
        PREDICTION_PROBABILITY(glm_model_crf, 1 USING *) DESC, CARD) SPLIT_DT
    FROM CRF_MINING_DATA_APPLY_V)
WHERE SPLIT_DT<=1000
ORDER BY SPLIT_DT;

CREATE OR REPLACE VIEW EDU_CUSTOMERS_NN AS 
SELECT CARD
FROM (SELECT CARD, RANK() OVER (ORDER BY 
        PREDICTION_PROBABILITY(nn_model_crf, 1 USING *) DESC, CARD) SPLIT_DT
    FROM CRF_MINING_DATA_APPLY_V)
WHERE SPLIT_DT<=1000
ORDER BY SPLIT_DT;

SELECT (COUNT(CARD)/10) AS PERCENTAGE_SVM_PRED , EDULEVEL, MARITAL_STATUS, GENDER FROM CREDITCARDS WHERE CARD IN (SELECT * FROM EDU_CUSTOMERS_SVM)GROUP BY EDULEVEL, MARITAL_STATUS, GENDER ORDER BY COUNT(CARD) DESC;

SELECT (COUNT(CARD)/10) AS PERCENTAGE_DT_PRED , EDULEVEL, MARITAL_STATUS, GENDER FROM CREDITCARDS WHERE CARD IN (SELECT * FROM EDU_CUSTOMERS_DT)GROUP BY EDULEVEL, MARITAL_STATUS, GENDER ORDER BY COUNT(CARD) DESC;

SELECT (COUNT(CARD)/10) AS PERCENTAGE_RF_PRED , EDULEVEL, MARITAL_STATUS, GENDER FROM CREDITCARDS WHERE CARD IN (SELECT * FROM EDU_CUSTOMERS_RF)GROUP BY EDULEVEL, MARITAL_STATUS, GENDER ORDER BY COUNT(CARD) DESC;

SELECT (COUNT(CARD)/10) AS PERCENTAGE_NN_PRED , EDULEVEL, MARITAL_STATUS, GENDER FROM CREDITCARDS WHERE CARD IN (SELECT * FROM EDU_CUSTOMERS_NN)GROUP BY EDULEVEL, MARITAL_STATUS, GENDER ORDER BY COUNT(CARD) DESC;

SELECT (COUNT(CARD)/10) AS PERCENTAGE_GLM_PRED , EDULEVEL, MARITAL_STATUS, GENDER FROM CREDITCARDS WHERE CARD IN (SELECT * FROM EDU_CUSTOMERS_GLM)GROUP BY EDULEVEL, MARITAL_STATUS, GENDER ORDER BY COUNT(CARD) DESC;

SELECT (COUNT(CARD)/10) AS PERCENTAGE_NV_PRED , EDULEVEL, MARITAL_STATUS, GENDER FROM CREDITCARDS WHERE CARD IN (SELECT * FROM EDU_CUSTOMERS_NB)GROUP BY EDULEVEL, MARITAL_STATUS, GENDER ORDER BY COUNT(CARD) DESC;

SPOOL OFF