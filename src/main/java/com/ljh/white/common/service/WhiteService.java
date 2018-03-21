package com.ljh.white.common.service;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.StaticValue;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.mapper.WhiteMapper;

@Service("WhiteService")
public class WhiteService{

	@Resource(name = "WhiteMapper")
	private WhiteMapper whiteMapper;
	
	/**
	 * 서버 시작시 하는 작업
	 */
	@PostConstruct
	public void postConstruct() {
		this.setNavAuth();
		this.setSideAuth();
	}
	
	/**
	 *  네비메뉴 권한 메모리 저장
	 */
	public void setNavAuth() {
		StaticValue.setNavAuth(whiteMapper.selectNavAuthList());
	}
	
	/**
	 *  사이드메뉴 권한 메모리 저장
	 */
	public void setSideAuth() {
		StaticValue.setSideAuth(whiteMapper.selectSideAuthList());
	}
	
	/**
	 * 해당 유저 사이드메뉴 권한별 조회	/// 세션으로 옮김
	 * @param param
	 * @return
	 * @deprecated
	 */
	public List<WhiteMap> selectSideMenuList(WhiteMap param) {		
		return whiteMapper.selectSideMenuList(param);		
	}
}
