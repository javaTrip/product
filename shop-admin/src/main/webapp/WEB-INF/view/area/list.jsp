<%--
  Created by IntelliJ IDEA.
  User: gy
  Date: 2019/10/17
  Time: 22:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="/common/script.jsp"></jsp:include>
    <script type="text/javascript" src="<%=request.getContextPath()%>/js/ztree/js/jquery.ztree.core.min.js"></script>

    <link href="<%=request.getContextPath()%>/js/ztree/css/zTreeStyle/zTreeStyle.css" rel="stylesheet" type="text/css">
    <script type="text/html" id="addCategory">
        <form class="form-horizontal">
            <div class="form-group ">
                <label for="addFatherName" class="col-sm-2 control-label">父节点:</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control"  id="addFatherName" readonly="readonly">
                </div>
            </div>
            <div class="form-group ">
                <label for="addFatherName" class="col-sm-2 control-label">新增节点:</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control"  id="addName" >
                </div>
            </div>
            <%--父节点：<input type="text" class="form-control" id="addFatherName" readonly="readonly"><br>--%>
            <%--  新增节点：<input type="text" id="addName" ><br>--%>
            <input type="hidden" id="addFatherId" >

        </form>

    </script>
    <script type="text/html" id="updateCategory">
        <form class="form-horizontal">
            <div class="form-group">
                <label  class="col-sm-2 control-label">父节点</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="updateFatherName" readonly="readonly">
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">当前节点</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="updateName" >
                </div>
            </div>
            <input type="hidden" id="updateId"  >
            <input type="hidden" id="updateFatherId" >
        </form>

    </script>
</head>
<script type="text/javascript">
    var zTreeObj;
    var setting = {
        callback: {
            onClick: zTreeOnClick
        },
        data: {
            simpleData: {
                //enable:true   采用简单数据模式 (Array)
                enable: true,
                idKey: "id",
                pIdKey: "pid",
                rootPId: 0
            }
        }
    };
    //pId:父节点的id
    $(document).ready(function(){
        //zTree 初始化方法
        //zTreeNodes  zTree 的节点数据，
        $.post(
            "<%=request.getContextPath()%>/area/queryList.do",
            function(data){
                if(data.status==200){
                    zTreeObj = $.fn.zTree.init($("#treeDemo"), setting, data.data);
                    zTreeObj.expandAll(true);
                }

            }
        )
    });
    function zTreeOnClick(event, treeId, treeNode){
        $("#caozuo").css("display","");
    }
    function toUpdate(){
        bootbox.dialog({
            title:"修改分类",
            message: $("#updateCategory").html(),
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
        //获取被选中的节点集合
        var nodes = zTreeObj.getSelectedNodes();
        //获取当前被选中的name值 放在input框
        $("#updateName").val(nodes[0].name);
        //获取当前节点的id 放在隐藏域中  方便修改
        $("#updateId").val(nodes[0].id);
        //获取当前节点的父节点
        var parentNode = nodes[0].getParentNode();
        //给父节点赋值
        $("#updateFatherName").val(parentNode.name);
        $("#updateFatherId").val(parentNode.id);
    }
    function toAdd(){
        bootbox.dialog({
            title:"添加地区",
            message: $("#addCategory").html(),
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
        //获取被选中的节点集合
        var nodes = zTreeObj.getSelectedNodes();
        //当前节点 即 新增节点的父节点
        $("#addFatherName").val(nodes[0].name);
        $("#addFatherId").val(nodes[0].id);
    }
    function deleteNode(){
        bootbox.confirm({
            title:"提示信息",
            message:"您确认要删除吗?",
            buttons: {
                confirm: {
                    label: '<span class="glyphicon glyphicon-ok"></span>确定',
                    className: 'btn-success'
                },
                cancel: {
                    label: '<span class="glyphicon glyphicon-remove"></span>取消',
                    className: 'btn-danger'
                }
            },
            callback:function (result) {
                 if(result){
                     //获取被选中的节点集合
                     var nodes = zTreeObj.getSelectedNodes();
                     //将 zTree 使用的标准 JSON 嵌套格式的数据转换为简单 Array 格式。
                     //(免去用户自行编写递归遍历全部节点的麻烦)
                     var nodesArr = zTreeObj.transformToArray(nodes[0]);
                     //拼接要删除的id
                     var ids = [];
                     for (var i = 0; i < nodesArr.length; i++) {
                         //alert(nodesArr[i].id)
                         ids.push(nodesArr[i].id);
                     }
                     if(ids.length>0){
                         $.post(
                             "<%=request.getContextPath()%>/area/deleteArea.do",
                             {"idList":ids},
                             function(data){
                                 if(data.status==200){
                                     zTreeObj.removeNode(nodes[0]);
                                 }else{
                                     bootbox.alert("操作错误,请联系管理员！");
                                 }

                             }
                         )
                     }
                 }
            }
        })
    }
    function add(){
        var pid= $("#addFatherId").val();
        var name= $("#addName").val();
        $.post(
            "<%=request.getContextPath()%>/area/addArea.do",
            {"name":name,"pid":pid},
            function(data){
                if(data.status==200){
                    //获取被选中的节点集合
                    var nodes = zTreeObj.getSelectedNodes();
                    var newNodes = {"name":name,"pid":pid,"id":data.id};
                    zTreeObj.addNodes(nodes[0], newNodes);
                   // $("#addFatherId").val();
                   // $("#addName").val("");
                }else{
                    bootbox.alert("操作错误,请联系管理员！");
                }


            }
        )


    }
    function update(){
        //获取修改之后的名字
        var newName = $("#updateName").val();
        var id = $("#updateId").val();
        var pid = $("#updateFatherId").val();
        //先更新数据库  在更新页面节点
        $.post(
            "<%=request.getContextPath()%>/area/updateArea.do",
            {"id":id,"name":newName,"pid":pid},
            function(data){
                if(data.status==200){
                    //获取被选中的节点集合
                    var nodes = zTreeObj.getSelectedNodes();
                    //给节点的属性重新赋值
                    nodes[0].name=newName;
                    //更新节点
                    zTreeObj.updateNode(nodes[0]);
                }else {
                    bootbox.alert("操作错误,请联系管理员！");
                }

            }


        )
    }
</script>
<body>
<jsp:include page="/common/nav.jsp"></jsp:include>
<ul id="treeDemo" class="ztree" ></ul>
<div id="caozuo" style="display:none">
    <input value="修改" type="button" class="btn btn-primary" onclick="toUpdate()" >
    <input value="增加" type="button" class="btn btn-warning" onclick="toAdd()">
    <input value="删除" type="button" class="btn btn-danger"  onclick="deleteNode()">
</div>
</body>
</html>
