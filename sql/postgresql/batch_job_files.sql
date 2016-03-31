CREATE TABLE CPF_BATCH_JOB_FILES (
  BATCH_JOB_ID                    BIGINT          NOT NULL,
  FILE_TYPE                       VARCHAR(20)     NOT NULL,
  SEQUENCE_NUMBER                 BIGINT          NOT NULL,
  CONTENT_TYPE                    VARCHAR(50)     NOT NULL,
  DATA                            OID             NOT NULL,
  WHEN_CREATED                    TIMESTAMP       NOT NULL,

  CONSTRAINT BATCH_JOB_FILES_PK PRIMARY KEY (BATCH_JOB_ID, FILE_TYPE, SEQUENCE_NUMBER),

  CONSTRAINT BATCH_JOB_FILES_JOB_FK FOREIGN KEY (BATCH_JOB_ID) REFERENCES CPF.CPF_BATCH_JOBS(BATCH_JOB_ID) ON DELETE CASCADE
);

CREATE INDEX BACTH_JOB_FILES_JOB_IDX ON CPF.CPF_BATCH_JOB_FILES (BATCH_JOB_ID);

-- Grants

GRANT DELETE, INSERT, SELECT, UPDATE ON CPF_BATCH_JOB_FILES TO CPF_USER;

GRANT SELECT ON CPF_BATCH_JOB_FILES TO CPF_VIEWER;

-- Comments

COMMENT ON TABLE CPF_BATCH_JOB_FILES IS 'The BATCH JOB FILE is a file containing the jobInputs, jobResults, groupInputs groupResults, or groupErrors for a BATCH JOB.';

COMMENT ON COLUMN CPF_BATCH_JOB_FILES.BATCH_JOB_ID IS 'This is the unique key for the BATCH JOB.';

COMMENT ON COLUMN CPF_BATCH_JOB_FILES.FILE_TYPE IS 'This is the type of file. For example jobInputs, jobResults, groupInputs groupResults, or groupErrors.';

COMMENT ON COLUMN CPF_BATCH_JOB_FILES.SEQUENCE_NUMBER IS 'This is the SEQUENCE NUMBER of the BATCH JOB FILE for a BATCH JOB ID and FILE_TYPE.';

COMMENT ON COLUMN CPF_BATCH_JOB_FILES.CONTENT_TYPE IS 'This is the MIME content type of the DATA. For example text;csv or application;json.';

COMMENT ON COLUMN CPF_BATCH_JOB_FILES.DATA IS 'This is the byte content of the file for the BATCH JOB FILE.';

COMMENT ON COLUMN CPF_BATCH_JOB_FILES.WHEN_CREATED IS 'This is the date that the object was created.';
