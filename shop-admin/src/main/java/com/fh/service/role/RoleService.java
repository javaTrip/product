package com.fh.service.role;

import com.fh.common.ServerResponse;
import com.fh.model.Role;
import com.fh.param.RoleSearchParam;

import java.util.List;

public interface RoleService {
    ServerResponse queryList(RoleSearchParam roleSearchParam);

    void addRole(String name, String resourceIds);

    void deleteRole(Integer id);

    void updateRole(Role role, List<Integer> resourceIdList);

    ServerResponse queryAllList();
}
