package com.fh.controller;

import com.fh.common.Ignore;
import com.fh.common.LogMsg;
import com.fh.common.ServerResponse;
import com.fh.model.Category;
import com.fh.model.Product;
import com.fh.param.ProductSearchParam;
import com.fh.service.product.ProductService;
import com.fh.util.ExcelUtil;
import com.fh.util.FileUtil;
import com.fh.util.SystemConstant;
import com.itextpdf.text.pdf.BaseFont;
import freemarker.template.Configuration;
import freemarker.template.Template;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xhtmlrenderer.pdf.ITextRenderer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

/**
 * Created by gy on 2019/10/14.
 */
@Controller
@RequestMapping("product/")
public class ProductController {
    @Autowired
    private ProductService productService;
    @RequestMapping("index")
    public String index(){
        return "product/list";
    }
    @RequestMapping("/queryList")
    @ResponseBody
    public ServerResponse queryList(ProductSearchParam productSearchParam){
      Long totalCount = productService.queryTotalCount(productSearchParam);
      List<Product> list =   productService.queryList(productSearchParam);
      Map map = new HashMap();
      map.put("data",list);
      map.put("recordsTotal",totalCount);
      map.put("recordsFiltered",totalCount);
      map.put("draw",productSearchParam.getDraw());
      return ServerResponse.success(map);
    }
   @RequestMapping("/getBrandList")
   @ResponseBody
    public  ServerResponse getBrandList(){
       List list =  productService.getBrandList();
       return ServerResponse.success(list);
    }

    @RequestMapping("/queryMapList")
    @ResponseBody
    public ServerResponse queryMapList(ProductSearchParam productSearchParam){
        long totalCount = productService.queryCount(productSearchParam);
        List list  = productService.queryMapList(productSearchParam);
        Map map= new HashMap();
        map.put("draw",productSearchParam.getDraw());
        map.put("recordsTotal",totalCount);
        map.put("recordsFiltered",totalCount);
        map.put("data",list);
        return ServerResponse.success(map);
    }


    @RequestMapping("/addProduct")
    @ResponseBody
    @LogMsg("增加商品")
    public ServerResponse addProduct(Product product){
            productService.addProduct(product);
        return ServerResponse.success();
    }
    @RequestMapping("/deleteProduct")
    @ResponseBody
    public ServerResponse deleteProduct(Integer id){
            productService.deleteProduct(id);
        return ServerResponse.success();
    }
    @RequestMapping("addProductForm")
    public String addProductForm(Product product){
            productService.addProduct(product);
        return "forward:/bootstrap/list.jsp";
    }
    @RequestMapping("/toUpdate")
    public String toUpdate(Model model , Integer id){
        Product product = productService.getProductById(id);
        model.addAttribute("product",product);
        return "update";
    }
    @RequestMapping("/toUpdate2")
    @ResponseBody
    @Ignore
    public ServerResponse toUpdate2( Integer id){
        Product product = productService.getProductById(id);
        return ServerResponse.success(product);
    }
    @RequestMapping("/update")
    @ResponseBody
    @LogMsg("更新商品信息")
    public ServerResponse update(Product product){

            productService.updateProduct(product);

        return ServerResponse.success();
    }
    @RequestMapping("deleteBatch")
    @ResponseBody
    @LogMsg("批量删除商品")
    public ServerResponse deleteBatch(@RequestParam("idList[]") List idList ){
            productService.deleteBatch(idList);
        return ServerResponse.success();
    }
    @RequestMapping("downloadExcel")
    public void downloadExcel(ProductSearchParam productSearchParam, HttpServletResponse response){
        List<Product> list  = productService.queryListNoPage(productSearchParam);
        String[] headList={"商品名称","商品价格","商品品牌"};
        String[] attrbuteList={"name","price","brandName"};
        ExcelUtil.buildDocument(list,headList,attrbuteList,response);
    }

    @RequestMapping("downloadExcelTemplate")
    @ResponseBody
    public Map downloadExcelTemplate(ProductSearchParam productSearchParam) {
        List<Product> list  = productService.queryListNoPage(productSearchParam);
         Map map = new HashMap();
         map.put("productList",list);
            Configuration configuration = new Configuration();
            configuration.setDefaultEncoding("utf-8");
            //有两种方式获取你的模板，模板在项目中时用第一个，模板在本地时用第二个。
            //注意：两种方式的路径都只需要写到模板的上一级目录
            configuration.setClassForTemplateLoading(this.getClass(), SystemConstant.TEMPLATE_PATH);
          //  configuration.setDirectoryForTemplateLoading(new File("C:/"));

            File outFile = new File(SystemConstant.EXCEL_FILE_PATH+Math.random()*10000+".xls");//输出路径
            Template t=null;
            Writer out = null;
            try {
                t = configuration.getTemplate(SystemConstant.EXCEL_TIMPATE_FILE_PATH, "utf-8"); //文件名，获取模板
                out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile), "utf-8"));
                t.process(map, out);
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    out.close();
                } catch (IOException  e) {
                    e.printStackTrace();
                }
            }


      return new HashMap();
    }

    @RequestMapping("downloadWord")
    public void downloadWord(ProductSearchParam productSearchParam, HttpServletResponse response, HttpServletRequest request) {
        List<Product> list  = productService.queryListNoPage(productSearchParam);
        Map map = new HashMap();
        map.put("list",list);
        File file = FileUtil.buildWord(map, SystemConstant.WORD_TIMPATE_FILE_PATH);
        FileUtil.downloadFile(request,response,file);

    }
    @RequestMapping("downloadPdf")
    public void downloadPdf(ProductSearchParam productSearchParam, HttpServletResponse response)  {
        List<Product> list  = productService.queryListNoPage(productSearchParam);
        Map map = new HashMap();
        map.put("productList",list);
        String pdfHtml = FileUtil.buildPdfHtml(map, SystemConstant.PDF_TIMPATE_FILE_PATH);
        FileUtil.pdfDownloadFile(response,pdfHtml);
    }
    @RequestMapping("uploadExcel")
    public void uploadExcel(String filePath,HttpServletRequest request){
        productService.uploadExcel( filePath,request);
    }
    @RequestMapping("updateProductStatus")
    @ResponseBody
    public ServerResponse updateProductStatus(Integer id,Integer status){
        productService.updateProductStatus(id,status);
        return  ServerResponse.success();

    }

}
