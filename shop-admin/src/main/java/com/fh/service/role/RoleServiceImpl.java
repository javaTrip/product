package com.fh.service.role;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fh.common.ServerResponse;
import com.fh.mapper.RoleMapper;
import com.fh.mapper.RoleResourceMapper;
import com.fh.model.Role;
import com.fh.model.RoleResource;
import com.fh.param.RoleSearchParam;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService {
    @Resource
    private RoleMapper roleMapper;
    @Resource
    private RoleResourceMapper roleResourceMapper;

    @Override
    public ServerResponse queryList(RoleSearchParam roleSearchParam) {
        QueryWrapper queryWrapper = new QueryWrapper();
        //查询总条数
        Integer totalCount = roleMapper.selectCount(queryWrapper);
        //查询分页数据
        //计算当前页
        int current =roleSearchParam.getStart()/roleSearchParam.getLength()+1;
        IPage iPage = roleMapper.selectPage(new Page<>(current, roleSearchParam.getLength()), queryWrapper);
        List roleList = iPage.getRecords();

        Map map = new HashMap();
        map.put("draw",roleSearchParam.getDraw());
        map.put("data",roleList);
        map.put("recordsTotal",totalCount);
        map.put("recordsFiltered",totalCount);

        return ServerResponse.success(map);
    }

    @Override
    public void addRole(String name, String resourceIds) {
        //保存角色
        Role role = new Role();
        role.setName(name);
        roleMapper.insert(role);
        //保存角色和资源关联数据
        if(StringUtils.isNotBlank(resourceIds)){
            String[] ridArr = resourceIds.substring(1).split(",");
            for (int i = 0; i < ridArr.length; i++) {
                String rid = ridArr[i];
                RoleResource roleResource = new RoleResource();
                roleResource.setRoleId(role.getId());
                roleResource.setResourceId(Integer.valueOf(rid));
                roleResourceMapper.insert(roleResource);

            }
        }

    }

    @Override
    public void deleteRole(Integer id) {
        //先删除角色表中数据
         roleMapper.deleteById(id);
         //再删除角色资源关联表中数据
         QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.eq("roleId",id);
        roleResourceMapper.delete(queryWrapper);
    }

    @Override
    public void updateRole(Role role, List<Integer> resourceIdList) {
        //修改角色
        roleMapper.updateById(role);
        //删除该角色关联的所有资源
        QueryWrapper queryWrapper = new QueryWrapper();
        queryWrapper.eq("roleId",role.getId());
        roleResourceMapper.delete(queryWrapper);
         if(resourceIdList != null && resourceIdList.size()>0){
        //重新关联修改之后的资源
        resourceIdList.forEach(x->{
            RoleResource roleResource = new RoleResource();
            roleResource.setRoleId(role.getId());
            roleResource.setResourceId(x);
            roleResourceMapper.insert(roleResource);


        });
         }

    }

    @Override
    public ServerResponse queryAllList() {
        QueryWrapper queryWrapper = new QueryWrapper();
        List list = roleMapper.selectList(queryWrapper);
        return ServerResponse.success(list);
    }
}
