package com.fh.Inteceptor;

import com.fh.common.Ignore;
import com.fh.mapper.UserMapper;
import com.fh.model.User;
import com.fh.util.RedisUtil;
import com.fh.util.SessionUtil;
import com.fh.util.SystemConstant;
import org.apache.commons.lang3.StringUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.lang.reflect.Method;
import java.net.URLDecoder;

public class LoginInteceptor implements HandlerInterceptor {
    @Resource
    private UserMapper userMapper;
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
       System.out.println("-------登陆拦截器------");
       // User user = (User) request.getSession().getAttribute(SystemConstant.LOGGIN_CURRENT_USER);
        HandlerMethod handlerMethod = (HandlerMethod) handler;
        Method method = handlerMethod.getMethod();
        //判断该方法是否有自定义的注解  有注解的方法是要放开的方法
        if(method.isAnnotationPresent(Ignore.class)){
            return true;
        }

        //获取sessionId
        String sessionId = SessionUtil.getSessionId(request, response);
        String userString = RedisUtil.get(SystemConstant.LOGGIN_CURRENT_USER + sessionId);
        if(StringUtils.isNotBlank(userString)){
            return true;
        }else{
            String requestHeader= request.getHeader("X-Requested-With");
            if(StringUtils.isNotBlank(requestHeader)&& requestHeader.equals("XMLHttpRequest")){
                response.setHeader("ajaxTime",SystemConstant.AJAX_SESSION_OUT);
                return  false;
            }

            //用户没有登陆  跳转到登陆页面
            response.sendRedirect(SystemConstant.LOGIN_PAGE);
            return false;


        }

    }
    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }
    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }
}
