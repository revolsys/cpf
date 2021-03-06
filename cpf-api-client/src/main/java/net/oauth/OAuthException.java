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
package net.oauth;

/**
 * An exception thrown by the OAuth library.
 */
@SuppressWarnings("javadoc")
public class OAuthException extends Exception {

  private static final long serialVersionUID = 1L;

  /**
   * For subclasses only.
   */
  protected OAuthException() {
  }

  /**
   * @param message
   */
  public OAuthException(final String message) {
    super(message);
  }

  /**
   * @param message
   * @param cause
   */
  public OAuthException(final String message, final Throwable cause) {
    super(message, cause);
  }

  /**
   * @param cause
   */
  public OAuthException(final Throwable cause) {
    super(cause);
  }

}
