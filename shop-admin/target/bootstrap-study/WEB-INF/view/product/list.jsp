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
<script type="text/html" id="showUpdateDiv">
    <div>
        <form class="form-horizontal" >
            <div class="form-group">
                <label  class="col-sm-2 control-label">商品名称</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_productName" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">商品价格</label>
                <div class="col-sm-4">
                    <input type="text" class="form-control" id="update_price" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">商品品牌</label>
                <div class="col-sm-4">
                    <select class="form-control"  id="update_brand">
                        <option value="-1">==请选择==</option>

                    </select>
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">生产日期</label>
                <div class="col-sm-4">
                    <input type="text" name="createDate" id="update_createDate" class="form-control "  >
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 100px">
                <label  class="col-sm-2 control-label">商品图片</label>
                <div class="col-sm-8" style="height:300px">
                    <input id="update_input" name="file" multiple type="file" data-show-caption="true">
                    <input type="hidden" name="filePath" id="update_filePath">
                </div>
            </div>

        </form>


    </div>


</script>
<script type="text/html" id="showAddDiv">
    <div  >
        <form class="form-horizontal" id="formApp" >
            <div class="form-group">
                <label  class="col-sm-2 control-label">商品名称</label>
                <div class="col-sm-4">
                    <input type="text" name="name" class="form-control" id="add_productName" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">商品价格</label>
                <div class="col-sm-4">
                    <input type="text" name="price" class="form-control" id="add_price" >
                </div>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">商品品牌</label>
                <div class="col-sm-4">
                    <select class="form-control"  id="add_brand">
                        <option value="-1">==请选择==</option>
                    </select>
                </div>
            </div>
            <div class="form-group" id="categoryDiv">
                <label  class="col-sm-2 control-label">商品分类</label>
            </div>
            <div class="form-group">
                <label  class="col-sm-2 control-label">生产日期</label>
                <div class="col-sm-4">
                    <input type="text" name="createDate" id="add_createDate" class="form-control "  >
                </div>
            </div>
            <div class="form-group">
                <label class="col-sm-2 control-label">状态</label>
                <div class="col-sm-4">
                    <div class="input-group">
                        <label class="radio-inline">
                            <input type="radio" name="status"  value="1"> 上架
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="status"  value="0"> 下架
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-group" style="margin-bottom: 100px">
                <label  class="col-sm-2 control-label">商品图片</label>
                <div class="col-sm-5" style="height:300px">
                    <input id="input-id" name="file" multiple type="file" data-show-caption="true">
                    <input type="hidden" name="filePath" id="add_filePath">
                </div>
            </div>


        </form>


    </div>


</script>
<script type="text/html" id="showUploadDiv">
    <div  >
            <div class="form-group" style="height: 50px">
                <label  class="col-sm-2 control-label">上传excel</label>
                <div class="col-sm-5" >
                    <input id="upload" name="file"  type="file" data-show-caption="true">
                    <input type="hidden"  id="upload_add_filePath">
                </div>
            </div>
    </div>


