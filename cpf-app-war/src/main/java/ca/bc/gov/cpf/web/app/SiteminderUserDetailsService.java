package ca.bc.gov.cpf.web.app;

import java.util.ArrayList;
import java.util.Collection;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.security.authentication.AccountStatusUserDetailsChecker;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsChecker;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import ca.bc.gov.open.cpf.api.dao.UserAccountDao;
import ca.bc.gov.open.cpf.api.domain.UserAccount;
import ca.bc.gov.open.cpf.api.security.service.UserAccountSecurityService;

import com.revolsys.ui.web.utils.HttpRequestUtils;

public class SiteminderUserDetailsService implements UserDetailsService {

  /** The data access object for {@link UserAccount} objects. */
  private UserAccountDao userAccountDao;

  /** The class to use to check that the user is valid. */
  private UserDetailsChecker userDetailsChecker = new AccountStatusUserDetailsChecker();

  private UserAccountSecurityService userAccountSecurityService;

  /**
   * Get the data access object for {@link UserAccount} objects.
   * 
   * @return The data access object for {@link UserAccount} objects.
   */
  public UserAccountDao getUserAccountDao() {
    return userAccountDao;
  }

  public UserAccountSecurityService getUserAccountSecurityService() {
    return userAccountSecurityService;
  }

  /**
   * Get the class to use to check that the user is valid.
   * 
   * @return The class to use to check that the user is valid.
   */
  public UserDetailsChecker getUserDetailsChecker() {
    return userDetailsChecker;
  }

  private static final String USER_ACCOUNT_CLASS = "BCGOV";

  /**
   * Load the external user which has the {@link #userAccountClass} and external
   * user name. If the user does not exist in the database create a new external
   * user record with a generated consumer key and consumer secret.
   * 
   * @param guid The external user name to login as.
   * @return The UserDetals object for the user.
   */
  @Override
  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public UserDetails loadUserByUsername(String userGuid) {
    UserAccount user = userAccountDao.getByUserAccountName(USER_ACCOUNT_CLASS,
      userGuid);

    String userName;
    String userType = null;
    if (user == null) {
      HttpServletRequest request = HttpRequestUtils.getHttpServletRequest();
      userType = request.getHeader("SMGOV_USERTYPE");
      final SecurityContext context = SecurityContextHolder.getContext();
      userName = request.getHeader("SM_UNIVERSALID");
      userName = userName.replace('\\', ':');
      userName = userName.replace('/', ':');

      final String consumerSecret = UUID.randomUUID().toString();
      user = new UserAccount();
      user.setUserAccountName(userGuid);
      user.setUserAccountClass(USER_ACCOUNT_CLASS);
      user.setConsumerKey(userName);
      user.setConsumerSecret(consumerSecret);
      final UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
        userName, consumerSecret);
      context.setAuthentication(authentication);
      userAccountDao.persist(user);
    } else {
      userName = user.getConsumerKey();

    }
    if (StringUtils.hasText(userType)) {
      userType = userType.toUpperCase();
    } else {
      int index = userName.indexOf(':');
      if (index == -1) {
        userType = "INDIVIDUAL";
      } else {
        String userTypeCode = userName.substring(0, index);
        if (userTypeCode.equalsIgnoreCase("IDIR")) {
          userType = "INTERNAL";
        } else if (userTypeCode.equalsIgnoreCase("BCEID")) {
          userType = "BUSINESS";
        } else {
          userType = "INDIVIDUAL";
        }
      }
    }
    final String userPassword = user.getConsumerSecret();
    final boolean active = user.isActive();
    Collection<GrantedAuthority> authorities;
    if (userAccountSecurityService == null) {
      authorities = new ArrayList<GrantedAuthority>();
    } else {
      authorities = userAccountSecurityService.getGrantedAuthorities(user);
      authorities.add(new GrantedAuthorityImpl("ROLE_BCGOV_" + userType));
    }
    final User userDetails = new User(userName, userPassword, active, true,
      true, true, authorities);

    if (userDetailsChecker != null) {
      userDetailsChecker.check(userDetails);
    }
    return userDetails;
  }

  /**
   * Set the data access object for {@link UserAccount} objects.
   * 
   * @param userAccountDao The data access object for {@link UserAccount}
   *          objects.
   */
  public void setUserAccountDao(final UserAccountDao userAccountDao) {
    this.userAccountDao = userAccountDao;
  }

  @Resource(name = "userAccountSecurityService")
  public void setUserAccountSecurityService(
    final UserAccountSecurityService userAccountSecurityService) {
    this.userAccountSecurityService = userAccountSecurityService;
  }

  /**
   * Set the class to use to check that the user is valid.
   * 
   * @param userDetailsChecker The class to use to check that the user is valid.
   */
  public void setUserDetailsChecker(final UserDetailsChecker userDetailsChecker) {
    this.userDetailsChecker = userDetailsChecker;
  }
}
