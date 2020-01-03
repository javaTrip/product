package com.fh;

import org.junit.Test;

public class RecursiveTest {
    @Test
    public void test1(){
        int s= jiecheng(4);
        System.out.println(s);
    }
    public int jiecheng(int a){
        int c = 1;
        for (int i =a; i >=1 ; i--) {
           c =c*i;
        }
        return c;
    }

    /**
     * 1.自己调用自己
     * 2.有一个退出条件
     * @return
     */
    public int recursive(int a){
        if(a==1){
            return 1;
        }
        //a=10  10 * recursive(9)
        //a=9    9 * recursive(8)
        //a=8    8 * recursive(7)
        //a=7    7 * recursive(6)
        return a * recursive(--a);
       // 10*9 * 8 * 7 * 6*5*4*3*2*1
    }
}
