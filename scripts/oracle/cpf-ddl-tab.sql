PROMPT Creating Table 'CPF_APPLICATION_STATISTICS'
CREATE TABLE CPF_APPLICATION_STATISTICS (
  APPLICATION_STATISTIC_ID NUMBER(19) NOT NULL,
  BUSINESS_APPLICATION_NAME VARCHAR2(255) NOT NULL,
  START_TIMESTAMP DATE NOT NULL,
  DURATION_TYPE VARCHAR2(10) NOT NULL,
  STATISTIC_VALUES VARCHAR2(4000) NOT NULL
  )
  PCTFREE 10
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_APPLICATION_STATISTICS IS 'The APPLICATION STATISTIC object represents a collection of statistic values for a business application during a time peroid hour, day, month, year). The statistics are stored as a JSON map of keys/values to allow additional statistics to be added in the future. The statistic values are processed by the application and are not intended to be queried using SQL.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.APPLICATION_STATISTIC_ID IS 'This is the unique key for the APPLICATION STATISTIC.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.BUSINESS_APPLICATION_NAME IS 'This is the name of the business application the statistic was created for.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.START_TIMESTAMP IS 'This is the timestamp of the start of the duration the statistic was created for.'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.DURATION_TYPE IS 'This is the type of duration (hour, day, month, year).'
/

COMMENT ON COLUMN CPF_APPLICATION_STATISTICS.STATISTIC_VALUES IS 'This is the JSON encoded object of statistic name/values (e.g. {''jobsSumbitted'': 1, ''jobsCompleted'':11}.'
/

