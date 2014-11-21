package ca.bc.gov.open.cpf.api.web.builder;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import ca.bc.gov.open.cpf.api.domain.CpfDataAccessObject;
import ca.bc.gov.open.cpf.api.domain.UserGroup;
import ca.bc.gov.open.cpf.api.domain.UserGroupPermission;
import ca.bc.gov.open.cpf.plugin.impl.BusinessApplicationRegistry;
import ca.bc.gov.open.cpf.plugin.impl.module.Module;
import ca.bc.gov.open.cpf.plugin.impl.module.ModuleEvent;

import com.revolsys.data.identifier.Identifier;
import com.revolsys.data.record.Record;
import com.revolsys.ui.html.view.Element;
import com.revolsys.ui.html.view.TabElementContainer;

@Controller
public class UserGroupPermissionUiBuilder extends CpfUiBuilder {

  protected UserGroupPermissionUiBuilder() {
    super("userGroupPermission", UserGroupPermission.USER_GROUP_PERMISSION,
      UserGroupPermission.USER_GROUP_PERMISSION_ID, "User Group Permission",
        "User Group Permissions");
  }

  @RequestMapping(value = {
    "/admin/modules/{moduleName}/userGroups/{userGroupName}/permissions/add"
  }, method = {
    RequestMethod.GET, RequestMethod.POST
  })
  @ResponseBody
  public Element pageModuleUserGroupPermissionAdd(
    final HttpServletRequest request, final HttpServletResponse response,
    @PathVariable final String moduleName,
    @PathVariable final String userGroupName) throws ServletException,
    IOException {
    checkAdminOrAnyModuleAdmin(moduleName);
    hasModule(request, moduleName);
    final Record group = getUserGroup(userGroupName);
    if (group != null) {
      final Long groupId = group.getLong(UserGroup.USER_GROUP_ID);
      final Map<String, Object> parameters = new HashMap<String, Object>();
      parameters.put(UserGroupPermission.MODULE_NAME, moduleName);
      parameters.put(UserGroupPermission.USER_GROUP_ID, groupId);
      parameters.put(UserGroupPermission.ACTIVE_IND, 1);
      return createObjectAddPage(parameters, "module", "preInsert");
    }
    notFound(response, "User group " + userGroupName + " does not exist");
    return null;
  }

  @RequestMapping(
    value = {
      "/admin/modules/{moduleName}/userGroups/{userGroupName}/permissions/{userGroupPermissionId}/delete"
    }, method = RequestMethod.POST)
  public void pageModuleUserGroupPermissionDelete(
    final HttpServletRequest request, final HttpServletResponse response,
    @PathVariable final String moduleName,
    @PathVariable final String userGroupName,
    @PathVariable final Long userGroupPermissionId,
    @RequestParam final Boolean confirm) throws ServletException, IOException {
    checkAdminOrAnyModuleAdmin(moduleName);
    hasModule(request, moduleName);
    final Record group = getUserGroup(userGroupName);
    if (group != null) {
      final Record permission = loadObject(userGroupPermissionId);
      if (permission != null) {
        if (permission.getValue(UserGroupPermission.MODULE_NAME).equals(
          moduleName)) {
          final Identifier userGroupId = group.getIdentifier();
          if (permission.getValue(UserGroupPermission.USER_GROUP_ID).equals(
            userGroupId)) {
            final CpfDataAccessObject dataAccessObject = getDataAccessObject();
            dataAccessObject.delete(permission);
            redirectToTab(UserGroup.USER_GROUP, "moduleView", "moduleList");
            return;
          }
        }
      }
    }
    notFound(response, "User group " + userGroupName + " does not exist");
  }

