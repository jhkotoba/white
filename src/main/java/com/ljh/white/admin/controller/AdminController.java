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
	
	//유저 리스트 조회
	@RequestMapping(value="/admin/selectUserList.ajax")
	public WhiteMap selectUserList(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		
		WhiteMap result = new WhiteMap();
		result.put("itemsCount", adminService.selectUserCount(param));
		result.put("list", adminService.selectUserList(param));
		
		return result;
	}
	
	//유저 권한 조회
	@RequestMapping(value="/admin/selectUserAuth.ajax")
	public List<WhiteMap> selectUserAuth(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		return adminService.selectUserAuth(param);
	}
	
	//수정된 유저권한 적용
	@RequestMapping(value="/admin/applyUserAuthList.ajax")
	public WhiteMap applyUserAuthList(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);		
		return adminService.applyUserAuthList(param);
	}
	
	
	//사용안함
	/*@RequestMapping(value="/admin/inDelAuthList.ajax")
	public WhiteMap inDelAuthList(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		return adminService.inDelAuthList(param);
	}*/
	
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
		WhiteMap result = adminService.inUpDelNavMenuList(param);
		whiteService.setNavAuth();
		return result;
	}
	
	@RequestMapping(value="/admin/inUpDelSideMenuList.ajax" )
	public WhiteMap inUpDelSideMenuList(HttpServletRequest request){
			
		WhiteMap param = new WhiteMap(request);	
		WhiteMap result = adminService.inUpDelSideMenuList(param);
		whiteService.setSideAuth();
		return result;
	}
	
	@RequestMapping(value="/admin/selectAuthList.ajax" )
	public List<WhiteMap> selectAuthList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);
		return adminService.selectAuthList(param);		
	}
	
	//대체 개발중..
	@RequestMapping(value="/admin/inUpDelAuthNmList.ajax" )
	public WhiteMap inUpDelauthList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);		
		return adminService.inUpDelAuthNmList(param);		
	}
	
	@RequestMapping(value="/admin/applyAuthList.ajax" )
	public WhiteMap applyAuthList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);		
		
		return null;
	}
	
	
}
