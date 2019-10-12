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
		this.setUpperAuth();
		this.setLowerAuth();
	}
	
	/**
	 *  네비메뉴 권한 메모리 저장
	 */
	public void setUpperAuth() {
		Auth.setUpperAuth(whiteMapper.selectUpperAuthList());
	}
	
	/**
	 *  사이드메뉴 권한 메모리 저장
	 */
	public void setLowerAuth() {
		Auth.setLowerAuth(whiteMapper.selectLowerAuthList());
	}
	
	/**
	 * 코드리스트 SELECT
	 * @param param
	 * @return
	 */
	public WhiteMap selectCodeList(WhiteMap param){
		WhiteMap map = null;
		String dataType = param.getString("dataType");
		switch(dataType) {			
		case "array"  :			
			map = new WhiteMap();
			WhiteMap srhMap = new WhiteMap();
			
			List<String> list = param.convertListString("codePrt");
			for(int i=0; i<list.size(); i++) {
				srhMap.put("codePrt", list.get(i));
				map.put(list.get(i), whiteMapper.selectCodeList(srhMap));
			}
			return map;		
		case "string" : default:
			map = new WhiteMap();
			map.put("codePrt", whiteMapper.selectCodeList(param));
			return map;	
		}
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
