package com.fh.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;


public class ExcelUtil {
	
	
	 /*//导出Excel
    public void downExcel(){
		//需要导出的List
		List<Animal> list  = animalService.queryAnimalList();	
		String [] headInfo={"动物名称","类型名称"};
		//需要导出的字段
		String [] attributeName={"animalname","type.typeName"};
		//调用工具类中的方法
		 BownloExcel.buildDocument(list, headInfo,attributeName);
		
	}*/
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void buildDocument(List list,String[] headInfo, String[] attributeName,HttpServletResponse response){
		//导出    创建一个excel文件
		XSSFWorkbook wb = new XSSFWorkbook();
		//创建一个sheet
		XSSFSheet sheet = wb.createSheet();
		//创建一行，下标以0开始
		XSSFRow row = sheet.createRow(0);
		//创建行上的单元格
		XSSFCell cell = null;
		for (int j = 0; j < headInfo.length; j++) {
			//创建行上的单元格
			cell = row.createCell(j);
			//给单元格赋值
			cell.setCellValue(headInfo[j]);
		}
		int i=1;
		for (Object obj : list) {
			Class infoClass = obj.getClass();
			row = sheet.createRow(i++);
			cell = null;
			int j=0;
			for (String attribute : attributeName) {				
				//list.get(0).getName()	
				if(attribute.indexOf(".")!=-1){
					cell = row.createCell(j++);
					String firstAttribute = attribute.substring(0, attribute.indexOf("."));
					String secondAttribute = attribute.substring(attribute.indexOf(".")+1);
					
					try {
						//type
						String firstMethodName = buildGetMethod(firstAttribute);
						Method method = infoClass.getDeclaredMethod(firstMethodName);
						Object firstObj = method.invoke(obj);
						//tname
						String secondMethondName = buildGetMethod(secondAttribute);
						Class firstClass = firstObj.getClass();
						Method secondMethod = firstClass.getDeclaredMethod(secondMethondName);
						Object value = secondMethod.invoke(firstObj);
						cell.setCellValue(getValue(value));
					} catch (Exception e) {
						e.printStackTrace();
					}
					
				}else{
					cell = row.createCell(j++);				 
					try {
						//获取该字段对应的get方法名
						String methodName = buildGetMethod(attribute);
						//获取method对象
						Method method = infoClass.getDeclaredMethod(methodName);
						Object result = method.invoke(obj);
						cell.setCellValue(getValue(result));
					} catch (Exception e) {
						e.printStackTrace();
					}				
				}				
			}			
		}
		outExcel(wb,response);
		
	}
	
	//拼接get方法
	public static String buildGetMethod(String attribute){			
		return "get"+attribute.substring(0,1).toUpperCase()+attribute.substring(1);
	}

	//判断添加的值是否是日期	
	public static String getValue(Object result){
		SimpleDateFormat sim = new SimpleDateFormat("yyyy-MM-dd ");
		if(null !=result){
			//判断result是否是日期类型
			if(result instanceof Date){
				return sim.format(result);
			}else{
				return String.valueOf(result);
			}
		}else{
			return "";
		}
	}
	
	//把文件输出
	public static void  outExcel(XSSFWorkbook wb,HttpServletResponse response){
		OutputStream out = null;
		try {
			//获取reponse
			response.setContentType("application/octet-stream");//设置响应类型  并通知浏览器 以流的形式展示
			//设置响应头部信息，携带文件名参数。下载的时候，显示的下载文件名。   
			//inline在浏览器中直接显示，不提示用户下载
			//attachment弹出对话框，提示用户进行下载保存本地
			response.setHeader("Content-disposition", "attachment;filename="+UUID.randomUUID().toString()+".xlsx");
			//字节输出流
			out = response.getOutputStream();		
			wb.write(out);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			try {
				if(null!=out){			
					out.close();
					out = null;
				}
				if(null!=wb){
					wb = null;
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
}
