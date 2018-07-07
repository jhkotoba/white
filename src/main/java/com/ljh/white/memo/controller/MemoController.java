package com.ljh.white.memo.controller;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.memo.service.MemoService;

@RestController
public class MemoController {
	
	@Resource(name = "MemoService")
	private MemoService memoService;
			
	
	@RequestMapping(value="/memo/selectMemoList.ajax" )
	public List<WhiteMap> selectMemoList(HttpServletRequest request){		
		
		WhiteMap param = new WhiteMap(request);		
		return memoService.selectMemoList(param);		
	}
	
	@RequestMapping(value="/memo/memoSave.ajax" )
	public List<WhiteMap> memoSave(HttpServletRequest request){	
		
		int userSeq = Integer.parseInt(request.getSession(false).getAttribute("userSeq").toString());
		String memoType = request.getParameter("memoType");
		String jsonStr = request.getParameter("jsonStr");		
		
		return memoService.memoSave(userSeq, memoType, jsonStr);
	}
	
}
