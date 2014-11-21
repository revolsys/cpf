package ca.bc.gov.open.cpf.api.scheduler;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.TreeMap;

import com.revolsys.util.Property;

public class Worker {
  private final String id;

  private Timestamp lastConnectTime;

  private final Map<String, BatchJobRequestExecutionGroup> executingGroupsById = new TreeMap<String, BatchJobRequestExecutionGroup>();

  private final Map<String, List<BatchJobRequestExecutionGroup>> executingGroupsIdByModule = new TreeMap<String, List<BatchJobRequestExecutionGroup>>();

  private int maxMessageId = 1;

  private final Map<Integer, Map<String, Object>> messages = new TreeMap<Integer, Map<String, Object>>();

  private final Map<String, WorkerModuleState> moduleStates = new TreeMap<String, WorkerModuleState>();

  private final long startTime;

  public Worker(final String id, final long startTime) {
    this.id = id;
    this.startTime = startTime;
  }

  public void addExecutingGroup(final String moduleNameAndTime,
    final BatchJobRequestExecutionGroup group) {
    synchronized (this.executingGroupsById) {
      final String groupId = group.getId();
      this.executingGroupsById.put(groupId, group);
      List<BatchJobRequestExecutionGroup> groups = this.executingGroupsIdByModule.get(moduleNameAndTime);
      if (groups == null) {
        groups = new ArrayList<BatchJobRequestExecutionGroup>();
        this.executingGroupsIdByModule.put(moduleNameAndTime, groups);
      }
      groups.add(group);
    }
  }

  public void addMessage(final Map<String, Object> message) {
    synchronized (this.messages) {
      final int messageId = this.maxMessageId++;
      this.messages.put(messageId, message);
    }
  }

  public boolean cancelBatchJob(final long batchJobId) {
    synchronized (this.executingGroupsById) {
      boolean found = false;
      for (final Iterator<Entry<String, BatchJobRequestExecutionGroup>> iterator = this.executingGroupsById.entrySet()
          .iterator(); iterator.hasNext();) {
        final Entry<String, BatchJobRequestExecutionGroup> entry = iterator.next();
        final String groupId = entry.getKey();
        final BatchJobRequestExecutionGroup group = entry.getValue();
        if (group.getBatchJobId() == batchJobId) {
          found = true;
          final Map<String, Object> message = new LinkedHashMap<>();
          message.put("action", "cancelGroup");
          message.put("batchJobId", batchJobId);
          message.put("groupId", groupId);
          addMessage(message);
        }
      }
      return found;
    }
  }

  public List<BatchJobRequestExecutionGroup> cancelExecutingGroups(
    final String moduleNameAndTime) {
    synchronized (this.executingGroupsById) {
      final List<BatchJobRequestExecutionGroup> groups = this.executingGroupsIdByModule.remove(moduleNameAndTime);
      if (groups == null) {
        return Collections.emptyList();
      } else {
        for (final BatchJobRequestExecutionGroup group : groups) {
          final String groupId = group.getId();
          this.executingGroupsById.remove(groupId);
        }
        return groups;
      }
    }
  }

  public BatchJobRequestExecutionGroup getExecutingGroup(final String groupId) {
    return this.executingGroupsById.get(groupId);
  }

  public List<BatchJobRequestExecutionGroup> getExecutingGroups() {
    synchronized (this.executingGroupsById) {
      return new ArrayList<BatchJobRequestExecutionGroup>(
          this.executingGroupsById.values());
    }
  }

  public Map<String, BatchJobRequestExecutionGroup> getExecutingGroupsById() {
    return this.executingGroupsById;
  }

  public String getId() {
    return this.id;
  }

  public Timestamp getLastConnectTime() {
    return this.lastConnectTime;
  }

  public Map<String, Map<String, Object>> getMessages(final int maxMessageId) {
    synchronized (this.messages) {
      final Map<String, Map<String, Object>> messages = new LinkedHashMap<>();
      for (final Iterator<Entry<Integer, Map<String, Object>>> iterator = this.messages.entrySet()
          .iterator(); iterator.hasNext();) {
        final Entry<Integer, Map<String, Object>> entry = iterator.next();
        final Integer messageId = entry.getKey();
        if (messageId <= maxMessageId) {
          iterator.remove();
        } else {
          final Map<String, Object> message = entry.getValue();
          messages.put(String.valueOf(messageId), message);
        }
      }
      return messages;
    }
  }

  public List<WorkerModuleState> getModules() {
    return new ArrayList<>(this.moduleStates.values());
  }

  protected WorkerModuleState getModuleState(final String moduleName) {
    if (Property.hasValue(moduleName)) {
      synchronized (this.moduleStates) {
        WorkerModuleState moduleState = this.moduleStates.get(moduleName);
        if (moduleState == null) {
          moduleState = new WorkerModuleState(moduleName);
          this.moduleStates.put(moduleName, moduleState);
        }
        return moduleState;
      }
    } else {
      return null;
    }
  }

  public long getStartTime() {
    return this.startTime;
  }

  public BatchJobRequestExecutionGroup removeExecutingGroup(final String groupId) {
    synchronized (this.executingGroupsById) {
      return this.executingGroupsById.remove(groupId);
    }
  }

  public void setLastConnectTime(final Timestamp lastConnectTime) {
    this.lastConnectTime = lastConnectTime;
  }

  @Override
  public String toString() {
    return getId();
  }
}