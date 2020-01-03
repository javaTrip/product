package com.fh.Inteceptor;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fh.common.Ignore;
import com.fh.mapper.ResourceMapper;
import com.fh.model.Resource;
import com.fh.model.User;
import com.fh.util.SystemConstant;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.invoke.MethodHandle;
import java.lang.reflect.Method;
import java.util.List;

public class PremissionInterceptor extends HandlerInterceptorAdapter {


    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
       System.out.println("=====权限拦截器==========");
        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        //判断该方法是否有自定义的注解  有注解的方法是要放开的方法
        if(method.isAnnotationPresent(Ignore.class)){
            return true;
        }


       //获取当前请求路径
        String requestURI = request.getRequestURI();

        //获取当前用户所拥有的资源
        List<Resource> resourceList = (List<Resource>) request.getSession().getAttribute(SystemConstant.CURRENT_RESOURCELIST);

       //获取所有的资源
        List<Resource> allResourceList = (List<Resource>) request.getSession().getAttribute(SystemConstant.ALL_RESOURCELIST);
        boolean isFilter=false;

        if(null !=allResourceList && allResourceList.size()>0){
            for (Resource resource : allResourceList) {
                if(StringUtils.isNotBlank(resource.getUrl())&&requestURI.contains(resource.getUrl())){
                    isFilter=true;  //该请求存在于所有资源中  需要进行下一步的权限判断
                    break;
                }
            }
        }
        if(!isFilter){
            //该请求  不存在与全部资源中  不需要进行权限验证  直接放行
            return true;
        }
         boolean hasPremission = false;
      //判断当前请求路径 是否在用户拥有的资源里面
        if(resourceList !=null && resourceList.size()>0){
            for (Resource resource : resourceList) {
                if(StringUtils.isNotBlank(resource.getUrl())&&requestURI.contains(resource.getUrl())){
                    //用户拥有当前请求的资源
                    hasPremission =  true;
                    break;
                }
            }
        }

        if(!hasPremission){
            //重定向到 没有权限页面
           response.sendRedirect(SystemConstant.NO_PREMISSION_PAGE);
        }
        return hasPremission;
    }
}
