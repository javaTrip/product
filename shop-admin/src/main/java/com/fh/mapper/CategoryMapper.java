package com.fh.mapper;

import com.fh.model.Category;

import java.util.List;

public interface CategoryMapper {

    List queryListByPid(Integer pid);

    void addCategory(Category category);

    List queryList();

    void updateCategory(Category category);

    void deleteCategory(List list);
}
