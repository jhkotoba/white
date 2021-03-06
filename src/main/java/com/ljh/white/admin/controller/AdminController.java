package com.ljh.white.admin.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.admin.service.AdminService;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.white.service.WhiteService;

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
	 * 상위메뉴 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectUpperMenuList.ajax")
	public List<WhiteMap> selectUpperMenuList(HttpServletRequest request) {
		return adminService.selectUpperMenuList();	
	}	
	
	/**
	 * 하위메뉴 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectLowerMenuList.ajax")
	public List<WhiteMap> selectLowerMenuList(HttpServletRequest request) {
		WhiteMap param = new WhiteMap(request);
		return adminService.selectLowerMenuList(param);	
	}
	
	/**
	 * 메뉴리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectMenuList.ajax")
	public WhiteMap selectMenuList(HttpServletRequest request) {
		WhiteMap result = new WhiteMap();		
		result.put("upperList", adminService.selectUpperMenuList());			
		result.put("lowerList", adminService.selectLowerMenuList());			
		result.put("authList", adminService.selectAuthList());			
		
		return result;
	}	
	
	/**
	 * 구 메뉴리스트
	 * @param request
	 * @return
	 * @deprecated
	 */
	/*@RequestMapping(value="/admin/selectNavSideMenuList.ajax")
	public WhiteMap selectNavSideMenuList(HttpServletRequest request) {	
		WhiteMap result = new WhiteMap();		
		result.put("navList", adminService.selectNavMenuList());			
		result.put("sideList", adminService.selectSideMenuList());			
		result.put("authList", adminService.selectAuthList());			
		
		return result;
	}*/
	
	/**
	 * 상위 메뉴리스트 적용
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/applyUpperMenuList.ajax" )
	public int applyUpperMenuList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);	
		int result = adminService.applyUpperMenuList(param);
		whiteService.setUpperAuth();	
		return result;
	}
	
	/**
	 * 하위 메뉴리스트 적용
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/applyLowerMenuList.ajax" )
	public int applyLowerMenuList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);	
		int result = adminService.applyLowerMenuList(param);
		whiteService.setLowerAuth();		
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
	
	/**
	 * 코드 정의 리스트 조회
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/admin/selectCodeDefineList.ajax" )
	public WhiteMap selectCodeDefineList(HttpServletRequest request){
		WhiteMap param = new WhiteMap(request);
		WhiteMap result = new WhiteMap();
		result.put("count", adminService.selectCodeDefineCount(param));
		result.put("list", adminService.selectCodeDefineList(param));
		return result;
	}
	
	
	
}
