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
    <title>注册</title>
    <jsp:include page="common/script.jsp"></jsp:include>
</head>
<body>
<div style="margin-top: 80px;margin-left: 500px">
   <div style="margin-left: 180px;margin-bottom: 70px"> <h1>注册</h1></div>
    <form class="form-horizontal" id="formApp" action="/user/addUser.do" method="post">
        <div class="form-group">
            <label  class="col-sm-2 control-label">用户名</label>
            <div class="col-sm-2">
                <input type="text" class="form-control" name="userName"  placeholder="用户名">
            </div>
        </div>
        <div class="form-group">
            <label  class="col-sm-2 control-label">密码</label>
            <div class="col-sm-2">
                <input type="text" class="form-control" name="passWord" placeholder="密码">
            </div>
        </div>
        <div class="form-group">
            <label  class="col-sm-2 control-label">确认密码</label>
            <div class="col-sm-2">
                <input type="text" class="form-control" name="rePassWord" placeholder="确认密码">
            </div>
        </div>
        <div class="form-group" >
            <div class="col-sm-offset-2 col-sm-8">
                <button type="reset" class="btn btn-default"><i class="glyphicon glyphicon-repeat"></i>重置</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <button type="button" class="btn btn-primary" onclick="submitForm()"><i class="glyphicon glyphicon-ok"></i>提交</button>

            </div>
        </div>
    </form>
</div>
</body>
<script type="text/html" id="aaa">

</script>
<script>
    function submitForm(){
       var form = document.getElementById("formApp");
      // alert($("#formApp").serialize());
       $.post(
           "/user/addUser.do",
           $("#formApp").serialize(),
           function (result) {
               if(result.status==200){
                   location.href="/login.jsp";
               }
           }

       )
    }


    $(function(){
        initFormValidator();
    })
    function initFormValidator(){
        $('#formApp').bootstrapValidator({
            // 默认的提示消息
            message: 'This value is not valid',
            // 表单框里右侧的icon
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                userName: {
                    message: '用户名验证失败',
                    validators: {
                        notEmpty: {
                            message: '用户名不能为空'
                        },
                        remote: {//ajax验证。server result:{"valid",true or false}
                            url: "/user/checkUserByName.do",
                            message: '用户名已存在,请重新输入',
                            delay: 1000,//ajax刷新的时间是1秒一次
                            type: 'POST',
                            //自定义提交数据，默认值提交当前input value
                            data: function(validator) {
                                return {
                                    userName : $("input[name=userName]").val(),
                                };
                            }
                        }
                    }


                },
                passWord: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        }
                    }
                },
                rePassWord: {
                    validators: {
                        notEmpty: {
                            message: '密码不能为空'
                        },
                        identical: {
                             field: 'passWord',
                             message: '两次密码输入不一致'
                         }
                    }
                }
            }
        });
    }

</script>

</html>
