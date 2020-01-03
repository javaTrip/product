package com.fh;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.segments.MergeSegments;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.fh.mapper.AreaMapper;
import com.fh.model.Area;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"classpath:spring/spring-common.xml"})
public class TestAreaService {
    @Autowired
    private AreaMapper areaMapper;
    @Test
    public void testAdd(){
        Area area = new Area();
        area.setName("开封123");
        area.setPid(4);
        area.setInfo("afdasfhjkau");
        areaMapper.insert(area);
    }
    @Test
    public void testUpdate(){
        Area area = new Area();
        area.setId(7);
        area.setName("南阳");
        areaMapper.updateById(area);

    }
    @Test
    public void testDelete(){
        areaMapper.deleteById(7);
    }
    @Test
    public void testSelect(){

        QueryWrapper<Area> queryWrapper =new QueryWrapper();
        //queryWrapper.eq("id",9);
      //  queryWrapper.between("id",12,15);
        queryWrapper.like("areaname","州");
        List<Area> list = areaMapper.selectList(queryWrapper);
        list.forEach(System.out::println);

    }
    @Test
    public void testSelectPage(){

        QueryWrapper<Area> queryWrapper =new QueryWrapper();
        IPage<Area> areaIPage = areaMapper.selectPage(new Page<Area>(1, 6), queryWrapper);
        areaIPage.getRecords().forEach(System.out::println);

    }




}
