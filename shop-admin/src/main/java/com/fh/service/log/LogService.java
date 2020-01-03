package com.fh.service.log;

import com.fh.common.ServerResponse;
import com.fh.model.Log;
import com.fh.param.LogSearchParam;

public interface LogService {
    void addLog(Log log);

    ServerResponse queryList(LogSearchParam logSearchParam);
}
