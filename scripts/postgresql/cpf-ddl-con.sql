  
ALTER TABLE CPF.CPF_USER_GROUP_PERMISSIONS
 ADD CONSTRAINT CPF_UGP_PK PRIMARY KEY 
  (USER_GROUP_PERMISSION_ID);

ALTER TABLE CPF.CPF_BATCH_JOB_RESULTS
 ADD CONSTRAINT CPF_BJRS_PK PRIMARY KEY 
  (BATCH_JOB_RESULT_ID);

ALTER TABLE CPF.CPF_BATCH_JOB_EXECUTION_GROUPS
 ADD CONSTRAINT CPF_BJEG_PK PRIMARY KEY 
  (BATCH_JOB_EXECUTION_GROUP_ID);

ALTER TABLE CPF.CPF_APPLICATION_STATISTICS
 ADD CONSTRAINT CPF_AS_PK PRIMARY KEY 
  (APPLICATION_STATISTIC_ID);

ALTER TABLE CPF.CPF_BATCH_JOBS
 ADD CONSTRAINT CPF_BJ_PK PRIMARY KEY 
  (BATCH_JOB_ID);

ALTER TABLE CPF.CPF_USER_GROUP_ACCOUNT_XREF
 ADD CONSTRAINT CPF_UGAX_PK PRIMARY KEY 
  (USER_GROUP_ID
  ,USER_ACCOUNT_ID);

ALTER TABLE CPF.CPF_USER_ACCOUNTS
 ADD CONSTRAINT CPF_UA_PK PRIMARY KEY 
  (USER_ACCOUNT_ID);

ALTER TABLE CPF.CPF_CONFIG_PROPERTIES
 ADD CONSTRAINT CPF_CP_PK PRIMARY KEY 
  (CONFIG_PROPERTY_ID);

ALTER TABLE CPF.CPF_USER_GROUPS
 ADD CONSTRAINT CPF_UG_PK PRIMARY KEY 
  (USER_GROUP_ID);


ALTER TABLE CPF.CPF_USER_ACCOUNTS
 ADD CONSTRAINT CPF_UA_UK2 UNIQUE 
  (CONSUMER_KEY);

ALTER TABLE CPF.CPF_USER_ACCOUNTS
 ADD CONSTRAINT CPF_UA_UK1 UNIQUE 
  (USER_NAME
  ,USER_ACCOUNT_CLASS);

ALTER TABLE CPF.CPF_USER_GROUP_PERMISSIONS ADD CONSTRAINT
 CPF_UGP_CPF_UG_FK FOREIGN KEY 
  (USER_GROUP_ID) REFERENCES CPF.CPF_USER_GROUPS
  (USER_GROUP_ID);

ALTER TABLE CPF.CPF_BATCH_JOB_RESULTS ADD CONSTRAINT
 CPF_BJRS_CPF_BJ_FK FOREIGN KEY 
  (BATCH_JOB_ID) REFERENCES CPF.CPF_BATCH_JOBS
  (BATCH_JOB_ID);

ALTER TABLE CPF.CPF_BATCH_JOB_EXECUTION_GROUPS ADD CONSTRAINT
 CPF_BJEG_CPF_BJ_FK FOREIGN KEY 
  (BATCH_JOB_ID) REFERENCES CPF.CPF_BATCH_JOBS
  (BATCH_JOB_ID);

ALTER TABLE CPF.CPF_USER_GROUP_ACCOUNT_XREF ADD CONSTRAINT
 CPF_UGAX_CPF_UG_FK FOREIGN KEY 
  (USER_GROUP_ID) REFERENCES CPF.CPF_USER_GROUPS
  (USER_GROUP_ID);

ALTER TABLE CPF.CPF_USER_GROUP_ACCOUNT_XREF ADD CONSTRAINT
 CPF_UGAX_CPF_UA_FK FOREIGN KEY 
  (USER_ACCOUNT_ID) REFERENCES CPF.CPF_USER_ACCOUNTS
  (USER_ACCOUNT_ID);

