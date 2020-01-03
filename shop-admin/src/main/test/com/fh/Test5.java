package com.fh;

import jdk.management.resource.internal.inst.FileOutputStreamRMHooks;
import org.junit.Test;

import java.util.*;

public class Test5 {
    @Test
    public void test1(){
        Map<String,String> map = new HashMap<String,String>();
        map.put("name","张三");
        map.put("age","14");
        map.put("sex","男");
        map.put("weight","78kg");
        Set<String> keySet = map.keySet();
        for (String s : keySet) {
            System.out.println(s+":"+map.get(s));

        }
    }
    @Test
    public void test2(){
        Map<String,String> map = new HashMap<String,String>();
        map.put("name","张三");
        map.put("age","14");
        map.put("sex","男");
        map.put("weight","78kg");
        Iterator<Map.Entry<String, String>> iterator = map.entrySet().iterator();
        while(iterator.hasNext()){
            Map.Entry<String, String> entry = iterator.next();
            System.out.println(entry.getKey()+":"+entry.getValue());
        }

    }
    @Test
    public void test3(){
        Map<String,String> map = new HashMap<String,String>();
        map.put("name","张三");
        map.put("age","14");
        map.put("sex","男");
        map.put("weight","78kg");
        map.forEach((x,y)->System.out.println(x+":"+y));
    }
    @Test
    public void test4(){
        List<String> list = new ArrayList<String>();
        list.add("张三1");
        list.add("张三2");
        list.add("张三3");
        list.add("张三4");

      //  list.forEach(x->{System.out.println(x);});
        list.forEach(System.out::println);
    }

    @Test
    public void test5(){
        List<String> list = new ArrayList<String>();
        list.add("张三1");
        list.add("张三2");
        list.add("张三3");
        list.add("张三4");
        //   ::左边是类或者是对象     右边是方法名
       // list.forEach(new Test5()::demo);
        list.forEach(this::demo);
    }

    private void demo(String s){
        System.out.println(s);
    }


    public void  b(){
         //(s)->{ System.out.println(s);
         Abc  abc = (s)->{System.out.println(s);
                   return s+1;};
    }

}
