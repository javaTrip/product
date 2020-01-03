package com.fh.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fh.model.Resource;

import java.util.List;

public interface ResourceMapper extends BaseMapper<Resource> {
    List<Resource> getCurrentUserResource(Integer id);
}
