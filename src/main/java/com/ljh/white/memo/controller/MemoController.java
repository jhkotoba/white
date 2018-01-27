package com.ljh.white.memo.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.memo.service.MemoService;

@Controller
public class MemoController {
	
	@Resource(name = "MemoService")
	private MemoService memoService;
			
	
	@RequestMapping(value="/ajax/selectMemoList.do" )
	public String selectMemoList(HttpServletRequest request){
		
		int userSeq = Integer.parseInt(request.getSession(false).getAttribute("userSeq").toString());
		String memoType = request.getParameter("memoType");		
		
		request.setAttribute("memoList", memoService.selectMemoList(userSeq, memoType));
		return "result.jsp";
	}
	
	@RequestMapping(value="/ajax/memoSave.do" )
	public String memoSave(HttpServletRequest request){
		
		int userSeq = Integer.parseInt(request.getSession(false).getAttribute("userSeq").toString());
		String memoType = request.getParameter("memoType");
		String jsonStr = request.getParameter("jsonStr");		
		
		JSONArray memoJsonList = memoService.memoSave(userSeq, memoType, jsonStr);
		
		request.setAttribute("result", memoJsonList);		
		return "result.jsp";
	}
	
}
