package com.movieticket.entity;

import java.util.Date;

public class Admin {
    private Integer id;
    private String username;
    private String password;
    private Date createTime;
    
    // 构造方法
    public Admin() {}
    
    public Admin(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    // getter和setter方法
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}