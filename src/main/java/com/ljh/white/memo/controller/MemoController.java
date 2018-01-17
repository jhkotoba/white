package com.ljh.white.memo.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.memo.service.MemoService;

@Controller
public class MemoController {
	
	@Resource(name = "MemoService")
	private MemoService memoService;
			
	@RequestMapping(value="/ajax/memoSave.do" )
	public String memoSave(HttpServletRequest request){
		
		int userSeq = Integer.parseInt(request.getSession(false).getAttribute("userSeq").toString());
		String memoType = request.getParameter("memoType");
		String jsonStr = request.getParameter("jsonStr");		
		
		memoService.memoSave(userSeq, memoType, jsonStr);
		
		///System.out.println("startDate:"+startDate);
		
		
		return "result.jsp";		
	}
	
}
