package com.fh.service.area;

import com.fh.model.Area;

import java.util.List;

public interface AreaService {
    List<Area> queryListByPid(Integer pid);

    void addArea(Area area);

    List<Area> queryList();

    void deleteArea(List idList);

    void updateArea(Area area);
}
