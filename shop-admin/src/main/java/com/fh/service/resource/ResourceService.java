package com.fh.service.resource;

import com.fh.common.ServerResponse;
import com.fh.model.Resource;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface ResourceService {
    ServerResponse queryList();

    void addResource(Resource resource);

    void deleteResource(List idList);

    void updateResource(Resource resource);

    ServerResponse queryListByRoleId(Integer roleId);

    ServerResponse getCurrentUserResource(HttpServletRequest request);
}
