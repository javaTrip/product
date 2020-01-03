<%--
  Created by IntelliJ IDEA.
  User: gy
  Date: 2019/10/24
  Time: 11:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>找回密码</title>
    <jsp:include page="common/script.jsp"></jsp:include>
</head>
<body>
    <br>
    <form class="form-horizontal" style="margin-left: 500px">
       <font style="margin-left: 100px;" size="9">找回密码</font>
        <div class="control-group" style="margin-top: 50px">
            <div class="controls">
                <label class="control-label" >注册手机号</label>
                <input type="text" id="phone" placeholder="注册手机号">
                <button type="button" class="btn btn-info " onclick="sendCode()">
                    获取验证码
                </button>
            </div>
        </div>
        <br>
        <div class="control-group">
            <div class="controls">
                <label class="control-label" for="passWord">验证码</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="password" id="code" placeholder="验证码">
            </div>
        </div><br>
        <div class="control-group">
            <div class="controls">
                <label class="control-label" for="passWord">密码</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="password" id="passWord" placeholder="密码">
            </div>
        </div><br>
        <div class="control-group">
            <div class="controls">
                <label class="control-label" for="passWord">确认密码</label>&nbsp;&nbsp;&nbsp;
                <input type="password" id="passWord2" placeholder="确认密码">
            </div>
        </div>
        <br>
       <br>
        <div style="margin-left: 80px">
            <button type="button" class="btn btn-danger " onclick="callBackPassword()">
              确认
            </button>&nbsp;&nbsp;&nbsp;

        </div>
    </form>
</body>
<script>
    function sendCode(){
        var phone = $("#phone").val();
        $.post(
            "/user/sendCode.do",
            {"phone":phone},
            function (result){
                 if(result.status==200){
                     var res= result.data;
                     if(res==2){
                         bootbox.alert("发送失败！");
                     }else if(res==3){
                         bootbox.alert("手机号不能为空！");
                     }

                 }else{
                     bootbox.alert("发送失败！");
                 }
            }
        )

    }

   function callBackPassword(){
       var phone = $("#phone").val();
       var code = $("#code").val();
       var passWord = $("#passWord").val();
       var rePassword = $("#passWord2").val();
       if(passWord!=null && passWord==rePassword){
           $.post(
               "/user/updatePassword.do",
               {"phone":phone,"code":code,"passWord":passWord},
               function (result){
                   if(result.status==200){
                      location.href="/login.jsp"

                   }else if(result.status==1001){
                       bootbox.alert("验证码输入错误！");
                   }else{
                       bootbox.alert("操作失败！");
                   }
               }
           )

       }else{
           bootbox.alert("两次密码输入不一致！");
       }


   }

</script>

</html>
