package com.fh.model;

import com.baomidou.mybatisplus.annotation.TableField;

public class Resource {
    private Integer id;
    private String name;
    private String url;
    private Integer pid;
    private Integer type;
    @TableField(exist = false)
    private Boolean checked =false;

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public Resource() {
    }

    public Resource(Integer id, String name, String url, Integer pid, Integer type) {
        this.id = id;
        this.name = name;
        this.url = url;
        this.pid = pid;
        this.type = type;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}
