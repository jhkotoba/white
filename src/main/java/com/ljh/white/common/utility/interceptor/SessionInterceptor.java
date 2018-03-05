package com.ljh.white.common.utility.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ljh.white.common.collection.WhiteMap;

public class SessionInterceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		String path = request.getContextPath();	
		
		//세션 검사
		if(request.getSession(false).getAttribute("userSeq") == null) {
			response.sendRedirect(path+"/login/login.do");
			return false;		
		}else{
			
			//권한 검사
			/*String uri = request.getRequestURI();			
			WhiteMap auth = (WhiteMap)request.getSession(false).getAttribute("authority");
			//System.out.println("size:"+auth.size());
			
			//관리자 페이지 권한 체크
			if(uri.startsWith(path+"/admin")) {
				if(auth.getInt("administrator")==1) {
					return true;
				}else {					
					response.sendRedirect(path+"/main");
					return false;
				}
			//가계부 페이지 권한 체크
			}else if(uri.startsWith(path+"/ledgerRe")) {
				if(auth.getInt("ledger")==1) {
					return true;
				}else {
					response.sendRedirect(path+"/main");
					return false;					
				}
			//데모 페이지 권한 체크
			}else if(uri.startsWith(path+"/experiment")) {
				if(auth.getInt("developer")==1) {
					return true;
				}else {
					response.sendRedirect(path+"/main");
					return false;					
				}
			}else {
				return true;
			}*/
			
			return true;
			
		}		
	}
	
}
