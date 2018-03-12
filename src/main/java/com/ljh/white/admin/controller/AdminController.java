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
import com.ljh.white.common.service.WhiteService;


@Controller
public class AdminController {
	
	private static Logger logger = LogManager.getLogger(AdminController.class);
	
	@Resource(name = "AdminService")
	private AdminService adminService;
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;	
	
	@RequestMapping(value="/admin")
	public String adminMain(HttpServletRequest request){
		logger.debug("admin Start");
		
		WhiteMap param = new WhiteMap(request);
		List<WhiteMap> sideList = whiteService.selectSideMenuList(param);		
			
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");	
		
		switch(sideUrl){
		case "/lookup" :
			request.setAttribute("authList", adminService.selectAuthList());
			break;
		}	
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);
		request.setAttribute("sideList", sideList);
		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
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
	
	@RequestMapping(value="/admin/ajax/selectNavSideMenuList.do")
	public String selectNavSideMenuList(HttpServletRequest request) {		
		logger.debug("selectHaedSideMenuList Start");
		
		WhiteMap param = new WhiteMap(request);	
		
		JSONObject result = new JSONObject();		
		result.put("navList", new JSONArray(adminService.selectNavMenuList(param)));			
		result.put("sideList", new JSONArray(adminService.selectSideMenuList(param)));			
		result.put("authList", new JSONArray(adminService.selectAuthList()));			
		request.setAttribute("result", result);	
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/ajax/inUpDelNavMenuList.do" )
	public String inUpDelNavMenuList(HttpServletRequest request){
		logger.debug("inUpDelNavMenuList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = adminService.inUpDelNavMenuList(param);		
		
		request.setAttribute("result", new JSONObject(resultMap));
		
		whiteService.setNavAuth();
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/ajax/inUpDelSideMenuList.do" )
	public String inUpDelSideMenuList(HttpServletRequest request){
		logger.debug("inUpDelSideMenuList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = adminService.inUpDelSideMenuList(param);
		request.setAttribute("result", new JSONObject(resultMap));		
		return "result.jsp";
	}
	
	
}
