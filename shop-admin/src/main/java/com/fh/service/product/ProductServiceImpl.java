package com.fh.service.product;

import com.fh.mapper.ProductMapper;
import com.fh.model.Brand;
import com.fh.model.Product;
import com.fh.param.ProductSearchParam;
import com.fh.util.SystemConstant;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by gy on 2019/10/14.
 */
@Service
public class ProductServiceImpl  implements  ProductService{
    @Autowired
    private ProductMapper productMapper;

    @Override
    public List<Product> queryList(ProductSearchParam productSearchParam) {
        return productMapper.queryList(productSearchParam);
    }

    @Override
    public Long queryTotalCount(ProductSearchParam productSearchParam) {
        return productMapper.queryTotalCount(productSearchParam);
    }

    @Override
    public List getBrandList() {
        return productMapper.getBrandList();
    }

    @Override
    public long queryCount(ProductSearchParam productSearchParam) {
        return productMapper.queryCount( productSearchParam);
    }

    @Override
    public List queryMapList(ProductSearchParam productSearchParam) {
        return productMapper.queryMapList(productSearchParam);
    }

    @Override
    public void addProduct(Product product) {
        productMapper.addProduct( product);
    }

    @Override
    public void deleteProduct(Integer id) {
        productMapper.deleteProduct(id);
        //throw new AjaxException();
    }

    @Override
    public Product getProductById(Integer id) {
        return productMapper.getProductById(id);
    }

    @Override
    public void updateProduct(Product product) {
        productMapper.updateProduct(product);
    }

    @Override
    public void deleteBatch(List idList) {
        productMapper.deleteBatch(idList);
    }

    @Override
    public List queryListNoPage(ProductSearchParam productSearchParam) {
        return  productMapper.queryListNoPage( productSearchParam);
    }

    @Override
    public void uploadExcel(String filePath, HttpServletRequest request) {
        //获取项目所在的目录
        String path = request.getServletContext().getRealPath("/");
        //文件所在的绝对路径
        String realPath = path+"/"+filePath;
        File file = new File(realPath);
        try {
            Workbook workbook = WorkbookFactory.create(new FileInputStream(file));
            Sheet sheet = workbook.getSheetAt(0);
            int rowNum = sheet.getLastRowNum();

            List<Product> list = new ArrayList<>();

            for (int i = 1; i <= rowNum; i++) {
                Row row = sheet.getRow(i);
                Product product = buildProduct(row);
                list.add(product);
                if(list.size()== SystemConstant.ADD_PRODUCT_LIST_SIZE){
                    System.out.println("-----------");
                    productMapper.addProductList(list);
                    list.clear();
                }
            }
            //不够个数的时候
            if(list.size()>0){
                System.out.println("======");
                productMapper.addProductList(list);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    @Override
    public void updateProductStatus(Integer id, Integer status) {
        Product product =new Product();
        product.setId(id);
        product.setStatus(status);
        productMapper.updateById(product);
    }

    private Product buildProduct(Row row) {
        String productName = row.getCell(0).getStringCellValue();
        double price = row.getCell(1).getNumericCellValue();
        String brandName = row.getCell(2).getStringCellValue();
       // System.out.println(productName+"---"+price+"--"+brandName);
        //通过brandName获取brandId  因为商品表中存的是brandId
        Integer brandId = productMapper.getBrandIdByBrandName(brandName);
        if(brandId==null){
            Brand brand = new Brand();
            brand.setBrandName(brandName);
            productMapper.addBrand(brand);
            brandId = brand.getId();
        }
        Product p = new Product();
        p.setName(productName);
        p.setPrice(price);
        p.setBrandId(brandId);
        return p;
    }


}
