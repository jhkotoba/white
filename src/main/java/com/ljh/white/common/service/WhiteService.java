package com.ljh.white.common.service;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.StaticValue;
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
}
