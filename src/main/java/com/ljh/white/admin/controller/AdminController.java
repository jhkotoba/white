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
	
	/**
	 * 유저 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectUserList.ajax")
	public WhiteMap selectUserList(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		
		WhiteMap result = new WhiteMap();
		result.put("itemsCount", adminService.selectUserCount(param));
		result.put("list", adminService.selectUserList(param));
		
		return result;
	}
	
	/**
	 * 유저 권한 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectUserAuth.ajax")
	public List<WhiteMap> selectUserAuth(HttpServletRequest request) {		
		WhiteMap param = new WhiteMap(request);
		return adminService.selectUserAuth(param);
	}
	
	/**
	 * 수정된 유저권한 적용
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/applyUserAuthList.ajax")
	public WhiteMap applyUserAuthList(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);		
		return adminService.applyUserAuthList(param);
	}	
	
	/**
	 * 네비메뉴 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectNavMenuList.ajax")
	public List<WhiteMap> selectNavMenuList(HttpServletRequest request) {
		return adminService.selectNavMenuList();	
	}	
	
	/**
	 * 사이드메뉴 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectSideMenuList.ajax")
	public List<WhiteMap> selectSideMenuList(HttpServletRequest request) {
		return adminService.selectSideMenuList();	
	}
	
	/**
	 * 메뉴리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectMenuList.ajax")
	public WhiteMap selectMenuList(HttpServletRequest request) {
		WhiteMap result = new WhiteMap();		
		result.put("navList", adminService.selectNavMenuList());			
		result.put("sideList", adminService.selectSideMenuList());			
		result.put("authList", adminService.selectAuthList());			
		
		return result;
	}	
	
	/**
	 * 구 메뉴리스트
	 * @param request
	 * @return
	 * @deprecated
	 */
	@RequestMapping(value="/admin/selectNavSideMenuList.ajax")
	public WhiteMap selectNavSideMenuList(HttpServletRequest request) {	
		WhiteMap result = new WhiteMap();		
		result.put("navList", adminService.selectNavMenuList());			
		result.put("sideList", adminService.selectSideMenuList());			
		result.put("authList", adminService.selectAuthList());			
		
		return result;
	}
	
	/**
	 * 구버전 
	 * @deprecated
	 * applyNavMenuList로 대체
	 */
	@RequestMapping(value="/admin/inUpDelNavMenuList.ajax" )
	public WhiteMap inUpDelNavMenuList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);	
		WhiteMap result = adminService.inUpDelNavMenuList(param);
		whiteService.setNavAuth();
		return result;
	}
	
	/**
	 * 네비 메뉴리스트 적용
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/applyNavMenuList.ajax" )
	public int applyNavMenuList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);	
		int result = adminService.applyNavMenuList(param);
		whiteService.setNavAuth();		
		return result;
	}
	
	/**
	 * 사이드 메뉴리스트 적용
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/applySideMenuList.ajax" )
	public int applySideMenuList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);	
		int result = adminService.applySideMenuList(param);
		whiteService.setNavAuth();		
		return result;
	}
	
	/**
	 * @deprecated
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/inUpDelSideMenuList.ajax" )
	public WhiteMap inUpDelSideMenuList(HttpServletRequest request){
			
		WhiteMap param = new WhiteMap(request);	
		WhiteMap result = adminService.inUpDelSideMenuList(param);
		whiteService.setSideAuth();
		return result;
	}
	
	/**
	 * 권한 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectAuthList.ajax" )
	public List<WhiteMap> selectAuthList(HttpServletRequest request){		
		return adminService.selectAuthList();		
	}
	
	/**
	 * 권한설정 반영
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/applyAuthList.ajax" )
	public int applyAuthList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);
		return adminService.applyAuthList(param);
	}
	
	
}
