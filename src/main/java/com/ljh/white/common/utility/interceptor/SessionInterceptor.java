package com.ljh.white.common.utility.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ljh.white.common.StaticValue;
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
			
			//nav 권한 검사
			String url = "/"+(request.getRequestURI().replaceAll(path, "")).split("/")[1];			
			WhiteMap auth = (WhiteMap)request.getSession(false).getAttribute("authority");
			
			if(auth.getInt(StaticValue.getNavAuthList().getString(url))==1) {
				return true;
			}else {
				response.sendRedirect(path+"/main");
				return false;
			}
		}		
	}
	
}
