<%--
  Created by IntelliJ IDEA.
  User: gy
  Date: 2019/10/24
  Time: 15:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="/common/script.jsp"></jsp:include>
</head>
<script type="text/html" id="showAddDiv">
    <div  >
        <form class="form-horizontal" id="formApp" >
            <div class="form-group">
                <label  class="col-sm-2 control-label">用户名称</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_userName" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">真实名称</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_userRealName" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">密码</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_password" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">确认密码</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_confirm_password" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">用户年龄</label>
                <div class="col-sm-4">
                    <input type="text" name="price" class="form-control" id="add_age" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">用户性别</label>
                <div class="col-sm-4">
                    <div class="input-group">
                        <label class="radio-inline">
                            <input type="radio" name="add_sex" checked value="1"> 男
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="add_sex"  value="0"> 女
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">用户邮箱</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_email" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">手机号</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_phone" >
                </div>
            </div>
            <div class="form-group" id="areaDiv">
                <label  class="col-sm-2 control-label">所在地区</label>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">薪水</label>
                <div class="col-sm-4">
                    <input type="text" name="createDate" id="add_salary" class="form-control "  >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">入职时间</label>
                <div class="col-sm-4">
                    <input type="text" name="createDate" id="add_joinTime" class="form-control "  >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">角色</label>
                <div class="col-sm-4" id="showRole">

                </div>
            </div>
        </form>
    </div>
