package com.fh.controller;

import com.fh.common.ServerResponse;
import com.fh.model.Resource;
import com.fh.service.resource.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping("resource/")
public class ResourceController {
    @Autowired
    private ResourceService resourceService;
    @RequestMapping("index")
    public String index(){
        return "resource/list";
    }
    @RequestMapping("queryList")
    @ResponseBody
    public ServerResponse   queryList(){
        return resourceService.queryList();
    }
    @RequestMapping("addResource")
    @ResponseBody
    public ServerResponse  addResource( Resource resource){
         resourceService.addResource(resource);
        return ServerResponse.success(resource.getId());
    }
    @RequestMapping("deleteResource")
    @ResponseBody
    public ServerResponse  deleteResource(@RequestParam("idList[]") List idList){
        resourceService.deleteResource(idList);
        return ServerResponse.success();
    }
    @RequestMapping("updateResource")
    @ResponseBody
    public ServerResponse  updateResource( Resource resource){
        resourceService.updateResource(resource);
        return ServerResponse.success();
    }
    @RequestMapping("queryListByRoleId")
    @ResponseBody
    public ServerResponse   queryListByRoleId(Integer roleId){
        return resourceService.queryListByRoleId(roleId);
    }

    /**
     * 获取当前用户所拥有的资源
     * @return
     */
    @RequestMapping("getCurrentUserResource")
    @ResponseBody
    public ServerResponse getCurrentUserResource(HttpServletRequest request){
        return resourceService.getCurrentUserResource(request);
    }
}
