package com.ljh.white.source.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.source.mapper.SourceMapper;

@Service("SourceService")
public class SourceService {
	
	@Resource(name = "SourceMapper")
	private SourceMapper sourceMapper;
	
	
	/**
	 * 소스게시판 리스트 카운트
	 * @param param
	 * @return
	 */
	public int selectSourceCount(WhiteMap param) {
		return sourceMapper.selectSourceCount(param);	
	}
	
	/**
	 * 소스게시판 리스트 조회
	 * @param Parma
	 * @return
	 */
	public List<WhiteMap> selectSourceList(WhiteMap param){
		param.put("pagePre", (param.getInt("pageIndex")-1)*param.getInt("pageSize"));
		return sourceMapper.selectSourceList(param);
	}
	
	/**
	 * 소스게시판 상세화면 조회
	 * @param param
	 * @return
	 */
	public WhiteMap selectSourceDtlView(WhiteMap param) {		
		WhiteMap map = sourceMapper.selectSourceDtlView(param);
		return this.codeColorAdjust(map);
		//return map;
		
	}
	
	/**
	 * 소스게시판 새글 저장
	 * @param param
	 * @return
	 */
	public int insertSource(WhiteMap param) {
		return sourceMapper.insertSource(param);
	}

	/**
	 * 소스코드 색상 적용
	 * @return
	 */
	private WhiteMap codeColorAdjust(WhiteMap map) {
		
		StringBuilder str = new StringBuilder();
		
		char[] ch = map.getString("content").toCharArray();		
		String state = "none";
		
		int annCnt = 0;	//개행문자 오기 전까지 주석 개수
		
		for(int i=0; i<ch.length; i++){			
			switch(state) {			
			case "//" :				
				if(ch[i] == '\r' || ch[i] == '\n') {					
					for(int j=0; j<annCnt; j++) {
						str.append("</span>");
					}					
					state = "none";
					annCnt = 0;
				}
				break;			
			}
			switch(ch[i]) {
			case '/':				
				if(ch.length-1 >= i+1 && ch[i+1]=='/') {
					str.append("<span style='color:#6BA980;'>");
					state = "//";
					annCnt++;		
				}				
				break;		
			}
			str.append(ch[i]);
		}	
		String result = str.toString();
		map.put("content", result);
		return map;
	}
}