PROMPT Creating Table 'CPF_BATCH_JOB_EXECUTION_GROUPS'
CREATE TABLE CPF_BATCH_JOB_EXECUTION_GROUPS (
  BATCH_JOB_ID NUMBER(19,0) NOT NULL,
  SEQUENCE_NUMBER NUMBER(19,0) NOT NULL,
  COMPLETED_IND NUMBER(1,0) NOT NULL,
  STARTED_IND NUMBER(1,0) NOT NULL,
  NUM_SUBMITTED_REQUESTS NUMBER(19,0) NOT NULL,
  COMPLETED_REQUEST_RANGE NUMBER(19,0) NOT NULL,
  FAILED_REQUEST_RANGE NUMBER(19,0) NOT NULL,
  INPUT_DATA BLOB,
  INPUT_DATA_URL VARCHAR2(2000),
  INPUT_DATA_CONTENT_TYPE VARCHAR2(255),
  RESULT_DATA BLOB,
  RESULT_DATA_URL VARCHAR2(2000),
  STRUCTURED_INPUT_DATA CLOB,
  STRUCTURED_RESULT_DATA CLOB,
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_BATCH_JOB_EXECUTION_GROUPS IS 'The BATCH JOB REQUEST represents a single request to execute a BusinessApplication within a BATCH JOB. It contains the input data, result data and any permanent errors.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.BATCH_JOB_ID IS 'This is the unique key for the BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.SEQUENCE_NUMBER IS 'This is the sequence number of the BATCH JOB REQUEST within a batch job. The sequence numbers start at one for the first input data record and increase by one for each subsequent record.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.COMPLETED_IND IS 'This is the true (1), false (0) indicator that the BATCH JOB REQUEST was completed successfully or failed to complete.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.STARTED_IND IS 'This is the true (1), false (0) indicator that the BATCH JOB REQUEST was started to be processed.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.INPUT_DATA IS 'This is the binary opaque input data for a business application containing the input data for the BATCH JOB REQUEST. For business applications which accept opaque input data either this or the INPUT DATA URL must be specified.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.INPUT_DATA_URL IS 'This is the client application URL to binary opaque input data for a business application containing the inputdata for the BATCH JOB REQUEST. For business applications which accept opaque input data either this or the INPUT DATA must be specified.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.INPUT_DATA_CONTENT_TYPE IS 'This is the MIME content type forthe  INPUT DATA or INPUT DATA URL for a BATCH JOB REQUEST. For business applications accept opaque input data either this must be specified. For example text/csv or application/json.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.RESULT_DATA IS 'This is the binary result data returned from a business application containing the result data for the BATCH JOB REQUEST. For business applications which return opaque result data either this or the RESULT DATA URL must be specified for successful BATCH JOB REQUESTS.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.RESULT_DATA_URL IS 'This is the URL returned from a business application containing the result data for the BATCH JOB REQUEST. For business applications which return opaque result data either this or the RESULT DATA must be specified for successful BATCH JOB REQUESTS.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.STRUCTURED_INPUT_DATA IS 'This is the structured input data for the BATCH JOB used to create the BATCH JOB REQUESTS. Either this or the STRUCTURED INPUT DATA URL can be specified for a business application which supports structured input data.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.STRUCTURED_RESULT_DATA IS 'This is the JSON encoded structured result data returned from the business application for the BATCH JOB REQUEST. For business applications which return structuredresult data this must be specified for successful BATCH JOB REQUESTS.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_EXECUTION_GROUPS.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/

PROMPT Creating Table 'CPF_BATCH_JOBS'
CREATE TABLE CPF_BATCH_JOBS(
  BATCH_JOB_ID NUMBER(19,0) NOT NULL,
  BUSINESS_APPLICATION_NAME VARCHAR2(255) NOT NULL,
  JOB_STATUS VARCHAR2(50) NOT NULL,
  GROUP_SIZE NUMBER(5,0) NOT NULL,
  NUM_SUBMITTED_GROUPS NUMBER(19,0) NOT NULL,
  COMPLETED_REQUEST_RANGE NUMBER(19,0) NOT NULL,
  FAILED_REQUEST_RANGE NUMBER(19,0) NOT NULL,
  NUM_SUBMITTED_REQUESTS NUMBER(19,0) NOT NULL,
  RESULT_DATA_CONTENT_TYPE VARCHAR2(255) NOT NULL,
  USER_ID VARCHAR2(50) NOT NULL,
  WHEN_STATUS_CHANGED TIMESTAMP NOT NULL,
  BUSINESS_APPLICATION_PARAMS VARCHAR2(4000),
  COMPLETED_TIMESTAMP TIMESTAMP,
  STRUCTURED_INPUT_DATA BLOB,
  STRUCTURED_INPUT_DATA_URL VARCHAR2(255),
  INPUT_DATA_CONTENT_TYPE VARCHAR2(255),
  LAST_SCHEDULED_TIMESTAMP TIMESTAMP,
  NOTIFICATION_URL VARCHAR2(2000),
  PROPERTIES VARCHAR2(4000),
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_BATCH_JOBS IS 'The BATCH JOB object represents a batch of requests to a BusinessApplication.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.BATCH_JOB_ID IS 'This is the unique key for the BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.BUSINESS_APPLICATION_NAME IS 'This is the name of the business application to be invoked in this job.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.JOB_STATUS IS 'This is the current status of the job (submitted, processing, processed, resultGenerated, downloadInitiated, deleteInitiated, deleted).'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.COMPLETED_REQUEST_RANGE IS 'This is the number of BATCH JOB REQUESTS which have been completed successfully for the BATCH JOB.'
/


COMMENT ON COLUMN CPF_BATCH_JOBS.FAILED_REQUEST_RANGE IS 'This is the number of BATCH JOB REQUESTS which failed to be completed for the BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.NUM_SUBMITTED_REQUESTS IS 'This is the number of BATCH JOB REQUESTS which were submitted for the BATCH JOB. The value is provided by the end user and updated in the job pre-process.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.RESULT_DATA_CONTENT_TYPE IS 'This is the MIME content type the results of the BATCH JOB are to be returned in (e.g. text/csv, application/json, text/xml). Each business application has its own list of supported mime types.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.USER_ID IS 'This is the login user identifier of the user who submitted the job.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.WHEN_STATUS_CHANGED IS 'This is the timestamp when the status of the job was last updated.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.BUSINESS_APPLICATION_PARAMS IS 'This is the CSV encoded global parameters to be passed to the business application for the BATCH JOB. The CSV encoding will have a header row with the names of the parameters and a single data row containing the parameter values.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.COMPLETED_TIMESTAMP IS 'This is the timestamp when all of the BATCH JOB REQUESTS and BATCH JOB RESULTS have been processed for the BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.STRUCTURED_INPUT_DATA IS 'This is the structured input data for the BATCH JOB used to create the BATCH JOB REQUESTS. Either this or the STRUCTURED INPUT DATA URL can be specified for a business application which supports structured input data.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.STRUCTURED_INPUT_DATA_URL IS 'This is the URL to download the structured input data for the BATCH JOB used to create the BATCH JOB REQUESTS. Either this or the STRUCTURED INPUT DATA can be specified for a business application which supports structured input data.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.INPUT_DATA_CONTENT_TYPE IS 'This is the mime content-type for the structured input data. For example text/csv or application/json.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.LAST_SCHEDULED_TIMESTAMP IS 'This is the timestamp when the most recent BATCH JOB REQUEST was scheduled to be processed for the BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.NOTIFICATION_URL IS 'This is the http, https, or mailto URL to be notified when the BATCH JOB has been completed and is ready for download.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.PROPERTIES IS 'PROPERTIES contains a JSON encoded map of additional properties associated with a BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_BATCH_JOBS.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/

PROMPT Creating Table 'CPF_BATCH_JOB_RESULTS'
CREATE TABLE CPF_BATCH_JOB_RESULTS(
  BATCH_JOB_RESULT_ID NUMBER(19,0) NOT NULL,
  BATCH_JOB_ID NUMBER(19,0) NOT NULL,
  BATCH_JOB_RESULT_TYPE VARCHAR2(50) NOT NULL,
  RESULT_DATA_CONTENT_TYPE VARCHAR2(255) NOT NULL,
  DOWNLOAD_TIMESTAMP TIMESTAMP,
  SEQUENCE_NUMBER NUMBER(19,0),
  RESULT_DATA BLOB,
  RESULT_DATA_URL VARCHAR2(2000),
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_BATCH_JOB_RESULTS IS 'The BATCH JOB RESULT is a result file generated after the execution of a BATCH JOB. For structured output data one file will be generated containing all the results. For opaque output data one file will be created for each BATCH JOB REQUEST. A BATCH JOB may also have one file containing any errors generated.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.BATCH_JOB_RESULT_ID IS 'This is the unique key for the BATCH JOB RESULT.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.BATCH_JOB_ID IS 'This is the unique key for the BATCH JOB.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.BATCH_JOB_RESULT_TYPE IS 'This is the purpose of the result data stored in the BATCH JOB RESULT. It can have the values structuredResultData, opaqueResultData, or errorResultData.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.RESULT_DATA_CONTENT_TYPE IS 'This is the MIME content type of the RESULT DATA or RESULT DATA URL for the BATCH JOB RESULT. For example text/csv or application/json.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.DOWNLOAD_TIMESTAMP IS 'This is the timestamp when the last byte was sent to the client for RESULT DATA or when the user was redirected to RESULT DATA URL.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.SEQUENCE_NUMBER IS 'This is the REQUEST SEQUENCE NUMBER of the BATCH JOB REQUEST if the BATCH JOB RESULT is of type opaqueResultData.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.RESULT_DATA IS 'This is the byte content of the result file for the BATCH JOB RESULT. Either this or the RESULT DATA URL must be specfied.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.RESULT_DATA_URL IS 'This is the URL to the byte content of the result file for the BATCH JOB RESULT. Either this or the RESULT DATA must be specfied.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_BATCH_JOB_RESULTS.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/

PROMPT Creating Table 'CPF_CONFIG_PROPERTIES'
CREATE TABLE CPF_CONFIG_PROPERTIES(
  CONFIG_PROPERTY_ID NUMBER(19,0) NOT NULL,
  ENVIRONMENT_NAME VARCHAR2(255) NOT NULL,
  MODULE_NAME VARCHAR2(255) NOT NULL,
  COMPONENT_NAME VARCHAR2(255) NOT NULL,
  PROPERTY_NAME VARCHAR2(255) NOT NULL,
  PROPERTY_VALUE_TYPE VARCHAR2(255) NOT NULL,
  PROPERTY_VALUE VARCHAR2(4000),
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_CONFIG_PROPERTIES IS 'The CONFIG PROPERTY represents a value to set for a property overriding the default value provided in the application code.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.CONFIG_PROPERTY_ID IS 'This is the unique key for the CONFIG PROPERTY.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.ENVIRONMENT_NAME IS 'ENVIRONMENT NAME contains the host name of web server instance name that the configuration property should be applied to.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.MODULE_NAME IS 'MODULE NAME contains the name of the CPF application module the configuration property should be applied to.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.COMPONENT_NAME IS 'COMPONENT NAME contains the name of the component within a CPF application module the configuration property should be applied to.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.PROPERTY_NAME IS 'This is the name of the configuration property. It can contain multiple parts separated by a period to set the value of a nested property. For example mapTileByLocation.maximumConcurrentRequests.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.PROPERTY_VALUE_TYPE IS 'PROPERTY VALUE TYPE contains the data type name used to convert the PROPERTY VALUE to a Java data type (e.g. string, int, double, boolean, GEOMETRY).'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.PROPERTY_VALUE IS 'This is the value to set for the property.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_CONFIG_PROPERTIES.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/

PROMPT Creating Table 'CPF_USER_ACCOUNTS'
CREATE TABLE CPF_USER_ACCOUNTS(
  USER_ACCOUNT_ID NUMBER(19,0) NOT NULL,
  USER_ACCOUNT_CLASS VARCHAR2(255) NOT NULL,
  USER_NAME VARCHAR2(4000) NOT NULL,
  CONSUMER_KEY VARCHAR2(36) NOT NULL,
  CONSUMER_SECRET VARCHAR2(36) NOT NULL,
  ACTIVE_IND NUMBER(1,0) NOT NULL,
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  PCTFREE 10
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_USER_ACCOUNTS IS 'The USER ACCOUNTS represents a user account created for an internal or external user, for example a OpenID account, BC Government IDIR account, or email address.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.USER_ACCOUNT_ID IS 'This is the unique identifier for the USER ACCOUNT.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.USER_ACCOUNT_CLASS IS 'This is the classification for the USER NAME, for example http://openid.net/ or http://idir.bcgov/.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.USER_NAME IS 'This is the user name, for example an OpenID, IDIR account name, or email address.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.CONSUMER_KEY IS 'This is the system generated unique user identifier for the user account.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.CONSUMER_SECRET IS 'This is the system generated password/encryption key for the user account.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.ACTIVE_IND IS 'This is the true (1), false (0) indicator if the object is active or has been deleted.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_USER_ACCOUNTS.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/

PROMPT Creating Table 'CPF_USER_GROUP_ACCOUNT_XREF'
CREATE TABLE CPF_USER_GROUP_ACCOUNT_XREF(
  USER_GROUP_ID NUMBER(19,0) NOT NULL,
  USER_ACCOUNT_ID NUMBER(19,0) NOT NULL
  )
  PCTFREE 10
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_USER_GROUP_ACCOUNT_XREF IS 'USER GROUP ACCOUNT XREF represents a relationship between a USER GROUP and the USER ACCOUNT that is a member of that group.'
/

COMMENT ON COLUMN CPF_USER_GROUP_ACCOUNT_XREF.USER_GROUP_ID IS 'USER GROUP ID is a unique surrogate identifier for the object USER GROUP.'
/

COMMENT ON COLUMN CPF_USER_GROUP_ACCOUNT_XREF.USER_ACCOUNT_ID IS 'USER ACCOUNT ID is a unique surrogate identifier for the object USER ACCOUNT.'
/

PROMPT Creating Table 'CPF_USER_GROUPS'
CREATE TABLE CPF_USER_GROUPS(
  USER_GROUP_ID NUMBER(19,0) NOT NULL,
  MODULE_NAME VARCHAR2(255) NOT NULL,
  USER_GROUP_NAME VARCHAR2(255) NOT NULL,
  DESCRIPTION VARCHAR2(4000),
  ACTIVE_IND NUMBER(1,0) NOT NULL,
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  PCTFREE 10
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_USER_GROUPS IS 'USER GROUP represents a named group of CPF or external users that can be granted permissions via USER GROUP PERMISSION. The members of the group are defined in the USER GROUP ACCOUNT XFREF.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.USER_GROUP_ID IS 'USER GROUP ID is a unique surrogate identifier for the object USER GROUP.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.MODULE_NAME IS 'MODULE NAME contains the name of the CPF application module the USER GROUP was created for.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.USER_GROUP_NAME IS 'This is the name of the SECURITY GROUP.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.DESCRIPTION IS 'This is a description of the security group.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.ACTIVE_IND IS 'This is the true (1), false (0) indicator if the object is active or has been deleted.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_USER_GROUPS.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/

PROMPT Creating Table 'CPF_USER_GROUP_PERMISSIONS'
CREATE TABLE CPF_USER_GROUP_PERMISSIONS(
  USER_GROUP_PERMISSION_ID NUMBER(19,0) NOT NULL,
  MODULE_NAME VARCHAR2(255) NOT NULL,
  USER_GROUP_ID NUMBER(19) NOT NULL,
  RESOURCE_CLASS VARCHAR2(255) NOT NULL,
  RESOURCE_ID VARCHAR2(4000) NOT NULL,
  ACTION_NAME VARCHAR2(255) NOT NULL,
  ACTIVE_IND NUMBER(1,0) NOT NULL,
  WHO_CREATED VARCHAR2(36) NOT NULL,
  WHEN_CREATED TIMESTAMP NOT NULL,
  WHO_UPDATED VARCHAR2(36) NOT NULL,
  WHEN_UPDATED TIMESTAMP NOT NULL
  )
  PCTFREE 10
  TABLESPACE CPF
/

COMMENT ON TABLE CPF_USER_GROUP_PERMISSIONS IS 'USER GROUP P ERMISSION represents a permission for a member of a USER GROUP to perfom an action on a given resource for a module.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.USER_GROUP_PERMISSION_ID IS 'USER GROUP PERMISSION ID is a unique surrogate identifier for the object USER GROUP PERMISSION.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.MODULE_NAME IS 'MODULE NAME contains the name of the CPF application module the USER GROUP PERMISSION was created for.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.USER_GROUP_ID IS 'USER GROUP ID is a unique surrogate identifier for the object USER GROUP.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.RESOURCE_CLASS IS 'This is the classification of the RESOURCE NAME. For example URL (web page), JavaClass, JavaObject.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.RESOURCE_ID IS 'This is the unqiue id of the resource the permission applies to. For example a url, java class name, java class name and object identifier.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.ACTION_NAME IS 'This is the name of the action the user is granted permission to perform (e.g. any, edit, view).'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.ACTIVE_IND IS 'This is the true (1), false (0) indicator if the object is active or has been deleted.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.WHO_CREATED IS 'This is the database or web user that created the object.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.WHEN_CREATED IS 'This is the date that the object was created.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.WHO_UPDATED IS 'This is the database or web user that last updated the object.'
/

COMMENT ON COLUMN CPF_USER_GROUP_PERMISSIONS.WHEN_UPDATED IS 'This is the date that the object was last updated.'
/