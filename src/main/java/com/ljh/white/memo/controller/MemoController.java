package com.ljh.white.memo.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.memo.service.MemoService;

@Controller
public class MemoController {
	
	@Resource(name = "MemoService")
	private MemoService memoService;
			
	
	@RequestMapping(value="/memo/selectMemoList.ajax" )
	public String selectMemoList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);
		
		request.setAttribute("result", new JSONArray(memoService.selectMemoList(param)));
		return "result.jsp";
	}
	
	@RequestMapping(value="/memo/memoSave.ajax" )
	public String memoSave(HttpServletRequest request){
		
		int userSeq = Integer.parseInt(request.getSession(false).getAttribute("userSeq").toString());
		String memoType = request.getParameter("memoType");
		String jsonStr = request.getParameter("jsonStr");		
		
		JSONArray memoJsonList = memoService.memoSave(userSeq, memoType, jsonStr);
		
		request.setAttribute("result", memoJsonList);		
		return "result.jsp";
	}
	
}
