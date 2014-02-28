package ca.bc.gov.open.cpf.api.web.controller;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Arrays;
import java.util.Map;

import org.slf4j.LoggerFactory;

import ca.bc.gov.open.cpf.api.domain.BatchJobResult;
import ca.bc.gov.open.cpf.api.domain.CpfDataAccessObject;
import ca.bc.gov.open.cpf.api.scheduler.BatchJobService;

import com.revolsys.gis.data.model.DataObject;
import com.revolsys.io.FileUtil;
import com.revolsys.io.json.JsonParser;

public class FileJobController extends AbstractJobController {

  private static final DecimalFormatSymbols DECIMAL_FORMAT_SYMBOLS = new DecimalFormatSymbols();

  static {
    DECIMAL_FORMAT_SYMBOLS.setGroupingSeparator('/');
  }

  public static String toPath(final long id) {
    final StringBuffer path = new StringBuffer();
    if (id < 0) {
      path.append('-');
    }
    final int numGroups;
    if (id == 0) {
      numGroups = 1;
    } else {
      numGroups = (int)Math.ceil((Math.floor(Math.log10(id)) + 1) / 3);
    }
    path.append(numGroups);
    path.append('/');
    final DecimalFormat decimalFormat = new DecimalFormat();
    decimalFormat.setMinimumIntegerDigits(numGroups * 3);
    decimalFormat.setDecimalFormatSymbols(DECIMAL_FORMAT_SYMBOLS);
    path.append(decimalFormat.format(id));
    return path.toString();
  }

  private final File rootDirectory;

  private final CpfDataAccessObject dataAccessObject;

  public FileJobController(final BatchJobService batchJobService,
    final File rootDirectory) {
    this.dataAccessObject = batchJobService.getDataAccessObject();
    this.rootDirectory = rootDirectory;
  }

  @Override
  public boolean cancelJob(final long jobId) {
    final boolean cancelled = dataAccessObject.cancelBatchJob(jobId);
    for (final String directoryName : Arrays.asList(JOB_INPUTS, JOB_RESULTS,
      GROUP_INPUTS, GROUP_RESULTS)) {
      final File directory = getJobDirectory(jobId, directoryName);
      deleteDirectory(jobId, directory);
    }
    return cancelled;
  }

  @Override
  public void createJobFile(final long jobId, final String path,
    final long sequenceNumber, final String contentType, final Object data) {
    final File file = getJobFile(jobId, path, sequenceNumber);
    file.getParentFile().mkdirs();
    if (data instanceof File) {
      final File dataFile = (File)data;
      FileUtil.copy(dataFile, file);
    } else if (data instanceof InputStream) {
      final InputStream in = (InputStream)data;
      FileUtil.copy(in, file);
    } else if (data instanceof byte[]) {
      final byte[] bytes = (byte[])data;
      FileUtil.copy(new ByteArrayInputStream(bytes), file);
    }
  }

  protected void deleteDirectory(final long jobId, final File directory) {
    if (!FileUtil.deleteDirectory(directory)) {
      LoggerFactory.getLogger(getClass()).error(
        "Unable to delete  " + directory + " for jobId=" + jobId);
    }
  }

  @Override
  public void deleteJob(final long jobId) {
    dataAccessObject.deleteBatchJob(jobId);
    final File jobDirectory = getJobDirectory(jobId);
    deleteDirectory(jobId, jobDirectory);
  }

  protected File getJobDirectory(final long jobId) {
    final File jobDirectory = FileUtil.getFile(rootDirectory, "jobs/"
      + toPath(jobId));
    return jobDirectory;
  }

  protected File getJobDirectory(final long jobId, final String path) {
    final File jobDirectory = getJobDirectory(jobId);
    final File groupsFile = FileUtil.getFile(jobDirectory, path);
    return groupsFile;
  }

  protected File getJobFile(final long jobId, final String path,
    final long recordId) {
    final File groupsFile = getJobDirectory(jobId, path);
    final File file = FileUtil.getFile(groupsFile, toPath(recordId) + ".json");
    return file;
  }

  @Override
  public InputStream getJobResultData(final long jobId,
    final long batchJobResultId, final DataObject batchJobResult) {
    final File resultFile = getJobFile(jobId, JOB_RESULTS, batchJobResultId);
    return FileUtil.getInputStream(resultFile);
  }

  @Override
  public long getJobResultSize(final long jobId, final long batchJobResultId,
    final DataObject batchJobResult) {
    final File resultFile = getJobFile(jobId, JOB_RESULTS, batchJobResultId);
    return resultFile.length();
  }

  @Override
  public String getKey() {
    return "file";
  }

  @Override
  public Long getNonExecutingGroupSequenceNumber(final Long jobId) {
    return dataAccessObject.getNonExecutingGroupSequenceNumber(jobId);
  }

  @Override
  public String getStructuredInputData(final long jobId,
    final long sequenceNumber) {
    final File file = getJobFile(jobId, GROUP_INPUTS, sequenceNumber);
    if (file.exists()) {
      final String inputData = FileUtil.getString(file);
      return inputData;
    } else {
      return "{}";
    }
  }

  @Override
  public Map<String, Object> getStructuredResultData(final long jobId,
    final long sequenceNumber, final DataObject batchJobExecutionGroup) {
    final File file = getJobFile(jobId, GROUP_RESULTS, sequenceNumber);
    if (file.exists()) {
      final Map<String, Object> resultData = JsonParser.read(file);
      return resultData;
    } else {
      return null;
    }
  }

  @Override
  public void setJobResultData(final long jobId,
    final DataObject batchJobResult, final Object resultData) {
    final Long batchJobResultId = batchJobResult.getLong(BatchJobResult.BATCH_JOB_RESULT_ID);
    final String path = JOB_RESULTS;
    final File resultFile = getJobFile(jobId, path, batchJobResultId);
    resultFile.getParentFile().mkdirs();
    if (resultData instanceof File) {
      final File file = (File)resultData;
      FileUtil.copy(file, resultFile);
    } else if (resultData instanceof byte[]) {
      final byte[] bytes = (byte[])resultData;
      FileUtil.copy(new ByteArrayInputStream(bytes), resultFile);
    }
  }

  @Override
  public void setStructuredInputData(final long jobId,
    final long sequenceNumber, final DataObject executionGroup,
    final String structuredInputData) {
    final File file = getJobFile(jobId, GROUP_INPUTS, sequenceNumber);
    file.getParentFile().mkdirs();
    FileUtil.copy(structuredInputData, file);
  }

  @Override
  public void setStructuredResultData(final long jobId,
    final long sequenceNumber, final DataObject executionGroup,
    final String structuredResultData) {
    final File file = getJobFile(jobId, GROUP_RESULTS, sequenceNumber);
    file.getParentFile().mkdirs();
    FileUtil.copy(structuredResultData, file);
  }
}
