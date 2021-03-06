/*
 * Copyright © 2008-2016, Province of British Columbia
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package ca.bc.gov.open.cpf.client.api;

/**
 * <p>The ErrorCode enum describes the types of error that can be returned in an error file.<p>
 */
public enum ErrorCode implements CharSequence {
  /** Invalid mime type for request input data. */
  BAD_INPUT_DATA_TYPE("Invalid mime type for request input data."),
  /** Illegal value in request input data. */
  BAD_INPUT_DATA_VALUE("Illegal value in request input data."),
  /** Illegal combination of values in request input data. */
  BAD_INPUT_DATA_VALUES("Illegal combination of values in request input data."),
  /** Invalid number of batch job requests. */
  BAD_NUMBER_REQUESTS("Invalid number of batch job requests."),
  /** Invalid response data returned from the Business Application. */
  BAD_RESPONSE_DATA("Invalid response data returned from the Business Application."),
  /** Invalid mime type for result data. */
  BAD_RESULT_DATA_TYPE("Invalid mime type for result data."),
  /** An unknown error occurred processing the request. */
  ERROR_PROCESSING_REQUEST("An unknown error occurred processing the request."),
  /** Unable to read batch job input data. */
  INPUT_DATA_UNREADABLE("Unable to read batch job input data."),
  /** A supplied request or job parameter has an invalid type or value. */
  INVALID_PARAMETER_VALUE("A supplied request or job parameter has an invalid type or value."),
  /** A required request or job parameter is missing. */
  MISSING_REQUIRED_PARAMETER("A required request or job parameter is missing."),
  /** A temporary exception that can be recovered from. */
  RECOVERABLE_EXCEPTION("A temporary exception that can be recovered from."),
  /** Too many batch job requests for this business application. */
  TOO_MANY_REQUESTS("Too many batch job requests for this business application.");

  /** The description of the error code. */
  private final String description;

  /**
   * Construct a new error code.
   *
   * @param description The description of the error code.
   */
  private ErrorCode(final String description) {
    this.description = description;
  }

  /**
   * Get the character in the name at index.
   *
   * @return The character.
   */
  @Override
  public char charAt(final int index) {
    return name().charAt(index);
  }

  /**
   * Test that name of this error code equals the string.
   *
   * @param errorCode The error code string.
   * @return True if the name equals the error code string.
   */
  public boolean equals(final String errorCode) {
    return name().equals(errorCode);
  }

  /**
   * Get the description of the error code.
   *
   * @return The description of the error code.
   */
  public String getDescription() {
    return this.description;
  }

  /**
   * Get the length of the name.
   *
   * @return The length of the name.
   */
  @Override
  public int length() {
    return name().length();
  }

  /**
   * Get a sub sequence of the name.
   *
   * @param start The start index.
   * @param end The end index.
   * @return The sub sequence.
   */
  @Override
  public CharSequence subSequence(final int start, final int end) {
    return name().subSequence(start, end);
  }
}
