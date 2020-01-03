package com.fh.aspect;

import com.fh.common.LogMsg;
import com.fh.model.Log;
import com.fh.model.User;
import com.fh.service.log.LogService;
import com.fh.util.SystemConstant;
import net.sf.json.JSONSerializer;
import org.apache.commons.lang3.RandomStringUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.Map;
@Component
@Aspect
public class LogAspect {
    private static final Logger LOGGER =  LoggerFactory.getLogger(LogAspect.class);
    @Resource
    private LogService logService;

    @Pointcut("execution(* com.fh.controller..*.add*(..))||execution(* com.fh.controller..*.update*(..))||execution(* com.fh.controller..*.del*(..))")
    public void pointCuts(){

    }

    @Before("pointCuts()")
    public void beforeaaa(){
        System.out.println("===========================before==========");
    }

    @Around("pointCuts()")
    public Object doLog(ProceedingJoinPoint pjp){
        ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = requestAttributes.getRequest();
        User user = (User) request.getSession().getAttribute(SystemConstant.LOGGIN_CURRENT_USER);
        String userName="游客";
        //获取当前用户名
        if(user!=null){
            userName= user.getUserName();
        }
        //获取类名
        String className = pjp.getTarget().getClass().getCanonicalName();
        //获取方法名
        String methodName = pjp.getSignature().getName();
        //获取参数
        Map<String, String[]> parameterMap = request.getParameterMap();
        String jsonString = JSONSerializer.toJSON(parameterMap).toString();
        //获取注解里面的value
        String action="";
               //获取方法签名
        MethodSignature signature = (MethodSignature) pjp.getSignature();
               //获取方法
        Method method = signature.getMethod();
                 //判断是否存在LogMsg.class注解
        if(method.isAnnotationPresent(LogMsg.class)){
                 //获取该注解
            LogMsg annotation = method.getAnnotation(LogMsg.class);
            action = annotation.value();
        }


        Object result = null;
       // System.out.println("==========doLog=========");
        try {
            result = pjp.proceed();
            LOGGER.info("{}调用了{}中的{}方法,请求的参数{}",userName,className,methodName,jsonString);
            String info=userName+"调用了"+className+"中的"+methodName+"的方法";
            saveLog(userName, jsonString, action, info, SystemConstant.LOG_SUCCESS);


        } catch (Throwable throwable) {
            throwable.printStackTrace();
            LOGGER.info("{}调用了{}中的{}方法,请求的参数{},请求失败,失败原因{}",userName,className,methodName,jsonString,throwable.getMessage());
            String info=userName+"调用了"+className+"中的"+methodName+"的方法,错误信息："+throwable.getMessage();
            saveLog(userName, jsonString, action, info, SystemConstant.LOG_ERROR);
        }
    return result;
    }

    private void saveLog(String userName, String jsonString, String action, String info, int i) {
        Log log = new Log();
        log.setUserName(userName);
        log.setInfo(info);
        log.setParamContent(jsonString);
        log.setStatus(i);
        log.setCreateDate(new Date());
        log.setAction(action);
        logService.addLog(log);
    }
}
