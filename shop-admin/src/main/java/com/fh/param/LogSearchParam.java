package com.fh.param;

import com.fh.model.Page;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class LogSearchParam extends Page {
    private Integer status;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date  minDate;
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date  maxDate;
    private String userName;
    private String action;

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}