</script>
<script>
    $(function(){
        initDateTable();
        initBrandList();
        initDate();
        initBindEvent();

    })
    function  showCategory(pid,obj,a) {
        //清除当前节点的父节点 之后的节点
        $(obj).parent().nextAll().remove();
        $.post(
            "<%=request.getContextPath()%>/category/queryListByPid.do",
            {"pid":pid},
            function(result){
                if(result.status==200 && result.data.length>0){
                    var data= result.data;
                    var str =" <div class=\"col-sm-2\" >\n" +
                        " <select class=\"form-control\" id=\"add_category"+(a++)+"\" onchange=\"showCategory(this.value,this,"+a+")\">\n" +
                        "<option value=\"-1\">==请选择==</option>\n" ;
                    for (var i = 0; i < data.length; i++) {
                        str +=  '<option value="'+data[i].id+'">'+data[i].categoryName+'</option>'
                    }
                    str +="</select></div>"
                    $("#categoryDiv").append(str);
                }
            }
        )

    }
    function deleteProduct(id){
        window.event.stopPropagation()// 阻止冒泡
        bootbox.dialog({
            message: "确认删除",
            title: "提示信息",
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
                        $.post(
                            "<%=request.getContextPath()%>/product/deleteProduct.do",
                            {"id":id},
                            function(data){
                                if(data.status==200){
                                    queryList();
                                }else{
                                    bootbox.alert("系统异常，请联系管理员！", function () {

                                    })
                                }
                            }
                        )
                    }
                }
            }
        });
    }
    function  initUpdateBrandList() {
        //开启同步加载 防止修改页面  品牌回显是好时坏
        $.ajaxSettings.async = false;
        $.post(
            "<%=request.getContextPath()%>/category/getBrandList.do",
            function(result){
                if(result.status==200){
                    var data=result.data;
                    for (var i = 0; i < data.length; i++) {
                        $("#update_brand").append(
                            '<option value="'+data[i].id+'">'+data[i].name+'</option>'
                        )

                    }

                }
            }
        )
        $.ajaxSettings.async = true;
    }
    function initUpdateFileInput() {
       var filePath = $("#update_filePath").val();
        $("#update_input").fileinput({
            language: 'zh', //设置语言
            uploadUrl: "<%=request.getContextPath()%>/photoUpload.do", //上传的地址
            allowedFileExtensions: ['jpg', 'gif', 'png','exe'],//接收的文件后缀
            //uploadExtraData:{"id": 1, "fileName":'123.mp3'},
            uploadAsync: true, //默认异步上传
            showUpload: true, //是否显示上传按钮
            showRemove : true, //显示移除按钮
            showPreview : true, //是否显示预览
            showCaption: false,//是否显示标题
            browseClass: "btn btn-primary", //按钮样式
            //dropZoneEnabled: true,//是否显示拖拽区域
            //minImageWidth: 50, //图片的最小宽度
            //minImageHeight: 50,//图片的最小高度
            //maxImageWidth: 1000,//图片的最大宽度
            //maxImageHeight: 1000,//图片的最大高度
            //maxFileSize: 0,//单位为kb，如果为0表示不限制文件大小
            //minFileCount: 0,
            maxFileCount: 10, //表示允许同时上传的最大文件个数
            enctype: 'multipart/form-data',
            validateInitialCount:true,
            previewFileIcon: "<i class='glyphicon glyphicon-cloud'></i>",
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            layoutTemplates :{
                //actionDelete:'', //去除上传预览的缩略图中的删除图标
                //actionUpload:'',//去除上传预览缩略图中的上传图片；
                //actionZoom:''   //去除上传预览缩略图中的查看详情预览的缩略图标。
            },
            initialPreview: [
                "<img src='<%=request.getContextPath()%>/"+filePath+"' class='file-preview-image' alt='Desert' title='Desert'>",
            ],
        }).on("fileuploaded", function (event, data, previewId, index) {    //一个文件上传成功
            console.log('文件上传成功！');
            console.log(data);
            $("#update_filePath").val(data.response.filePath);

        })
    }
    function initUpdateDate(){
        $('#update_createDate').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN'
        });
    }
    function toUpdate(id){
       window.event.stopPropagation()// 阻止冒泡
        bootbox.dialog({
            message: $("#showUpdateDiv").html(),
            title: "修改",
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
                        var param={};
                        param.name=$("#update_productName").val();
                        param.price=$("#update_price").val();
                        param.brandId=$("#update_brand").val();
                        param.filePath=$("#update_filePath").val();
                        param.createDate=$("#update_createDate").val();
                        param.id=id;

                        $.post(
                            "<%=request.getContextPath()%>/product/update.do",
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
                    }
                }
            }
        });
        //获取所有的品牌
        initUpdateBrandList();
        $.post(
            "<%=request.getContextPath()%>/product/toUpdate2.do",
            {"id":id},
            function (result) {
                if(result.status==200){
                    var data=result.data;
                $("#update_productName").val(data.name);
                $("#update_price").val(data.price);
                $("#update_brand").val(data.brandId);
                $("#update_filePath").val(data.filePath);
                $("#update_createDate").val(new Date(data.createDate).toLocaleDateString());
                initUpdateFileInput();
                initUpdateDate();
                }
            }
        )


    }
    function updateProductStatus(id,status){
        window.event.stopPropagation()// 阻止冒泡
        $.post(
            "<%=request.getContextPath()%>/product/updateProductStatus.do",
            {"id":id,"status":status},
            function(data){
                if(data.status==200){
                    queryList();
                }else{
                    bootbox.alert("操作失败,请联系管理员!");
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
                url: '<%=request.getContextPath()%>/product/queryMapList.do',
                type: 'POST',
                "data": function(d){
                    //添加额外的参数传给服务器
                    d.productName = $("#productName").val();
                    d.brandId = $("#brand").val();
                    d.minPrice = $("#minPrice").val();
                    d.maxPrice = $("#maxPrice").val();
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
                {"data":"id",render:function (data,type,row,meta) {
                    return '<input type="checkbox" value="'+data+'" name="ids">';
                }},
                { "data": "name" },
                { "data": "price" },
                { "data": "brandName" },
                { "data": "createDate",
                    render:function (data,type,row,meta) {
                        return new Date(data).toLocaleDateString();
                    }},
                { "data": "category" },
                { "data": "status",
                    render:function (data,type,row,meta) {
                        return  data==1?"上架":"下架";
                    }},
                { "data": "filePath",
                    render:function (data,type,row,meta) {
                        return "<img src='"+imgUrl+data+"' width='50px' >";
                    }},
                {"data":"id",render:function(data,type,row,meta){
                   // console.log(row);
                    if(row.status==1){//上架
                        //显示下架的按钮
                        var buttonText="下架";
                        var buttonColor="btn btn-warning";
                        var buttonIcon="glyphicon glyphicon-arrow-down";
                        var updatestatus=0;
                    }else{//下架
                        var buttonText="上架";
                        var buttonColor="btn btn-success";
                        var buttonIcon="glyphicon glyphicon-arrow-up";
                        var updatestatus=1;
                    }
                 return ' <div class="btn-group" role="group" aria-label="...">'+
                           '<button type="button" class="btn btn-info" onclick="toUpdate('+data+')"><i class="glyphicon glyphicon-wrench"></i>修改</button>'+
                           '<button type="button" class="btn btn-danger" onclick="deleteProduct('+data+')"><i class="glyphicon glyphicon-remove"></i>删除</button>'+
                           '<button type="button" class="'+buttonColor+'" onclick="updateProductStatus('+data+','+updatestatus+')"><i class="'+buttonIcon+'"></i>'+buttonText+'</button>'+
                        '</div>';
                }}

            ],
            "initComplete":function (setting,json) {

            },
            "drawCallback": function( settings ) {
             console.log(idList);
             if(idList.length>0){
                 $("[name='ids']").each(function () {
                     if(idList.indexOf(this.value)!=-1){
                         this.checked=true;
                         $(this).parent().parent().css("background-color","#66afe9");
                     }
                 })
             }

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
    function exitId(id){
        if(idList.indexOf(id)==-1){
            return false;
        }else{
            return true;
        }
    }
    function  initBrandList() {
        $.post(
            "<%=request.getContextPath()%>/product/getBrandList.do",
            function(data){
                if(data.status==200){
                    var data=data.data;
                    for (var i = 0; i < data.length; i++) {
                       $("#brand").append(
                           '<option value="'+data[i].id+'">'+data[i].name+'</option>'
                       )

                    }

                }
            }
        )

    }
    function initDate(){
        $('#minDate').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN'

        });
        $('#maxDate').datetimepicker({
            format: 'YYYY-MM-DD',
            locale: 'zh-CN',
            showClear:true
        });


    }
    function queryList(){
        $("#example").dataTable().fnDraw(false);//点击事件触发table重新请求服务器
    }
    function showAddProduct(){
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
                        //获取当前表单验证状态
                        var flag =  $("#formApp").data("bootstrapValidator").isValid();
                       if(flag){
                           var param={};
                           param.name=$("#add_productName").val();
                           param.price=$("#add_price").val();
                           param.brandId=$("#add_brand").val();
                           param.createDate=$("#add_createDate").val();
                           param.filePath=$("#add_filePath").val();
                           param.status = $("[name='status']:checked").val();
                           param.category1=$("#add_category1").val()==-1?null:$("#add_category1").val();
                           param.category2=$("#add_category2").val()==-1?null:$("#add_category2").val();
                           param.category3=$("#add_category3").val()==-1?null:$("#add_category3").val();
                           $.post(
                               "<%=request.getContextPath()%>/product/addProduct.do",
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
                           bootbox.alert("请输入名称！")
                       }

                    }
                }
            }
        });
        //获取所有的品牌
        initAddBrandList();
        //初始化日期插件
        initAddDate();
        //初始化文件插件
        initAddFileInput();
        //初始化分类
        showCategory(0,null,1);
        //加载表单验证
        initFormValidator()

    }
    function initFormValidator(){
        $('#formApp').bootstrapValidator({
            // 默认的提示消息
            message: 'This value is not valid',
            // 表单框里右侧的icon
            submitButtons: 'btn-danger',
            feedbackIcons: {
                valid: 'glyphicon glyphicon-ok',
                invalid: 'glyphicon glyphicon-remove',
                validating: 'glyphicon glyphicon-refresh'
            },
            fields: {
                name: {
                    message: '商品名验证失败',
                    validators: {
                        notEmpty: {
                            message: '商品名不能为空'
                        }
                    }
                },
                price: {
                    validators: {
                        notEmpty: {
                            message: '价格不能为空'
                        }
                    }
                }
            }
        });
    }
    function initAddFileInput() {

        $("#input-id").fileinput({
            language: 'zh', //设置语言
            uploadUrl: "<%=request.getContextPath()%>/photoUploadByFtp.do", //上传的地址
            allowedFileExtensions: ['jpg', 'gif', 'png','exe'],//接收的文件后缀
            //uploadExtraData:{"id": 1, "fileName":'123.mp3'},
            uploadAsync: true, //默认异步上传
            showUpload: true, //是否显示上传按钮
            showRemove : true, //显示移除按钮
            showPreview : true, //是否显示预览
            showCaption: false,//是否显示标题
            browseClass: "btn btn-primary", //按钮样式
            //dropZoneEnabled: true,//是否显示拖拽区域
            //minImageWidth: 50, //图片的最小宽度
            //minImageHeight: 50,//图片的最小高度
            //maxImageWidth: 1000,//图片的最大宽度
            //maxImageHeight: 1000,//图片的最大高度
            //maxFileSize: 0,//单位为kb，如果为0表示不限制文件大小
            //minFileCount: 0,
            maxFileCount: 10, //表示允许同时上传的最大文件个数
            enctype: 'multipart/form-data',
            validateInitialCount:true,
            previewFileIcon: "<i class='glyphicon glyphicon-cloud'></i>",
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            layoutTemplates :{
                //actionDelete:'', //去除上传预览的缩略图中的删除图标
                //actionUpload:'',//去除上传预览缩略图中的上传图片；
                //actionZoom:''   //去除上传预览缩略图中的查看详情预览的缩略图标。
            }
        }).on("fileuploaded", function (event, data, previewId, index) {    //一个文件上传成功
            console.log('文件上传成功！');
            console.log(data);
            $("#add_filePath").val(data.response.filePath);

        })
    }
    function initAddBrandList() {
        $.post(
            "<%=request.getContextPath()%>/product/getBrandList.do",
            function (result) {
                if(result.status==200){
                    var data=result.data;
                    for (var i = 0; i < data.length; i++) {
                        $("#add_brand").append(
                            "<option value='"+data[i].id+"'>"+data[i].name+"</option>"
                        );

                    }
                }
            }
        )
    }
    function initAddDate(){
        $('#add_createDate').datetimepicker({
            format:"YYYY-MM-DD",
            showClear: true
        });
    }
    var idList=[];
    //为DataTables表格中每一行绑定单击事件
    function initBindEvent(){
        $('#example').on('click', 'tr',function() {
            var data = myTable.row(this).data(); //获取单击那一行的数据

            console.log(data);
            //获取复选框
            var checkBox = $(this).find("[name='ids']")[0];
            if(checkBox.checked){
                checkBox.checked = false;
                $(this).css("background-color","");
                idList.splice(idList.indexOf(checkBox.value),1);
            }else{
                checkBox.checked = true;
                $(this).css("background-color","#66afe9");
                idList.push(checkBox.value);
            }
          //  alert(checkBox.value)
           // $(this).css("background-color","pink");
           // alert( data );
        } );

    }
    function xuan(){
        window.event.stopPropagation()// 阻止冒泡
        $("[name='ids']").each(function(){
            if(!this.checked){
                $(this).parent().parent().css("background-color","#66afe9");
                idList.push(this.value)

            }else{
                $(this).parent().parent().css("background-color","");
                idList.splice(idList.indexOf(this.value),1)
            }
            this.checked=!this.checked;

        })
    }
    function deleteBatch() {
        if(idList.length>0){
            $.post(
                "<%=request.getContextPath()%>/product/deleteBatch.do",
                {"idList":idList},
                function (data) {
                    if(data.status==200){
                        queryList();
                    }else{
                        bootbox.confirm("操作失败,请联系管理员!",function () {
                            
                        })
                    }
                }
            )
        }else{
            bootbox.alert("请选择要删除的数据！",function(){

            })
        }
        

    }
   function downloadExcel(){
        var form = document.getElementById("searchForm");
        form.action="<%=request.getContextPath()%>/downloadExcel.do";
        form.method="post";
        form.submit();

   }
    function downloadWord(){
        var form = document.getElementById("searchForm");
        form.action="<%=request.getContextPath()%>/downloadWord.do";
        form.method="post";
        form.submit();

    }
    function downloadPdf(){
        var form = document.getElementById("searchForm");
        form.action="<%=request.getContextPath()%>/downloadPdf.do";
        form.method="post";
        form.submit();

    }
    //上传excel
    function uploadExcel(){
        bootbox.dialog({
            message: $("#showUploadDiv").html(),
            title: "上传文件",
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

                        var filePath =  $("#upload_add_filePath").val();
                        if(filePath){
                            $.post(
                                "<%=request.getContextPath()%>/uploadExcel.do",
                                {"filePath":filePath},
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
                            bootbox.alert("请输入选择文件！")
                        }

                    }
                }
            }
        });
        inituploadFileInput();
    }
    //初始化 excel文件上传
    function inituploadFileInput() {

        $("#upload").fileinput({
            language: 'zh', //设置语言
            uploadUrl: "<%=request.getContextPath()%>/photoUpload.do", //上传的地址
            //allowedFileExtensions: ['jpg', 'gif', 'png','exe'],//接收的文件后缀
            //uploadExtraData:{"id": 1, "fileName":'123.mp3'},
            uploadAsync: true, //默认异步上传
            showUpload: true, //是否显示上传按钮
            showRemove : true, //显示移除按钮
            showPreview : false, //是否显示预览
            showCaption: false,//是否显示标题
            browseClass: "btn btn-primary", //按钮样式
            //dropZoneEnabled: true,//是否显示拖拽区域
            //minImageWidth: 50, //图片的最小宽度
            //minImageHeight: 50,//图片的最小高度
            //maxImageWidth: 1000,//图片的最大宽度
            //maxImageHeight: 1000,//图片的最大高度
            //maxFileSize: 0,//单位为kb，如果为0表示不限制文件大小
            //minFileCount: 0,
            maxFileCount: 10, //表示允许同时上传的最大文件个数
            enctype: 'multipart/form-data',
            validateInitialCount:true,
            previewFileIcon: "<i class='glyphicon glyphicon-cloud'></i>",
            msgFilesTooMany: "选择上传的文件数量({n}) 超过允许的最大数值{m}！",
            layoutTemplates :{
                //actionDelete:'', //去除上传预览的缩略图中的删除图标
                //actionUpload:'',//去除上传预览缩略图中的上传图片；
                //actionZoom:''   //去除上传预览缩略图中的查看详情预览的缩略图标。
            }
        }).on("fileuploaded", function (event, data, previewId, index) {    //一个文件上传成功
            $("#upload_add_filePath").val(data.response.filePath);

        })
    }

