package com.fh.controller;

import com.fh.common.ServerResponse;
import com.fh.param.LogSearchParam;
import com.fh.service.log.LogService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@Controller
@RequestMapping("log/")
public class LogController {
    @Resource
    private LogService logService;
    @RequestMapping("index")
    public String index(){
        return "log/list";
    }
    @RequestMapping("queryList")
    @ResponseBody
    public ServerResponse  queryList(LogSearchParam logSearchParam){
        return logService.queryList(logSearchParam);
    }
}
