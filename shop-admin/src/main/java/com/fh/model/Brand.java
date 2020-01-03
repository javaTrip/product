package com.fh.model;

import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * Created by gy on 2019/10/14.
 */
public class Brand {
    private  Integer id;
    private String brandName;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date createDate;

    public Brand() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Brand(Integer id, String brandName, Date createDate) {
        this.id = id;
        this.brandName = brandName;
        this.createDate = createDate;
    }
}
