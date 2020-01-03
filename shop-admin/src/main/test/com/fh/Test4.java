package com.fh;

import org.junit.Test;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Test4 {
    @Test
    public void test (){
        Map <String, String> map = new HashMap<String,String>();
        map.put("name","细致杨");
        map.forEach((x,y)->System.out.println(x+y));
    }

    @Test
    public void test9 (){
        Map <String, String> map = new HashMap<String,String>();
        map.put("name","细致杨");
        Iterator<Map.Entry<String, String>> iterator = map.entrySet().iterator();
        while (iterator.hasNext()){
            System.out.println(iterator.next());
        }

    }

    @Test
    public void test11(){
        List<Integer> list = new ArrayList<Integer>();
        list.add(1);
        list.add(2);
        list.add(3);
        list.add(4);
        list.add(5);
        list.add(6);
        list.add(6);
        list.add(6);


        list.forEach(System.out::println);

        list.stream().filter(a -> a%2==0).skip(2).limit(6).distinct().collect(Collectors.toList());

        list.stream().filter(a -> a%2==0).skip(2).limit(6).distinct().forEach(x->System.out.println(x));
        //Stream.of(list).filter(n -> n != 2);
     /*   for (int i = 0; i < list.size(); i++) {
            if(list.get(i)%2==0){
                reList.add(list.get(i))  ;
            }
        }

        for (int i = 0; i < reList.size(); i++) {
           System.out.println(reList.get(i)) ;

        }*/

    }


    @Test
    public void test1(){
        Map map = new HashMap<>();
        map.put("name","张三");
        map.put("age","12");
        map.put("sex","男");
        map.put("手机号码","123456");

        Iterator iterator =map.entrySet().iterator();
        while(iterator.hasNext()){
            Map.Entry next = (Map.Entry) iterator.next();
            System.out.println(next.getKey()+":"+next.getValue());
        }
    }
    @Test
    public void test2(){
        Map map = new HashMap<>();
        map.put("name","张三");
        map.put("age","12");
        map.put("sex","男");
        map.put("手机号码","123456");

        map.forEach((key,value)->System.out.println(key+":"+value));
    }
    @Test
    public void test3(){
        List<String> list = new ArrayList();
        list.add("adfd");
        list.add("bbb");
        list.add("ccc");
     //   list.forEach(x->{System.out.println(x);});
       // list.forEach(System.out::println);
        list.forEach(this::test4);

    }
    public void test4(String a){
        System.out.println(a);
    }

    public Integer operation(Integer num, MyFun mf) {
        return mf.getValue(num);
    }

    @Test
    public void test10() {
        System.out.println(operation(10, (x) -> x * x));

        System.out.println(operation(1, x -> x + x));
    }
}