  @RequestMapping(
    value = {
      "/admin/modules/{moduleName}/userGroups/{userGroupName}/permissions/{userGroupPermissionId}/edit"
    }, method = {
      RequestMethod.GET, RequestMethod.POST
    })
  @ResponseBody
  public Element pageModuleUserGroupPermissionEdit(
    final HttpServletRequest request, final HttpServletResponse response,
    @PathVariable final String moduleName,
    @PathVariable final String userGroupName,
    @PathVariable final Long userGroupPermissionId) throws ServletException,
    IOException {
    checkAdminOrAnyModuleAdmin(moduleName);
    hasModule(request, moduleName);
    final Record group = getUserGroup(userGroupName);
    if (group != null) {
      final Record permission = loadObject(userGroupPermissionId);
      if (permission != null) {
        if (permission.getValue(UserGroupPermission.MODULE_NAME).equals(
          moduleName)) {
          final Identifier userGroupId = group.getIdentifier();
          if (permission.getValue(UserGroupPermission.USER_GROUP_ID).equals(
            userGroupId)) {
            return createObjectEditPage(permission, "module");
          }
        }
      }
    }
    notFound(response, "User group " + userGroupName + " does not exist");
    return null;
  }

  @RequestMapping(value = {
    "/admin/modules/{moduleName}/userGroups/{userGroupName}/permissions"
  }, method = RequestMethod.GET)
  @ResponseBody
  public Object pageModuleUserGroupPermissionList(
    final HttpServletRequest request, final HttpServletResponse response,
    @PathVariable final String moduleName,
    @PathVariable final String userGroupName) throws IOException,
    ServletException {
    checkAdminOrAnyModuleAdmin(moduleName);
    hasModule(request, moduleName);
    final Record group = getUserGroup(userGroupName);
    if (group != null) {
      final Map<String, Object> parameters = new HashMap<String, Object>();

      final Map<String, Object> filter = new HashMap<String, Object>();
      filter.put(UserGroupPermission.MODULE_NAME, moduleName);
      final Identifier userGroupId = group.getIdentifier();
      filter.put(UserGroupPermission.USER_GROUP_ID, userGroupId);
      parameters.put("filter", filter);

      return createDataTableHandlerOrRedirect(request, response, "moduleList",
        UserGroup.USER_GROUP, "moduleView", parameters);
    }
    notFound(response, "User group " + userGroupName + " does not exist");
    return null;
  }

  @RequestMapping(
    value = {
      "/admin/modules/{moduleName}/userGroups/{userGroupName}/permissions/{userGroupPermissionId}"
    }, method = RequestMethod.GET)
  @ResponseBody
  public Element pageModuleUserGroupPermissionView(
    final HttpServletRequest request, final HttpServletResponse response,
    @PathVariable final String moduleName,
    @PathVariable final String userGroupName,
    @PathVariable final Long userGroupPermissionId) throws ServletException,
    IOException {
    checkAdminOrAnyModuleAdmin(moduleName);
    hasModule(request, moduleName);
    final Record group = getUserGroup(userGroupName);
    if (group != null) {
      final Record permission = loadObject(userGroupPermissionId);
      if (permission != null) {
        if (permission.getValue(UserGroupPermission.MODULE_NAME).equals(
          moduleName)) {
          final Identifier userGroupId = group.getIdentifier();
          if (permission.getValue(UserGroupPermission.USER_GROUP_ID).equals(
            userGroupId)) {
            final TabElementContainer tabs = new TabElementContainer();
            addObjectViewPage(tabs, permission, "module");
            return tabs;
          }
        }
      }
    }
    notFound(response, "User group " + userGroupName + " does not exist");
    return null;
  }

  @Override
  public void postInsert(final Record permission) {
    postUpdate(permission);
  }

  @Override
  public void postUpdate(final Record permission) {
    final String moduleName = permission.getValue(UserGroupPermission.MODULE_NAME);
    final BusinessApplicationRegistry businessApplicationRegistry = getBusinessApplicationRegistry();
    final Module module = businessApplicationRegistry.getModule(moduleName);
    if (module != null) {
      businessApplicationRegistry.moduleEvent(module,
        ModuleEvent.SECURITY_CHANGED);
    }
  }

}