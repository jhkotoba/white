package com.ljh.white.admin.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.admin.service.AdminService;
import com.ljh.white.common.collection.WhiteMap;


@Controller
public class AdminController {
	
	private static Logger logger = LogManager.getLogger(AdminController.class);
	
	@Resource(name = "AdminService")
	private AdminService adminService;

	@RequestMapping(value="/admin/adminMain.do")
	public String adminMain(HttpServletRequest request){
		logger.debug("adminMain Start");
		
		WhiteMap param = new WhiteMap(request);
		
		String sectionPage = param.getString("move");		
		if("".equals(sectionPage) || sectionPage == null) sectionPage = "Main";
		
		switch(sectionPage){
		case "Lookup" :
			request.setAttribute("authList", adminService.selectAuthList());
			break;
		}
		
		request.setAttribute("sidePage", "admin/adminSide.jsp");
		request.setAttribute("sectionPage", "admin/admin"+sectionPage+".jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/admin/ajax/selectUserList.do")
	public String selectUserList(HttpServletRequest request) {
		
		WhiteMap param = new WhiteMap(request);
		
		int count = adminService.selectUserCount(param);
		List<WhiteMap> list = adminService.selectUserList(param);
		
		JSONObject result = new JSONObject();		
		result.put("count", count);
		result.put("userList", new JSONArray(list));
		request.setAttribute("result", result);
		
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/ajax/selectUserAuth.do")
	public String selectUserAuth(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);		
		request.setAttribute("result", new JSONArray(adminService.selectUserAuth(param)));		
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/ajax/inDelAuthList.do")
	public String inDelAuthList(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		WhiteMap resultMap = adminService.inDelAuthList(param);
		request.setAttribute("result", new JSONObject(resultMap));
		return "result.jsp";
	}
	
	
	
}
