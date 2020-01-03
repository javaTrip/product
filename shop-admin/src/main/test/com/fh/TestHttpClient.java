package com.fh;

import com.alibaba.fastjson.JSON;
import com.fh.model.User;
import org.apache.http.HttpEntity;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.junit.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class TestHttpClient {
    @Test
    public void testGet(){
        //打开浏览器
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        //输入网址
        HttpGet httpGet = new HttpGet("http://localhost:8081/resource/index.do");
        CloseableHttpResponse response =null;
        try {
            //回车
             response = httpClient.execute(httpGet);
            HttpEntity entity = response.getEntity();
            String string = EntityUtils.toString(entity, "utf-8");
            System.out.println(string);
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                if(response !=null){
                    response.close();
                }
                if(httpClient !=null){
                    httpClient.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

    }
    @Test
    public void testGet1(){
        //打开浏览器
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        StringBuffer param = new StringBuffer("?");
        param.append("userName=admin");
        param.append("&passWord=123");
        //输入网址
        HttpGet httpGet = new HttpGet("http://localhost:8081/user/login.do"+param.toString());
        CloseableHttpResponse response =null;
        try {
            //回车
            response = httpClient.execute(httpGet);
            HttpEntity entity = response.getEntity();
            String string = EntityUtils.toString(entity, "utf-8");
            System.out.println(string);
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                if(response !=null){
                    response.close();
                }
                if(httpClient !=null){
                    httpClient.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

    }
    @Test
    public void testPost(){
        //打开浏览器
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        //json传参
        User user = new User();
        user.setUserName("admin");
        user.setPassWord("123");
        String paramJson = JSON.toJSONString(user);
        //输入网址
        HttpPost httpPost = new HttpPost("http://localhost:8081/user/login.do");
        httpPost.setHeader("Content-Type","application/json");
       // httpPost.setHeader("Accept","application/json");
        StringEntity stringEntity = new StringEntity(paramJson,"utf-8");
        httpPost.setEntity(stringEntity);
        CloseableHttpResponse response =null;
        try {
            //回车
            response = httpClient.execute(httpPost);
            HttpEntity entity = response.getEntity();
            String string = EntityUtils.toString(entity, "utf-8");
            System.out.println(string);
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                if(response !=null){
                    response.close();
                }
                if(httpClient !=null){
                    httpClient.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

    }
    @Test
    public void testPost2(){
        //打开浏览器
        CloseableHttpClient httpClient = HttpClientBuilder.create().build();
        //form传参
        List<BasicNameValuePair> paramList = new ArrayList<>();
        paramList.add(new BasicNameValuePair("userName","admin"));
        paramList.add(new BasicNameValuePair("passWord","123"));
        //输入网址
        HttpPost httpPost = new HttpPost("http://localhost:8081/user/login.do");
        httpPost.setHeader("Content-Type","application/x-www-form-urlencoded");
      //  httpPost.setHeader("Accept","application/json");

        CloseableHttpResponse response =null;
        try {
            UrlEncodedFormEntity encodedFormEntity = new UrlEncodedFormEntity(paramList,"utf-8");
           // encodedFormEntity.setContentType("application/x-www-form-urlencoded");
            httpPost.setEntity(encodedFormEntity);
            //回车
            response = httpClient.execute(httpPost);
            HttpEntity entity = response.getEntity();
            String string = EntityUtils.toString(entity, "utf-8");
            System.out.println(string);
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                if(response !=null){
                    response.close();
                }
                if(httpClient !=null){
                    httpClient.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        }

    }
}
