package com.fh.service.area;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fh.mapper.AreaMapper;
import com.fh.model.Area;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AreaServiceImpl implements AreaService {
    @Autowired
    private AreaMapper areaMapper;

    @Override
    public List<Area> queryListByPid(Integer pid) {
        QueryWrapper<Area> query = new QueryWrapper<>();
            query.eq("pid",pid);
        return areaMapper.selectList(query);
    }

    @Override
    public void addArea(Area area) {
        areaMapper.insert(area);
    }

    @Override
    public List<Area> queryList() {
        QueryWrapper queryWrapper = new QueryWrapper();
        return areaMapper.selectList(queryWrapper);
    }

    @Override
    public void deleteArea(List idList) {
        areaMapper.deleteBatchIds(idList);
    }

    @Override
    public void updateArea(Area area) {
        areaMapper.updateById(area);
    }
}
