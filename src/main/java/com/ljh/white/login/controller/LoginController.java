package com.ljh.white.login.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;
import com.ljh.white.common.utility.cryptolect.BCrypt;
import com.ljh.white.login.service.LoginService;

@Controller
public class LoginController {
	
	private static Logger logger = LogManager.getLogger(LoginController.class);
	
	@Resource(name = "LoginService")
	private LoginService loginService;
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;

	//login
	@RequestMapping(value = "/login/login.do")
	public String login(){		
		return "login/login.jsp";
	}
	
	//loginProcess
	@RequestMapping(value = "/login/loginProcess.do")
	public String loginProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{		
		String userId = request.getParameter("userId");
		String passwd = request.getParameter("passwd");
		logger.debug("userId: "+userId + ", passwd:"+BCrypt.hashpw(passwd, BCrypt.gensalt()));				
		
		boolean userCheck = loginService.loginUserCheck(userId, passwd);
		logger.debug("userCheck:"+userCheck);
		
		if(userCheck){
			
			int userSeq = loginService.getUserSeq(userId);
			WhiteMap auth = loginService.selectUserAuthority(userSeq, userId);
			List<WhiteMap> navList = loginService.selectNavMenuList(userSeq);
			
			
			//세션 등록 
			HttpSession session = request.getSession();		
			session.setMaxInactiveInterval(60*960); //세션 유효시간			
			session.setAttribute("userId", userId);
			session.setAttribute("userSeq", userSeq);
			session.setAttribute("authority", auth);
			session.setAttribute("navList", navList);
			
			//page
			request.setAttribute("sidePage", null);
			request.setAttribute("sectionPage", "main/main.jsp");
			
			return "redirect:/main";
		}else{
			return "login/login.jsp";	
		}		
	}
	
	//logoutProcess
	@RequestMapping(value = "/login/logoutProcess.do")
	public String logoutProcess(HttpServletRequest request){
		//세션정보 삭제
		HttpSession session = request.getSession();
		session.removeAttribute("userId");
		session.removeAttribute("userSeq");
		session.removeAttribute("authority");
		logger.debug("session deleted");
		
		//모든 세션 정보삭제하고 현재 세션 무효화
		session.invalidate();
		
		return "redirect:/main";
	}
	
	//유저등록 페이지
	@RequestMapping(value="/login/signUp.do")
	public String signUp(HttpServletRequest request){
		return "login/signUp.jsp";
	}
	
	//유저 등록
	@RequestMapping(value="/login/insertSignUp.do")
	public String insertUser(HttpServletRequest request) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8");
		String userId = request.getParameter("userId");
		String userName = request.getParameter("userName");
		String passwd = request.getParameter("passwd");
		
		loginService.insertSignUp(userId, userName, passwd);	
		
		return "redirect:/login/login.do";
	}
	
	//유저 중복 id체크
	@RequestMapping(value="/login/ajax/userIdCheck.do")
	public String signUpTEST(HttpServletRequest request){		
		int isCnt = whiteService.isCntColumn("white_user", "user_id", request.getParameter("userId"));
		request.setAttribute("result", isCnt);
		return "result.jsp";		
	}
}
