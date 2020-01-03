<%--
  Created by IntelliJ IDEA.
  User: gy
  Date: 2019/10/18
  Time: 9:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">飞狐教育</a>
        </div>

        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav" id="item-ul">
               <%-- <li id="item1" class="active"><a href="/index.do#1">商品管理</a></li>
                <li id="item2"><a href="/category/index.do#2">分类管理</a></li>
                <li id="item6"><a href="/area/index.do#6">地区管理</a></li>
                <li id="item3"><a href="/user/index.do#3">用户管理</a></li>
                <li id="item4"><a href="/log/index.do#4">日志管理</a></li>
                <li id="item7"><a href="/role/index.do#7">角色管理</a></li>
                <li id="item8"><a href="/resource/index.do#8">资源管理</a></li>--%>
            </ul>
            <ul class="nav navbar-nav navbar-right">

                <li ><a href="/user/refresh.do">刷新</a></li>
                <li ><a href="/user/loginOut.do">退出</a></li>
            </ul>


        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>
</body>
<script>
    var imgUrl="http://192.168.12.1:80/";
    $.ajaxSetup({
        complete:function(data,TS){
        var time =     data.getResponseHeader("ajaxTime");
        if(time=="timeOut"){
            window.location.href="/login.jsp"
        }
    //对返回的数据data做判断，
    //session过期的话，就location到一个页面
        }
    });



    $(function () {
        buildMenu();
        getResource();
        //获取请求路径#的值
       var hash =  window.location.hash
       if(hash.length>0){
           //清除所有的样式
           $("#item-ul >li").removeClass("active");
           //去除#
         var id=  hash.substring(1);
         //给指定的标签加样式
           $("#item"+id).addClass("active");
       }

    })
    var resourceList=[];
    function buildMenu(){
        $.ajaxSettings.async = false;
        $.post(
            "<%=request.getContextPath()%>/resource/getCurrentUserResource.do",
            function(data){
               if(data.status==200){
                   resourceList = data.data;
                   var str="";
                   for (var i = 0; i < resourceList.length; i++) {
                       var resource = resourceList[i];
                       if(resource.type==1){//判断是菜单   按钮不要
                           str +='<li id="item'+resource.id+'"><a href="'+resource.url+'#'+resource.id+'">'+resource.name+'</a></li>';
                       }
                   }
                   $("#item-ul").append(str);
               }
            }
        )
        $.ajaxSettings.async = true;
    }

    //按钮权限
    var btn_add="hidden";
    var btn_update="hidden";
    var btn_delete="hidden";
    function getResource(){
        //获取请求路径#的值
        var hash =  window.location.hash
        //把#去掉
        var menuId= hash.substring(1);
        for (var i = 0; i < resourceList.length; i++) {
            var resource = resourceList[i];
            //判断是否是当前菜单下的按钮
            if(menuId==resource.pid){
                if(resource.name=="修改"){
                    btn_update ="";
                }
                if(resource.name=="增加"){
                    btn_add ="";
                }
                if(resource.name=="删除"){
                    btn_delete ="";
                }
            }
        }
    }

</script>
</html>
