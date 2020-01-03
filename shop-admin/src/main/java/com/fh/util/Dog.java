package com.fh.util;

public class Dog extends  Animal{

    public Dog() {
        System.out.println("这是子类静态的构造函数");
    }

    static{
        System.out.println("这是子类静态的方法块");
    }

    {
        System.out.println("这是子类方法块");
    }
}
