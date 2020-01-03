package com.fh.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fh.model.Brand;
import com.fh.model.Page;
import com.fh.model.Product;
import com.fh.param.ProductSearchParam;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by gy on 2019/10/14.
 */

public interface ProductMapper extends BaseMapper<Product> {
    List<Product> queryList(ProductSearchParam productSearchParam);

    Long queryTotalCount(ProductSearchParam productSearchParam);

    List getBrandList();

    long queryCount(ProductSearchParam productSearchParam);

    List queryMapList(ProductSearchParam productSearchParam);

    void addProduct(Product product);

    void deleteProduct(Integer id);

    Product getProductById(Integer id);

    void updateProduct(Product product);

    void deleteBatch(List idList);

    List queryListNoPage(ProductSearchParam productSearchParam);

    Integer getBrandIdByBrandName(String brandName);

    void addBrand(Brand brand);

    void addProductList(List<Product> list);
}