</script>
<script>
    $(function () {
        initDateTable();
    })
    function deleteUser(id){
        $.post(
            "<%=request.getContextPath()%>/user/deleteUser.do",
            {"id":id},
            function (data) {
                if(data.status==200){
                    queryList();
                }
            }
        )
    }
    function queryList(){
        $("#example").dataTable().fnDraw(false);//点击事件触发table重新请求服务器
    }
    function initDateTable(){
        myTable =    $('#example').DataTable({
            "serverSide": true,
            // 是否允许检索
            "searching": false,
            "lengthMenu": [5, 10, 20,50],
            "ajax": {
                url: '<%=request.getContextPath()%>/user/queryList.do',
                type: 'POST',
                //用于处理服务器端返回的数据。 dataSrc是DataTable特有的
                dataSrc: function (result) {
                    if (result.status==200) {
                        result.draw = result.data.draw;
                        result.recordsTotal = result.data.recordsTotal;
                        result.recordsFiltered = result.data.recordsFiltered;
                        return result.data.data;
                    }else{
                        return "";
                    }

                }
            },
            "columns": [
                {"data":"id",
                    render:function (data,type,row,meta) {
                        return '<input type="checkbox" value="'+data+'" name="ids">';
                    }},
                { "data": "userName" },
                { "data": "realUserName" },
                { "data": "age" },
                { "data": "sex",
                   render:function (data,type,row,meta) {
                      return data==1?"男":"女";
               }},
               { "data": "email" },
               { "data": "phone" },
               { "data": "joinTime",
                    render:function (data,type,row,meta) {
                        return new Date(data).toLocaleDateString();
                    }},
               { "data": "salary" },
               { "data": "areaName" },
                {"data":"id",render:function(data,type,row,meta){
                        return ' <div class="btn-group" role="group" aria-label="...">'+
                            '<button type="button" class="btn btn-info '+btn_update+'" onclick="toUpdate('+data+')"><i class="glyphicon glyphicon-wrench"></i>修改</button>'+
                            '<button type="button" class="btn btn-danger '+btn_delete+'" onclick="deleteUser('+data+')"><i class="glyphicon glyphicon-remove"></i>删除</button>'+
                            '</div>';
                    }}

            ],
            "initComplete":function (setting,json) {
            },
            "drawCallback": function( settings ) {
            },
            "language": {
                "sProcessing":   "处理中...",
                "sLengthMenu":   "_MENU_ 记录/页",
                "sZeroRecords":  "没有匹配的记录",
                "sInfo":         "显示第 _START_ 至 _END_ 项记录，共 _TOTAL_ 项",
                "sInfoEmpty":    "显示第 0 至 0 项记录，共 0 项",
                "sInfoFiltered": "(由 _MAX_ 项记录过滤)",
                "sInfoPostFix":  "",
                "sSearch":       "过滤:",
                "sUrl":          "",
                "oPaginate": {
                    "sFirst":    "首页",
                    "sPrevious": "上页",
                    "sNext":     "下页",
                    "sLast":     "末页"
                }
            }
        });
    }
    function toAddJsp() {
        location.href="/register.jsp"
    }
    function toAdd(){
        bootbox.dialog({
            message: $("#showAddDiv").html(),
            title: "添加",
            size:"large",
            buttons: {
                Cancel: {
                    label: "取消",
                    className: "btn-default",
                    callback: function () {

                    }
                }
                , OK: {
                    label: "确认",
                    className: "btn-danger",
                    callback: function () {
                       var  password =  $("#add_password").val();
                        var confirm_password = $("#add_confirm_password").val();
                        if(password ==confirm_password){
                            var param={};
                            param.userName=$("#add_userName").val();
                            param.realUserName=$("#add_userRealName").val();
                            param.passWord=password;
                            param.age=$("#add_age").val();
                            param.sex=$("#add_sex").val();
                            param.email=$("#add_email").val();
                            param.phone=$("#add_phone").val();
                            param.salary=$("#add_salary").val();
                            param.joinTime=$("#add_joinTime").val();
                            param.sex = $("[name='add_sex']:checked").val();

                            param.area1=$("#add_area1").val()==-1?null:$("#add_area1").val();
                            param.area2=$("#add_area2").val()==-1?null:$("#add_area2").val();
                            param.area3=$("#add_area3").val()==-1?null:$("#add_area3").val();
                            var roleArr=[];
                              $("[name='addRole']:checked").each(function(){
                                  roleArr.push(this.value);
                              })
                            param.roleArr=roleArr;
                            $.post(
                                "<%=request.getContextPath()%>/user/addUser.do",
                                param,
                                function (data) {
                                    if(data.status==200){
                                        queryList();
                                    }else{
                                        bootbox.alert("操作失败！,请联系管理员",function(){

                                        })
                                    }

                                }
                            )
                        }else{
                            bootbox.alert("两次密码输入不一致！")
                        }

                    }
                }
            }
        });
        showArea(0,null,1);
        initAddDate();
        initAddRole();
    }
    function initAddRole() {
     $.post(
         "<%=request.getContextPath()%>/role/queryAllList.do",
         function(data){
          if(data.status==200){
              var list = data.data;
              var str="";
              for (var i = 0; i < list.length; i++) {
                  str +='<input type="checkbox" name="addRole" value='+list[i].id+'>'+list[i].name+'&nbsp;&nbsp;&nbsp;&nbsp;';
              }
              $("#showRole").html(str);
          }


     })
    }
    function initAddDate(){
        $('#add_joinTime').datetimepicker({
            format:"YYYY-MM-DD",
            showClear: true
        });
    }
    function  showArea(pid,obj,a) {
        //清除当前节点的父节点 之后的节点
        $(obj).parent().nextAll().remove();
        $.post(
            "<%=request.getContextPath()%>/area/queryListByPid.do",
            {"pid":pid},
            function(result){
                if(result.status==200 && result.data.length>0){
                    var data= result.data;
                    var str =" <div class=\"col-sm-2\" >\n" +
                        " <select class=\"form-control\" id=\"add_area"+(a++)+"\" onchange=\"showArea(this.value,this,"+a+")\">\n" +
                        "<option value=\"-1\">==请选择==</option>\n" ;
                    for (var i = 0; i < data.length; i++) {
                        str +=  '<option value="'+data[i].id+'">'+data[i].name+'</option>'
                    }
                    str +="</select></div>"
                    $("#areaDiv").append(str);
                }
            }
        )
    }
</script>
<body>
<jsp:include page="/common/nav.jsp"></jsp:include>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-primary" >
                <!-- Default panel contents -->
                <div class="panel-heading" style="text-align: left">
                    <button type="button" class="btn btn-success" onclick="toAdd()"><i class="glyphicon glyphicon-plus"></i>添加用户</button>
                    <button type="button" class="btn btn-danger" onclick="deleteBatch()"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
                </div>
                <div  class="panel-body">
                    <!-- Table -->
                    <table id="example" class="table table-striped table-bordered" style="width:100%">
                        <thead>
                        <tr >
                            <th><input type="checkbox" onclick="xuan()">选择</th>
                            <th>用户名</th>
                            <th>真实姓名</th>
                            <th>年龄</th>
                            <th>性别</th>
                            <th>邮箱</th>
                            <th>手机号</th>
                            <th>入职时间</th>
                            <th>薪水</th>
                            <th>地区</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tfoot>
                        <tr>
                            <th><input type="checkbox" onclick="xuan()">全选</th>
                            <th>用户名</th>
                            <th>真实姓名</th>
                            <th>年龄</th>
                            <th>性别</th>
                            <th>邮箱</th>
                            <th>手机号</th>
                            <th>入职时间</th>
                            <th>薪水</th>
                            <th>地区</th>
                            <th>操作</th>
                        </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
