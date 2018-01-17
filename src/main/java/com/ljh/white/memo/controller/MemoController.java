package com.ljh.white.memo.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MemoController {
			
	@RequestMapping(value="/ajax/memoSave.do" )
	public String ledgerPage(HttpServletRequest request){		
			
		
		return "result.jsp";		
	}
	
}
