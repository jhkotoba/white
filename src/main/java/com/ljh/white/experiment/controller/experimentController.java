package com.ljh.white.experiment.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class experimentController {
	
	@RequestMapping(value="/experiment")
	public String experimentMain(HttpServletRequest request){
		System.out.println("experimentMain");
		
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/experiment.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/exitTimer.do")
	public String exitTime(HttpServletRequest request){
		System.out.println("exitTime");
		
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/exitTimer.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/cssDemo.do")
	public String cssDemo(HttpServletRequest request){
		System.out.println("cssDemo");
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/cssDemo.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/roofTest.do")
	public String roofTest(HttpServletRequest request){
		System.out.println("roofTest");
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/roofTest.jsp");
		return "white.jsp";
	}
	
	@RequestMapping(value="/experiment/jstlTest.do")
	public String jstlTest(HttpServletRequest request){
		System.out.println("jstlTest");
		
		
		//fn:replace TEST
		request.setAttribute("data1","/data1/page/test.txt" );	
		request.setAttribute("data2","/page/page/page/number/test.txt" );
		request.setAttribute("data3","/typeA/upload/AAA/BBB/100/image.jpg" );	
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		for(int i=0; i<5; i++) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("nm", "image"+(i+1));
			map.put("ph", "/typeA/upload/AAA/BBB/100/image("+(i+1)+").jpg");
			
			list.add(map);
		}
		request.setAttribute("list",list);
		
		request.setAttribute("sidePage", null);		
		request.setAttribute("sectionPage", "experiment/jstlTest.jsp");
		return "white.jsp";
	}
	
}
