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

</head>

<script>
    $(function(){
        initDateTable();
        initDate();

    })
    function initDateTable(){
        myTable =    $('#example').DataTable({
            "serverSide": true,
            // 是否允许检索
            "searching": false,
            "lengthMenu": [5, 10, 20,50],
            "ajax": {
                url: '<%=request.getContextPath()%>/log/queryList.do',
                type: 'POST',
                "data": function(d){
                    //添加额外的参数传给服务器
                    d.userName = $("#userName").val();
                    d.status = $("[name='status']:checked").val();
                    d.action = $("#action").val();

                    d.minDate = $("#minDate").val();
                    d.maxDate = $("#maxDate").val();
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
                { "data": "userName" },
                { "data": "action" },
                { "data": "status",render:function(data,type,row,meta){
                    return data==1?'成功':'失败';
                    } },
                { "data": "createDate",
                    render:function (data,type,row,meta) {
                        return new Date(data).toLocaleString();
                    }},
                { "data": "paramContent" }

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
    function initDate(){
        $('#minDate').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'zh-CN',
            showClear:true

        });
        $('#maxDate').datetimepicker({
            format: 'YYYY-MM-DD HH:mm:ss',
            locale: 'zh-CN',
            showClear:true
        });


    }
    function queryList(){
        $("#example").dataTable().fnDraw(false);//点击事件触发table重新请求服务器
    }
</script>
<body>
<jsp:include page="/common/nav.jsp"></jsp:include>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12">
            <form class="form-horizontal" id="searchForm" >
                <div class="form-group">
                    <label  class="col-sm-2 control-label">操作人</label>
                    <div class="col-sm-3">
                        <input type="email" class="form-control" id="userName" placeholder="操作人" >
                    </div>
                    <label  class="col-sm-2 control-label">操作</label>
                    <div class="col-sm-3">
                        <input type="email" class="form-control" id="action" placeholder="操作" >
                    </div>
                    <div class="col-md-2"></div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">状态</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <label class="radio-inline">
                                <input type="radio" name="status"  value="1"> 成功
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="status"  value="0"> 失败
                            </label>
                        </div>
                    </div>
                    <label  class="col-sm-2 control-label">创建日期</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <input type="text" id="minDate"  class="form-control" placeholder="" aria-describedby="basic-addon1">
                            <span class="input-group-addon" id="basic-addon2"><i class="glyphicon glyphicon-calendar"></i></span>
                            <input type="text" id="maxDate"  class="form-control" placeholder="" aria-describedby="basic-addon1">
                        </div>
                    </div>
                    <div class="col-md-2"></div>
                </div>


                    <div style="text-align: center">
                        <button type="button" onclick="queryList()" class="btn btn-primary "><i class="glyphicon glyphicon-search"></i>Submit</button>&nbsp;&nbsp;&nbsp;
                        <button type="reset" class="btn btn-default"><i class="glyphicon glyphicon-repeat"></i>Reset</button>
                    </div>

            </form>


            <div class="panel panel-primary" >
                <!-- Default panel contents -->

                    <div class="panel-heading" style="text-align: left">日志管理
                    </div>

               <div  class="panel-body">
                <!-- Table -->
                   <table id="example" class="table table-striped table-bordered" style="width:100%">
                       <thead>
                       <tr >
                           <th>操作人</th>
                           <th>操作</th>
                           <th>操作状态</th>
                           <th>操作时间</th>
                           <th>详情</th>
                       </tr>
                       </thead>

                       <tfoot>
                       <tr >
                           <th>操作人</th>
                           <th>操作</th>
                           <th>操作状态</th>
                           <th>操作时间</th>
                           <th>详情</th>
                       </tr>
                       </tfoot>
                   </table>
               </div>
            </div>
        </div>

    </div>


</div>
<%--修改--%>

</body>
</html>
