package com.fh;

import com.fh.util.Dog;
import com.sun.tools.internal.xjc.generator.bean.DualObjectFactoryGenerator;
import org.junit.Test;

public class TestDog {
    @Test
    public void test1(){
        Dog dog = new Dog();
        //先执行父类的静态方法，
    }
    @Test
    public void test2(){
        try {
            Class<?> aClass = Class.forName("com.fh.util.Animal");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        //先执行父类的静态方法，
    }
}
