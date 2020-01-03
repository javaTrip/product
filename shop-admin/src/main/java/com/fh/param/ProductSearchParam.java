package com.fh.param;

import com.fh.model.Page;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * Created by gy on 2019/10/14.
 */
public class ProductSearchParam extends Page{
    private String productName;
    private Integer brandId;
    private Double minPrice;
    private Double maxPrice;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date minDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date maxDate;

    public ProductSearchParam() {
    }

    public Date getMinDate() {
        return minDate;
    }

    public void setMinDate(Date minDate) {
        this.minDate = minDate;
    }

    public Date getMaxDate() {
        return maxDate;
    }

    public void setMaxDate(Date maxDate) {
        this.maxDate = maxDate;
    }

    public ProductSearchParam(String productName, Integer brandId, Double minPrice, Double maxPrice) {
        this.productName = productName;
        this.brandId = brandId;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getBrandId() {
        return brandId;
    }

    public void setBrandId(Integer brandId) {
        this.brandId = brandId;
    }

    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    public Double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(Double maxPrice) {
        this.maxPrice = maxPrice;
    }
}
