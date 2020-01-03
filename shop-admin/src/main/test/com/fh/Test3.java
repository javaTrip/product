package com.fh;

import org.junit.Test;

public class Test3 {
    @Test
    public void aa(){
        Integer test = test3(3);
    }

    public Integer test3(Integer a){
        if(a==1){
            return a;
        }
        return a * test3(--a);
    }
}
