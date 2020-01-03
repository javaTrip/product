package com.fh.service.log;

import com.fh.common.ServerResponse;
import com.fh.mapper.LogMapper;
import com.fh.model.Log;
import com.fh.param.LogSearchParam;
import org.apache.poi.ss.formula.ptg.MemAreaPtg;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LogServiceImpl implements LogService {
    @Resource
    private LogMapper logMapper;

    @Override
    public void addLog(Log log) {
        logMapper.addLog(log);
    }

    @Override
    public ServerResponse queryList(LogSearchParam logSearchParam) {
        long totalCount = logMapper.queryCount(logSearchParam);
        List<Log> list = logMapper.queryList(logSearchParam);
        Map map = new HashMap();
        map.put("draw",logSearchParam.getDraw());
        map.put("recordsTotal",totalCount);
        map.put("recordsFiltered",totalCount);
        map.put("data",list);
        return ServerResponse.success(map);
    }
}
