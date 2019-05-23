package com.ljh.white.common.service;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.Auth;
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
		Auth.setNavAuth(whiteMapper.selectNavAuthList());
	}
	
	/**
	 *  사이드메뉴 권한 메모리 저장
	 */
	public void setSideAuth() {
		Auth.setSideAuth(whiteMapper.selectSideAuthList());
	}
	
	/**
	 * 코드리스트 SELECT
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectCodeList(WhiteMap param){
		return whiteMapper.selectCodeList(param);
	}
	
	/**
	 * 테이블 정렬순서 정렬(오름차순)
	 * @param tableNm
	 * @param seqNm
	 * @param columnNm
	 */
	public void updateSortTable(WhiteMap param) {		
		List<WhiteMap> list = whiteMapper.selectSortTable(param);
		if(list.size() > 0) {
			for(int i=0; i<list.size(); i++) {
				list.get(i).put("col", i+1);
			}
			param.put("list", list);
			whiteMapper.updateSortTable(param);
		}
	}
}
