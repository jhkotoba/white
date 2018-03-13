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
			
			//ajax일 경우 권한검사 통과
			if(request.getRequestURI().endsWith(".ajax")) {
				return true;
			}
			
			//nav 권한 검사
			String navUrl = "/"+(request.getRequestURI().replaceAll(path, "")).split("/")[1];
			String sideUrl = request.getParameter("sideUrl");
			WhiteMap auth = (WhiteMap)request.getSession(false).getAttribute("authority");
			
			//nav메뉴 권한 체크
			if(auth.getInt(StaticValue.getNavAuthList().getString(navUrl))==1) {
				
				//side메뉴 권한 체크
				if("/index".equals(sideUrl)){
					return true;
				}else if(auth.getInt(StaticValue.getSideAuthList().getString(sideUrl))==1) {					
					return true;
				}else {
					response.sendRedirect(path+"/main");
					return false;
				}				
			}else {
				response.sendRedirect(path+"/main");
				return false;
			}
		}		
	}
	
}
