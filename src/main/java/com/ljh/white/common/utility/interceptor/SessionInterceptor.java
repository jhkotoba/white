package com.ljh.white.common.utility.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class SessionInterceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		Object userId = request.getSession(false).getAttribute("userId");	
		Object userSeq = request.getSession(false).getAttribute("userSeq");	
		
		if(userSeq == null || userId == null){			
			response.sendRedirect("/white/loginPage.do");
			return false;
		}else{			
			return true;
		}		
	}
	
}