</script>
<body>
<jsp:include page="/common/nav.jsp"></jsp:include>
<div class="container-fluid">
    <div class="row">

        <div class="col-md-12">
            <form class="form-horizontal" id="searchForm" >
                <div class="form-group">
                    <label for="productName" class="col-sm-2 control-label">商品名称</label>
                    <div class="col-sm-3">
                        <input type="email" class="form-control" id="productName" placeholder="商品名称" name="productName">
                    </div>
                    <label for="brand" class="col-sm-2 control-label">商品品牌</label>
                    <div class="col-sm-3">
                        <select class="form-control" id="brand" name="brandId">
                            <option value="-1">请选择</option>

                        </select>
                    </div>
                    <div class="col-md-2"></div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">价格</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <input type="text" id="minPrice" name="minPrice" class="form-control" placeholder="0.00" aria-describedby="basic-addon1">
                            <span class="input-group-addon" id="basic-addon1"><i class="glyphicon glyphicon-resize-horizontal"></i></span>
                            <input type="text"  id="maxPrice" name="maxPrice" class="form-control" placeholder="0.00" aria-describedby="basic-addon1">
                        </div>
                    </div>
                    <label  class="col-sm-2 control-label">创建日期</label>
                    <div class="col-sm-3">
                        <div class="input-group">
                            <input type="text" id="minDate" name="minDate" class="form-control" placeholder="" aria-describedby="basic-addon1">
                            <span class="input-group-addon" id="basic-addon2"><i class="glyphicon glyphicon-calendar"></i></span>
                            <input type="text" id="maxDate" name="maxDate" class="form-control" placeholder="" aria-describedby="basic-addon1">
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

                    <div class="panel-heading" style="text-align: left">
                        <button type="button" class="btn btn-success" onclick="showAddProduct()"><i class="glyphicon glyphicon-plus"></i>增加商品</button>
                        <button type="button" class="btn btn-danger" onclick="deleteBatch()"><i class="glyphicon glyphicon-trash"></i>批量删除</button>
                        <button type="button" class="btn btn-info" onclick="downloadExcel()"><i class="glyphicon glyphicon-download-alt"></i>导出excel</button>
                        <button type="button" class="btn btn-info" onclick="downloadWord()"><i class="glyphicon glyphicon-cloud-download"></i>导出word</button>
                        <button type="button" class="btn btn-info" onclick="downloadPdf()"><i class="glyphicon glyphicon-circle-arrow-down"></i>导出pdf</button>
                        <button type="button" class="btn btn-info" onclick="uploadExcel()"><i class="glyphicon glyphicon-upload"></i>导入EXCEL</button>
                    </div>

               <div  class="panel-body">
                <!-- Table -->
                   <table id="example" class="table table-striped table-bordered" style="width:100%">
                       <thead>
                       <tr >

                           <th><input type="checkbox" onclick="xuan()">选择</th>
                           <th>商品名称</th>
                           <th>商品价格</th>
                           <th>商品品牌</th>
                           <th>生产时间</th>
                           <th>商品分类</th>
                           <th>商品状态</th>
                           <th>商品图片</th>
                           <th>操作</th>

                       </tr>
                       </thead>

                       <tfoot>
                       <tr>
                           <th><input type="checkbox" onclick="xuan()">全选</th>
                           <th>商品名称</th>
                           <th>商品价格</th>
                           <th>商品品牌</th>
                           <th>生产时间</th>
                           <th>商品分类</th>
                           <th>商品状态</th>
                           <th>商品图片</th>
                           <th>操作</th>
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
