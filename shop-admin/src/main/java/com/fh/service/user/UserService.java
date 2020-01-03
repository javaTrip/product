package com.fh.service.user;

import com.fh.common.ServerResponse;
import com.fh.model.User;
import com.fh.param.UserSearchParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface UserService {
    //ServerResponse getUserByName(String userName);
    boolean getUserByName(String userName);

    ServerResponse queryList(UserSearchParam userSearchParam);

    ServerResponse addUser(User user, List<Integer> roleArr);

    ServerResponse login(User user, HttpServletRequest request, HttpServletResponse response);

    ServerResponse deleteUser(Integer id);

    void loginOut(HttpServletRequest request, HttpServletResponse response);

    void refresh(HttpServletRequest request);

    ServerResponse sendCode(String phone,HttpServletRequest request);

    ServerResponse updatePassword(User user, String code, HttpServletRequest request);
}
