<%--
  Created by IntelliJ IDEA.
  User: gy
  Date: 2019/10/13
  Time: 14:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>Title</title>
<jsp:include page="/common/script.jsp"></jsp:include>
<script type="text/html" id="addRole">
        <form class="form-horizontal">
            <div class="form-group ">
                <label  class="col-sm-2 control-label">角色名称:</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control"  id="addRoleName" >
                </div>
            </div>
            <div class="form-group ">
                <label  class="col-sm-2 control-label">资源:</label>
                <div class="col-sm-4">
                    <ul id="treeDemo" class="ztree" ></ul>
                </div>
            </div>
        </form>

    </script>
<script type="text/html" id="updateRole">
        <form class="form-horizontal">
            <div class="form-group ">
                <label  class="col-sm-2 control-label">角色名称:</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control"  id="updateRoleName" >
                </div>
            </div>
            <div class="form-group ">
                <label  class="col-sm-2 control-label">资源:</label>
                <div class="col-sm-4">
                    <ul id="updateTreeDemo" class="ztree" ></ul>
                </div>
            </div>
            <input type="hidden" class="form-control"  id="updateRoleId" >
        </form>

    </script>
</head>

<script>
    $(function(){
        initDateTable();
    })

    function deleteRole(id){
        $.post(
            "<%=request.getContextPath()%>/role/deleteRole.do",
            {"id":id},
            function(data){
                if(data.status==200){
                    queryList();
                }else{
                    bootbox.alert("操作失败,请联系管理员！");
                }
            }
        )
    }
    function toUpdate(id,name){
        bootbox.dialog({
            title:"修改角色",
            message: $("#updateRole").html(),
            buttons: {
                confirm: {
                    label: '确认',
                    className: 'btn-success',
                    callback:function(){
                        update();
                    }
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            }

        });

        $("#updateRoleName").val(name);
        $("#updateRoleId").val(id);
        initUpdateZtree(id);
    }
    function update(){
        var roleName=$("#updateRoleName").val();
        var id=$("#updateRoleId").val();
        var nodes = zTreeObj.getCheckedNodes(true);
        var resourceIds=[];
        $(nodes).each(function(){
            resourceIds.push(this.id);
        })
        $.post(
            "<%=request.getContextPath()%>/role/updateRole.do",
            {"name":roleName,"resourceIds":resourceIds,"id":id},
            function(data){
                if(data.status==200){
                    queryList();
                }
            }
        )



    }
    function initDateTable(){
        myTable =    $('#example').DataTable({
            "serverSide": true,
            // 是否允许检索
            "searching": false,
            "lengthMenu": [5, 10, 20,50],
            "ajax": {
                url: '<%=request.getContextPath()%>/role/queryList.do',
                type: 'POST',
                "data": function(d){

                },
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

                },
                "error": function (xhr, error, thrown){
                    console.error(error);
                }
            },
            "columns": [
                { "data": "id" },
                { "data": "name" },

                {"data":"id",render:function(data,type,row,meta){
                        return ' <div class="btn-group" role="group" aria-label="...">'+
                            '<button type="button" class="btn btn-info" onclick="toUpdate('+data+',\''+row.name+'\')"><i class="glyphicon glyphicon-wrench"></i>修改</button>'+
                            '<button type="button" class="btn btn-danger" onclick="deleteRole('+data+')"><i class="glyphicon glyphicon-remove"></i>删除</button>'+
                            '</div>';
                    }}

            ],
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

    function queryList(){
        $("#example").dataTable().fnDraw(false);//点击事件触发table重新请求服务器
    }
    function showAddRole(){
        bootbox.dialog({
            title:"添加角色",
            message: $("#addRole").html(),
            buttons: {
                confirm: {
                    label: '确认',
                    className: 'btn-success',
                    callback:function(){
                        add();
                    }
                },
                cancel: {
                    label: '取消',
                    className: 'btn-danger'
                }
            }

        });
        initAddZtree();
    }
    function add(){
        var roleName=$("#addRoleName").val();
        var nodes = zTreeObj.getCheckedNodes(true);
        var resourceIds="";
        $(nodes).each(function(){
            resourceIds +=","+this.id;
        })
        $.post(
            "<%=request.getContextPath()%>/role/addRole.do",
            {"name":roleName,"resourceIds":resourceIds},
            function(data){
                if(data.status==200){
                    queryList();
                }
            }
        )



    }
    var zTreeObj;
    var setting = {
        check: {
            enable: true,
            chkStyle: "checkbox",
            chkboxType: { "Y": "ps", "N": "ps" }
        },
        data: {
            key: {
                url: "xUrl"
            },
            simpleData: {
                //enable:true   采用简单数据模式 (Array)
                enable: true,
                idKey: "id",
                pIdKey: "pid",
                rootPId: 0
            }
        }
    };
    function initAddZtree(){
        //pId:父节点的id
        $(document).ready(function(){
            //zTree 初始化方法
            //zTreeNodes  zTree 的节点数据，
            $.post(
                "<%=request.getContextPath()%>/resource/queryList.do",
                function(data){
                    zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, data.data);
                    zTreeObj.expandAll(true);
                }
            )
        });
    }
    function initUpdateZtree(id){
        //pId:父节点的id
        $(document).ready(function(){
            //zTree 初始化方法
            //zTreeNodes  zTree 的节点数据，
            $.post(
                "<%=request.getContextPath()%>/resource/queryListByRoleId.do",
                {"roleId":id},
                function(data){
                    zTreeObj = $.fn.zTree.init($("#updateTreeDemo"), setting, data.data);
                    zTreeObj.expandAll(true);
                }
            )
        });
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
                            <button type="button" class="btn btn-success" onclick="showAddRole()"><i class="glyphicon glyphicon-plus"></i>增加角色</button>
                            <button type="button" class="btn btn-danger" onclick="deleteBatch()"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
                        </div>
               <div  class="panel-body">
                <!-- Table -->
                   <table id="example" class="table table-striped table-bordered" style="width:100%">
                       <thead>
                       <tr >
                           <th>选择</th>
                           <th>角色</th>
                           <th>操作</th>
                       </tr>
                       </thead>

                       <tfoot>
                       <tr >
                           <th>选择</th>
                           <th>角色</th>
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
