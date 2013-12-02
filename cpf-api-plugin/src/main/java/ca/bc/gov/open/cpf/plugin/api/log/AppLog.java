package ca.bc.gov.open.cpf.plugin.api.log;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import ca.bc.gov.open.cpf.plugin.api.BusinessApplicationPlugin;

/**
 * <p>The AppLog class is a logging API for use by a {@link BusinessApplicationPlugin} class.
 * Plug-in classes can record error, info and debug messages in the execute method. These messages
 * will be recorded in the Log4j log file (if that log level is enabled in the worker for the AppLog
 * class). The message will also be recorded in the module log file on the master if that log level
 * is enabled for the business application. This functionality allows viewing the logs for the
 * all the workers from the CPF admin console.</p>
 * 
 * <p>The plug-in must implement the following method on the {@link BusinessApplicationPlugin} class
 * to obtain a AppLog instance for this request.</p>
 * 
 * <figure><pre class="prettyprint language-java">private AppLog appLog;

public void setAppLog(final AppLog appLog) {
  this.appLog = appLog;
}</pre></figure>
 *
 */
public class AppLog {

  /** The logging level (ERROR, INFO, WARN, DEBUG). */
  private String logLevel = "ERROR";

  private final Logger log;

  public AppLog(final String name) {
    this.log = LoggerFactory.getLogger(name);
  }

  public AppLog(final String businessApplicationName, String groupId,
    final String logLevel) {
    if (!StringUtils.hasText(groupId)) {
      groupId = String.valueOf(System.currentTimeMillis());
    }
    this.log = LoggerFactory.getLogger(businessApplicationName + "." + groupId);
    setLogLevel(logLevel);
  }

  /**
   * <p>Record the info message in the log if {@see #isInfoEnabled()} is true.</p>
   * 
   * @param message The message.
   */
  public void debug(final String message) {
    if (isDebugEnabled()) {
      log.debug(message);
    }
  }

  /**
   * <p>Record the error message in the log.</p>
   * 
   * @param message The message.
   */
  public void error(final String message) {
    log.error(message);
  }

  /**
   * <p>Record the error message in the log with the exception.</p>
   * 
   * @param message The message.
   */
  public void error(final String message, final Throwable exception) {
    log.error(message, exception);
  }

  /**
   * <p>Get the logging level (ERROR, INFO, DEBUG).</p>
   * 
   * @param The logging level (ERROR, INFO, DEBUG).
   */
  public String getLogLevel() {
    return logLevel;
  }

  /**
   * <p>Record the info message in the log if {@see #isInfoEnabled()} is true.</p>
   * 
   * @param message The message.
   */
  public void info(final String message) {
    if (isInfoEnabled()) {
      log.info(message);
    }
  }

  /**
   * <p>Check to see if debug level logging is enabled. Use this in an if block around
   * logging operations that create large amounts of log data to prevent that data from being
   * created if logging is not enabled.</p>
   * 
   * @return True if debug level logging is enabled.
   */
  public boolean isDebugEnabled() {
    return logLevel.equals("DEBUG");
  }

  /**
   * <p>Check to see if info or debug level logging is enabled. Use this in an if block around
   * logging operations that create large amounts of log data to prevent that data from being
   * created if logging is not enabled.</p>
   * 
   * @return True if info or debug level logging is enabled.
   */
  public boolean isInfoEnabled() {
    return logLevel.equals("DEBUG") || logLevel.equals("INFO");
  }

  /**
   * <p>Set the current logging level (ERROR, INFO, DEBUG).</p>
   * 
   * @param logLevel The logging level (ERROR, INFO, DEBUG).
   */
  public void setLogLevel(final String logLevel) {
    this.logLevel = logLevel;
  }

  /**
   * <p>Record the warning message in the log.</p>
   * 
   * @param message The warning.
   */
  public void warn(final String message) {
    log.warn(message);
  }
}