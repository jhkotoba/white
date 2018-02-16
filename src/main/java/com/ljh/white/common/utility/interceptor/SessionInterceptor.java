package com.ljh.white.common.utility.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ljh.white.common.bean.AuthBean;

public class SessionInterceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Object userId = request.getSession(false).getAttribute("userId");	
		Object userSeq = request.getSession(false).getAttribute("userSeq");	
		String path = request.getContextPath();		
		
		//세션 검사
		if(userSeq == null || userId == null){			
			response.sendRedirect(path+"/login/login.do");
			return false;
		}else{				
			
			//권한 검사
			String uri = request.getRequestURI();			
			AuthBean authBean = (AuthBean)request.getSession(false).getAttribute("authority");
			
			//관리자 페이지 권한 체크
			if(uri.startsWith(path+"/admin")) {
				if(authBean.getAdministrator()==1) {
					return true;
				}else {					
					response.sendRedirect(path+"/main.do");
					return false;
				}
			//가계부 페이지 권한 체크
			}else if(uri.startsWith(path+"/ledgerRe")) {
				if(authBean.getLedger()==1) {
					return true;
				}else {
					response.sendRedirect(path+"/main.do");
					return false;					
				}
			//개발자 페이지 권한 체크
			}else if(uri.startsWith(path+"/experiment")) {
				if(authBean.getDeveloper()==1) {
					return true;
				}else {
					response.sendRedirect(path+"/main.do");
					return false;					
				}
			}else {
				return true;
			}
			
			
			
		}		
	}
	
}
