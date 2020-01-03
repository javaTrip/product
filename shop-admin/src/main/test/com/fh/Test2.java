package com.fh;

import org.junit.Test;

import java.io.File;

public class Test2 {
    @Test
    public void ccc(){
       int v= aaa(6);
        System.out.println(v);
    }
    public  int aaa(int b){
        if(b==1){
            return 1;
        }
        return b+aaa(--b);
    }
    @Test
    public void test2(){
        getFile("C:\\Users\\gy\\Desktop\\aaa");
    }

    public void getFile(String path){
        File file = new File(path);
        //判断是否是文件夹
        if(file.isDirectory()){
            //获取该文件夹下的所有文件
            File[] files = file.listFiles();
            for (int i = 0; i < files.length; i++) {
                File f = files[i];
               System.out.println(f.getName());
                if(f.isDirectory()){
                    getFile(f.getPath());
                }

            }
        }
    }


}
