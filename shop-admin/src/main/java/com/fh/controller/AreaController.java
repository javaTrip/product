package com.fh.controller;

import com.fh.common.ServerResponse;
import com.fh.model.Area;
import com.fh.service.area.AreaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("area/")
public class AreaController {
    @Autowired
 private AreaService areaService;

    @RequestMapping("index")
    public String index(){
        return "area/list";
    }


    @RequestMapping("queryListByPid")
    @ResponseBody
    public ServerResponse queryListByPid(Integer pid){
       List<Area> list =  areaService.queryListByPid(pid);
       return ServerResponse.success(list);
    }
    @RequestMapping("addArea")
    @ResponseBody
    public ServerResponse addArea(Area area){
          areaService.addArea(area);
        return ServerResponse.success();
    }
    @RequestMapping("queryList")
    @ResponseBody
    public ServerResponse queryList(){
        List<Area> list =  areaService.queryList();
        return ServerResponse.success(list);
    }
    @RequestMapping("deleteArea")
    @ResponseBody
    public ServerResponse deleteArea(@RequestParam("idList[]") List idList){
        areaService.deleteArea(idList);
        return ServerResponse.success();
    }
    @RequestMapping("updateArea")
    @ResponseBody
    public ServerResponse updateArea(Area area){
        areaService.updateArea(area);
        return ServerResponse.success();
    }

}
