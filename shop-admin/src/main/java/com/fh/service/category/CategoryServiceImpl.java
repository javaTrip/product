package com.fh.service.category;

import com.fh.mapper.CategoryMapper;
import com.fh.model.Category;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class CategoryServiceImpl implements CategoryService {
    @Resource
    private CategoryMapper categoryMapper;

    @Override
    public void addCategory(Category category) {
        categoryMapper.addCategory( category);
    }

    @Override
    public List queryListByPid(Integer pid) {
        return categoryMapper.queryListByPid(pid);
    }

    @Override
    public List queryList() {
        return categoryMapper.queryList();
    }

    @Override
    public void updateCategory(Category category) {
        categoryMapper.updateCategory(category);
    }

    @Override
    public void deleteCategory(List idList) {
        categoryMapper.deleteCategory(idList);
    }
}
