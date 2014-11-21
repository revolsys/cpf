package ca.bc.gov.open.cpf.api.security.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.PreDestroy;

import org.springframework.beans.factory.annotation.Required;

import ca.bc.gov.open.cpf.api.domain.CpfDataAccessObject;
import ca.bc.gov.open.cpf.api.domain.UserAccount;
import ca.bc.gov.open.cpf.plugin.impl.module.ResourcePermission;

import com.revolsys.data.record.Record;
import com.revolsys.data.record.RecordUtil;

public class BaseAuthorizationService implements AuthorizationService {

  private CpfDataAccessObject dataAccessObject;

  private UserAccountSecurityService userAccountSecurityService;

  @Override
  public boolean canAccessResource(final String moduleName,
    final String consumerKey, final String resourceClass,
    final String resourceId) {
    return canAccessResource(moduleName, consumerKey, resourceClass,
      resourceId, ResourcePermission.ALL);
  }

  @Override
  public boolean canAccessResource(final String moduleName,
    final String consumerKey, final String resourceClass,
    final String resourceId, final String actionName) {

    final Record userAccount = dataAccessObject.getUserAccount(consumerKey);
    if (userAccount == null
      || !RecordUtil.getBoolean(userAccount, UserAccount.ACTIVE_IND)) {
      return false;
    } else {
      final List<String> groupNames = new ArrayList<String>();
      for (final String groupName : userAccountSecurityService.getGroupNames(userAccount)) {
        groupNames.add(groupName);
      }
      final Record permission = dataAccessObject.getUserGroupPermission(
        groupNames, moduleName, resourceClass, resourceId, actionName);
      return permission != null;
    }
  }

  @Override
  public boolean canPerformAction(final String moduleName,
    final String consumerKey, final String actionName) {
    return canAccessResource(moduleName, consumerKey, ResourcePermission.ALL,
      ResourcePermission.ALL, ResourcePermission.ALL);
  }

  @PreDestroy
  public void close() {
    dataAccessObject = null;
    userAccountSecurityService = null;
  }

  public UserAccountSecurityService getUserAccountSecurityService() {
    return userAccountSecurityService;
  }

  @Override
  public Map<String, Object> getUserAttributes(final String moduleName,
    final String consumerKey) {
    return Collections.emptyMap();
  }

  @Override
  public String getUserClass(final String consumerKey) {
    final Record userAccount = dataAccessObject.getUserAccount(consumerKey);
    if (userAccount == null) {
      return null;
    } else {
      return userAccount.getValue(UserAccount.USER_ACCOUNT_CLASS);
    }
  }

  @Override
  public String getUsername(final String consumerKey) {
    final Record userAccount = dataAccessObject.getUserAccount(consumerKey);
    if (userAccount == null) {
      return null;
    } else {
      return userAccount.getValue(UserAccount.USER_NAME);
    }
  }

  @Override
  public boolean isInGroup(final String moduleName, final String consumerKey,
    final String groupName) {
    final Record userAccount = dataAccessObject.getUserAccount(consumerKey);
    if (userAccount == null) {
      return false;
    } else {
      for (final String name : userAccountSecurityService.getGroupNames(userAccount)) {
        if (groupName.equals(name) || groupName.equals("ROLE_" + name)) {
          return true;
        }
      }
      return false;
    }
  }

  public void setDataAccessObject(final CpfDataAccessObject dataAccessObject) {
    this.dataAccessObject = dataAccessObject;
  }

  @Required
  public void setUserAccountSecurityService(
    final UserAccountSecurityService userAccountSecurityService) {
    this.userAccountSecurityService = userAccountSecurityService;
  }

}