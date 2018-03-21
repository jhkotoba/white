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
			
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");	

		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/admin/selectUserList.ajax")
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
	
	@RequestMapping(value="/admin/selectUserAuth.ajax")
	public String selectUserAuth(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);		
		request.setAttribute("result", new JSONArray(adminService.selectUserAuth(param)));		
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/inDelAuthList.ajax")
	public String inDelAuthList(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		WhiteMap resultMap = adminService.inDelAuthList(param);
		request.setAttribute("result", new JSONObject(resultMap));
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/selectNavSideMenuList.ajax")
	public String selectNavSideMenuList(HttpServletRequest request) {		
		logger.debug("selectHaedSideMenuList Start");
		
		WhiteMap param = new WhiteMap(request);	
		
		JSONObject result = new JSONObject();		
		result.put("navList", new JSONArray(adminService.selectNavMenuList(param)));			
		result.put("sideList", new JSONArray(adminService.selectSideMenuList(param)));			
		result.put("authList", new JSONArray(adminService.selectAuthList(param)));			
		request.setAttribute("result", result);	
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/inUpDelNavMenuList.ajax" )
	public String inUpDelNavMenuList(HttpServletRequest request){
		logger.debug("inUpDelNavMenuList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = adminService.inUpDelNavMenuList(param);		
		
		request.setAttribute("result", new JSONObject(resultMap));
		
		whiteService.setNavAuth();
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/inUpDelSideMenuList.ajax" )
	public String inUpDelSideMenuList(HttpServletRequest request){
		logger.debug("inUpDelSideMenuList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = adminService.inUpDelSideMenuList(param);
		request.setAttribute("result", new JSONObject(resultMap));
		
		whiteService.setSideAuth();
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/selectAuthList.ajax" )
	public String selectAuthList(HttpServletRequest request){
		logger.debug("selectAuthList Start");
		
		WhiteMap param = new WhiteMap(request);
		request.setAttribute("result", new JSONArray(adminService.selectAuthList(param)));
		return "result.jsp";
	}
	
	@RequestMapping(value="/admin/inUpDelAuthNmList.ajax" )
	public String inUpDelauthList(HttpServletRequest request){
		logger.debug("inUpDelAuthNmList Start");
		
		WhiteMap param = new WhiteMap(request);		
		WhiteMap resultMap = adminService.inUpDelAuthNmList(param);
		request.setAttribute("result", new JSONObject(resultMap));
		
		return "result.jsp";
	}
	
}
