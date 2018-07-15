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
	 * 코드 텍스트 색상 적용
	 * @param param
	 * @return
	 */
	private WhiteMap codeColorAdjust(WhiteMap param) {
		
		String result = null;
		String typeNm = param.getString("codeNm").toLowerCase();		
		
		switch(typeNm){
		case "javascript" :
			result = this.javascriptAdjust(param);		
		}
		
		
		if(result == null) {
			return param;
		}else {
			param.put("content", result);
			return param;
		}
		
		
	}
	
	/**
	 * javascript 소스코드 색상 적용
	 * @return
	 */
	private String javascriptAdjust(WhiteMap param) {
		
		StringBuilder str = new StringBuilder();
		StringBuilder temp = new StringBuilder();
		
		char[] ch = param.getString("content").toCharArray();		
		String state = "none";
		
		int annCnt = 0;	//개행문자 오기 전까지 주석 개수
		int ann2Idx = 0; // /*형식의 주석종료 위치
		int dQuotationIdx = 0; // 큰따옴표 종료 위치
		int quotationIdx = 0; //작은따옴표 종료 위치
		
		try {
			for(int i=0; i<ch.length; i++){
				
				//종료처리
				switch(state) {
				case "error":
					return null;
				case "/*":
					if(ann2Idx == i) {
						str.append("</span>");
						state = "none";
						ann2Idx = 0;
					}
					break;
				case "//":				
					if(ch[i] == '\r' || ch[i] == '\n') {					
						for(int j=0; j<annCnt; j++) {
							str.append("</span>");
						}					
						state = "none";
						annCnt = 0;
					}
					break;
				case "\"":
					if(dQuotationIdx == i) {
						str.append("</span>");
						state = "none";
						dQuotationIdx = 0;
					}else if(ch[i] == '\r' || ch[i] == '\n') {
						str.append("</span>");
						state = "none";
						dQuotationIdx = 0;
					}
					break;
				case "\'":
					if(quotationIdx == i) {
						str.append("</span>");
						state = "none";
						quotationIdx = 0;
					}else if(ch[i] == '\r' || ch[i] == '\n') {
						str.append("</span>");
						state = "none";
						quotationIdx = 0;
					}
					break;
				case "function":					
					if(ch.length-1 > i+1 && this.spCharCheck(ch[i]) && ch[i-1]=='n'){
						str.append("</span>");
						state = "none";
					}				
					break;
				case "true":
				case "else":
					if(ch.length-1 > i+1 && this.spCharCheck(ch[i]) && ch[i-1]=='e'){
						str.append("</span>");
						state = "none";
					}				
					break;
				case "if":					
					if(ch.length-1 > i+1 && this.spCharCheck(ch[i]) && ch[i-1]=='f'){
						str.append("</span>");
						state = "none";
					}				
					break;				
				}
				
				//시작처리
				if("none".equals(state)){
					switch(ch[i]) {
					//주석
					case '/':				
						if(ch.length-1 > i+1 && ch[i+1]=='*'){
							boolean annCheck = false;
							for(int j=i+2; j<ch.length; j++) {
								if(ch.length-1 >= j+1 && ch[j]=='*' && ch[j+1]=='/') {
									annCheck = true;
									ann2Idx = j+2;
									break;
								}
							}
							if(annCheck) {
								str.append("<span style='color:#6BA980; font-size:inherit;'>");
								state = "/*";
							}
						}else if(ch.length-1 >= i+1 && ch[i+1]=='/') {
							if("/*".equals(state)==false) {
								str.append("<span style='color:#6BA980; font-size:inherit;'>");
								state = "//";
								annCnt++;
							}								
						}				
						break;
					//큰따옴표
					case '\"':						
						if(ch.length-1 >= i+1 && ch[i]=='\"'){
							boolean dQuotation  = false;
							for(int j=i+1; j<ch.length; j++) {
								if(ch.length-1 >= j+1 && ch[j]=='\"') {
									dQuotation = true;
									dQuotationIdx = j+1;
									break;
								}
							}
							if(dQuotation) {
								str.append("<span style='color:#CE8153; font-size:inherit;'>");
								state = "\"";
							}
						}
					break;
					//작은따옴표
					case '\'':						
						if(ch.length-1 >= i+1 && ch[i]=='\''){
							boolean quotation  = false;
							for(int j=i+1; j<ch.length; j++) {
								if(ch.length-1 >= j+1 && ch[j]=='\'') {
									quotation = true;
									quotationIdx = j+1;
									break;
								}
							}
							if(quotation) {
								str.append("<span style='color:#CE8153; font-size:inherit;'>");
								state = "\'";
							}
						}
					break;
					//function
					case 'f':						
						if(ch.length-1 < i+8) {
							for(int j=i; j<ch.length; j++) {
								temp.append(ch[j]);
							}
							if("function".equals(temp.toString())) {								
								str.append("<span style='color:#569CF1; font-size:inherit;'>");
								state = "end";
							}
							temp.setLength(0);
						}else if(ch.length-1 >= i+8 && ch[i+1]=='u' && ch[i+2]=='n' && ch[i+3]=='c' && 
							ch[i+4]=='t' && ch[i+5]=='i' && ch[i+6]=='o' && ch[i+7]=='n' && this.spCharCheck(ch[i+8])) {					
							str.append("<span style='color:#569CF1; font-size:inherit;'>");
							state = "function";
						}
						break;
					//true
					case 't':						
						if(ch.length-1 < i+4) {
							for(int j=i; j<ch.length; j++) {
								temp.append(ch[j]);
							}
							if("true".equals(temp.toString())) {								
								str.append("<span style='color:#569CF1; font-size:inherit;'>");
								state = "end";
							}
							temp.setLength(0);
						}else if(ch.length-1 >= i+4 && ch[i+1]=='r' && ch[i+2]=='u' && ch[i+3]=='e' && this.spCharCheck(ch[i+4])) {					
							str.append("<span style='color:#569CF1; font-size:inherit;'>");
							state = "true";
						}
						break;
					//if
					case 'i':						
						if(ch.length-1 < i+2) {
							for(int j=i; j<ch.length; j++) {
								temp.append(ch[j]);
							}
							if("if".equals(temp.toString())) {								
								str.append("<span style='color:#569CF1; font-size:inherit;'>");
								state = "end";
							}
							temp.setLength(0);
						}else if(ch.length-1 >= i+2 && ch[i+1]=='f' && this.spCharCheck(ch[i+2])) {					
							str.append("<span style='color:#569CF1; font-size:inherit;'>");
							state = "if";
						}
						break;
					//else
					case 'e':						
						if(ch.length-1 < i+4) {
							for(int j=i; j<ch.length; j++) {
								temp.append(ch[j]);
							}
							if("else".equals(temp.toString())) {								
								str.append("<span style='color:#569CF1; font-size:inherit;'>");
								state = "end";
							}
							temp.setLength(0);							
						}else if(ch.length-1 >= i+4 && ch[i+1]=='l' && ch[i+2]=='s' && ch[i+3]=='e' && this.spCharCheck(ch[i+4])) {					
							str.append("<span style='color:#569CF1; font-size:inherit;'>");
							state = "else";
						}
						break;
					}
				}
				str.append(ch[i]);
			}	
		}catch(Exception e){			
			return null;
		}finally {
			if("end".equals(state)) {				
				str.append("</span>");
				state = "none";
			}
		}			
		String result = str.toString();		
		return result;
	}
	
	/**
	 * 색상적용할 문구 다음글자  특수문자 체크
	 * @param ch
	 * @return
	 */
	private boolean spCharCheck(char ch) {		
		switch(ch) {
		case ' ': case '\t': case '(':case ')': case '\n': case '@': case '#': case '%': case '^': case '&': case '*': case '{': case '}':
		case '-': case '+': case '=': case '/': case '`': case '~': case '<': case '>': case '?': case ',':	case '.':
			return true;		
		default:
			return false;
		}
		
	}
}
