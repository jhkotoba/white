package com.ljh.white.admin.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.admin.service.AdminService;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;


@RestController
public class AdminController {	
	
	@Resource(name = "AdminService")
	private AdminService adminService;
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;	
	
	@RequestMapping(value="/admin/selectUserList.ajax")
	public WhiteMap selectUserList(HttpServletRequest request) {
		
		WhiteMap param = new WhiteMap(request);
		
		int count = adminService.selectUserCount(param);
		List<WhiteMap> list = adminService.selectUserList(param);
		
		WhiteMap result = new WhiteMap();		
		result.put("count", count);
		result.put("userList", list);		
		
		return result;
	}
	
	@RequestMapping(value="/admin/selectUserAuth.ajax")
	public List<WhiteMap> selectUserAuth(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		return adminService.selectUserAuth(param);
	}
	
	@RequestMapping(value="/admin/inDelAuthList.ajax")
	public WhiteMap inDelAuthList(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		return adminService.inDelAuthList(param);
	}
	
	@RequestMapping(value="/admin/selectNavSideMenuList.ajax")
	public WhiteMap selectNavSideMenuList(HttpServletRequest request) {		
				
		WhiteMap param = new WhiteMap(request);	
		
		WhiteMap result = new WhiteMap();		
		result.put("navList", adminService.selectNavMenuList(param));			
		result.put("sideList", adminService.selectSideMenuList(param));			
		result.put("authList", adminService.selectAuthList(param));			
		
		return result;
	}
	
	@RequestMapping(value="/admin/inUpDelNavMenuList.ajax" )
	public WhiteMap inUpDelNavMenuList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);	
		
		whiteService.setNavAuth();
		return adminService.inUpDelNavMenuList(param);
	}
	
	@RequestMapping(value="/admin/inUpDelSideMenuList.ajax" )
	public WhiteMap inUpDelSideMenuList(HttpServletRequest request){
			
		WhiteMap param = new WhiteMap(request);	
		
		whiteService.setSideAuth();
		return adminService.inUpDelSideMenuList(param);
	}
	
	@RequestMapping(value="/admin/selectAuthList.ajax" )
	public List<WhiteMap> selectAuthList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);
		return adminService.selectAuthList(param);		
	}
	
	@RequestMapping(value="/admin/inUpDelAuthNmList.ajax" )
	public WhiteMap inUpDelauthList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);		
		return adminService.inUpDelAuthNmList(param);		
	}
	
}
