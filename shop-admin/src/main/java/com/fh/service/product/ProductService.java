package com.fh.service.product;

import com.fh.model.Product;
import com.fh.param.ProductSearchParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by gy on 2019/10/14.
 */
public interface ProductService {
    List<Product> queryList(ProductSearchParam page);

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

    void uploadExcel(String filePath, HttpServletRequest request);

    void updateProductStatus(Integer id, Integer status);
}
