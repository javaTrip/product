package com.fh.service.user;

import com.alibaba.fastjson.JSON;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fh.common.ServerResponse;
import com.fh.mapper.ResourceMapper;
import com.fh.mapper.UserMapper;
import com.fh.mapper.UserRoleMapper;
import com.fh.model.Resource;
import com.fh.model.User;
import com.fh.model.UserRole;
import com.fh.param.UserSearchParam;
import com.fh.util.*;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UserRoleMapper userRoleMapper;
    @Autowired
    private ResourceMapper resourceMapper;

   /* @Override
    public ServerResponse getUserByName(String userName) {
        int a=0;
        User user =  userMapper.getUserByName(userName);
        if(user ==null){
            //用户不存在   可以注册
            a=1;
        }else{
            //用户已存在   不可以注册
            a=2;
        }
        return ServerResponse.success(a);
    }*/
    @Override
    public boolean getUserByName(String userName) {

        User user =  userMapper.getUserByName(userName);
        if(user ==null){
            //用户不存在   可以注册
           return true;
        }else
            //用户已存在   不可以注册
            return false;
    }


    @Override
    public ServerResponse queryList(UserSearchParam userSearchParam) {
        //查询总条数
        long totalCount = userMapper.queryCount(userSearchParam);
        List<User> list =  userMapper.queryList(userSearchParam);
        Map map = new HashMap();
        map.put("draw",userSearchParam.getDraw());
        map.put("recordsTotal",totalCount);
        map.put("recordsFiltered",totalCount);
        map.put("data",list);

        return ServerResponse.success(map);
    }

    @Override
    public ServerResponse addUser(User user,List<Integer> roleArr) {
       String salt =  RandomStringUtils.randomAlphanumeric(20);
       String encodePassWord =  Md5Util.md5(Md5Util.md5(user.getPassWord()+salt))  ;
       user.setPassWord(encodePassWord);
        user.setSalt(salt);
       // userMapper.addUser( user);
        userMapper.insert(user);
        //增加用户 绑定角色
        if(roleArr!=null && roleArr.size()>0){
            roleArr.forEach(x->{
                UserRole userRole = new UserRole();
                userRole.setUserId(user.getId());
                userRole.setRoleId(x);
                userRoleMapper.insert(userRole);
            });


        }


        return ServerResponse.success();
    }

    @Override
    public ServerResponse login(User user, HttpServletRequest request, HttpServletResponse response) {
        int flag=0;
        User us =  userMapper.getUserByName(user.getUserName());
        if(us==null){
            //用户不存在
            flag= SystemConstant.LOGGIN_USERNAME_ERROR;
        }else{
           String encodePassWord =  Md5Util.md5(Md5Util.md5(user.getPassWord()+us.getSalt()));
            if(!us.getPassWord().equals(encodePassWord)){
                //用户密码错误
                flag=SystemConstant.LOGGIN_PASSWORD_ERROR;
            }else{
                //登陆成功
                flag=SystemConstant.LOGGIN_SUCCESS;
                //把数据放在缓存中
                writeCache(request, us,response);
                //记住我 一周
                if(user.getRememberMe()!=null &&user.getRememberMe()==1){
                    writeCookie(user, response);
                }


            }
        }
        return ServerResponse.success(flag);
    }
   //登陆成功之后 把经常使用  但不经常改变的数据放在缓存中  方便用的时候直接取
    private void writeCache(HttpServletRequest request, User us,HttpServletResponse response) {
        //把用户信息放到session中
       // request.getSession().setAttribute(SystemConstant.LOGGIN_CURRENT_USER,us);
        String jsonString = JSON.toJSONString(us);
        //首先获取session  拿着sessionid作为key
        String sessionId = SessionUtil.getSessionId(request, response);
        RedisUtil.set(SystemConstant.LOGGIN_CURRENT_USER+sessionId,jsonString);


        //把当前用户所拥有的资源放到session中去
        //获取当前用户所拥有的资源
        List<Resource> resourceList =  resourceMapper.getCurrentUserResource(us.getId());
        request.getSession().setAttribute(SystemConstant.CURRENT_RESOURCELIST,resourceList);
        //获取所有的资源放到session中去
        QueryWrapper<Resource> queryWrapper = new QueryWrapper<>();
        List<Resource> allResourceList = resourceMapper.selectList(queryWrapper);
        request.getSession().setAttribute(SystemConstant.ALL_RESOURCELIST,allResourceList);



    }

    @Override
    public ServerResponse deleteUser(Integer id) {
        userMapper.deleteById(id);
        return ServerResponse.success();
    }

    @Override
    public void loginOut(HttpServletRequest request, HttpServletResponse response) {
        //清除session中所有数据
        request.getSession().invalidate();
        //清除cookie
        cleanCookie(response);
    }

    @Override
    public void refresh(HttpServletRequest request) {
        User user = (User) request.getSession().getAttribute(SystemConstant.LOGGIN_CURRENT_USER);
     //   writeCache(request,user,);

    }

    @Override
    public ServerResponse sendCode(String phone,HttpServletRequest request) {
        Integer flag=null;
        if(StringUtils.isNotBlank(phone)){
            //发送验证码
            String code = SendMsgUtil.sendCode(phone);
            if(StringUtils.isNotBlank(code)){
                //把验证码存在session中
                request.getSession().setAttribute(SystemConstant.CODE,code);
                //验证码发送成功
                flag =1;
            }else{
                //验证码发送失败
                flag=2;
            }
        }else{
            //手机号为空
            flag=3;
        }
        return ServerResponse.success(flag);
    }

    @Override
    public ServerResponse updatePassword(User user, String code, HttpServletRequest request) {
         //首先验证验证码是否正确
        String sessionCode = (String) request.getSession().getAttribute(SystemConstant.CODE);
        if(StringUtils.isNotBlank(code)&&code.equals(sessionCode)){
            //根据手机号 找到用户信息
            QueryWrapper queryWrapper =new QueryWrapper();
            queryWrapper.eq("phone",user.getPhone());
            //密码加密  MD5+盐
            String salt =  RandomStringUtils.randomAlphanumeric(20);
            String encodePassWord =  Md5Util.md5(Md5Util.md5(user.getPassWord()+salt))  ;
            user.setPassWord(encodePassWord);
            user.setSalt(salt);

           userMapper.update(user,queryWrapper);
            return ServerResponse.success();
        }else{
            return ServerResponse.code_error();
        }

    }

    private void cleanCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(SystemConstant.COOKIE_KEY,"");
        //设置cookie过期时间 单位是秒
        cookie.setMaxAge(0);
        //cookie.setMaxAge(1*60);
        //这种cookie作用域
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    private void writeCookie(User user, HttpServletResponse response) {
        //把用户信息存储到cookie中
        try {
        String encodeUserName = URLEncoder.encode(user.getUserName(),"UTF-8");
        Cookie cookie = new Cookie(SystemConstant.COOKIE_KEY,encodeUserName);
        //设置cookie过期时间 单位是秒
        cookie.setMaxAge(SystemConstant.COOKIE_OUT_TIME);
        //cookie.setMaxAge(1*60);
        //这种cookie作用域
        cookie.setPath("/");
        response.addCookie(cookie);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
    }
}
