ALTER TABLE CPF_BATCH_JOB_REQUESTS ADD BATCH_JOB_RESULT_ID NUMBER(19,0)
/

PROMPT Creating Table 'CPF_APPLICATION_STATISTICS'
CREATE TABLE CPF_APPLICATION_STATISTICS
 (APPLICATION_STATISTIC_ID NUMBER(19) NOT NULL
 ,BUSINESS_APPLICATION_NAME VARCHAR2(255) NOT NULL
 ,START_TIMESTAMP DATE NOT NULL
 ,DURATION_TYPE VARCHAR2(10) NOT NULL
 ,STATISTIC_VALUES VARCHAR2(4000) NOT NULL
 )
 PCTFREE 10
 TABLESPACE CPF_TABLES
/

COMMENT ON TABLE CPF_APPLICATION_STATISTICS IS 'The APPLICATION STATISTIC object represents a collection of statistic values for a business application during a time peroid hour, day, month, year). The statistics are stored as a JSON map of keys/values to allow additional statistics to be added in the future. The statistic values are processed by the application and are not intended to be queried using SQL.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.APPLICATION_STATISTIC_ID IS 'This is the unique key for the APPLICATION STATISTIC.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.BUSINESS_APPLICATION_NAME IS 'This is the name of the business application the statistic was created for.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.START_TIMESTAMP IS 'This is the timestamp of the start of the duration the statistic was created for.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.DURATION_TYPE IS 'This is the type of duration (e.g. hour, day, month, year).'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.STATISTIC_VALUES IS 'This is the JSON encoded map of statistic name/values.'
/

PROMPT Creating Primary Key on 'CPF_APPLICATION_STATISTICS'
ALTER TABLE CPF_APPLICATION_STATISTICS
 ADD (CONSTRAINT CPF_AS_PK PRIMARY KEY 
  (APPLICATION_STATISTIC_ID)
 USING INDEX 
 PCTFREE 10
 TABLESPACE CPF_INDEXES)
/


GRANT SELECT ON CPF_APPLICATION_STATISTICS TO CPF_VIEWER
/

GRANT DELETE, INSERT, SELECT, UPDATE ON CPF_APPLICATION_STATISTICS TO CPF_USER
/

PROMPT Creating Sequence 'CPF_AS_SEQ'
CREATE SEQUENCE CPF_AS_SEQ
 NOMAXVALUE
 NOMINVALUE
 NOCYCLE
/

GRANT SELECT ON CPF_AS_SEQ TO CPF_USER
/