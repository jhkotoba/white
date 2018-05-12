package com.ljh.white.experiment.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.collection.WhiteMap;

@Controller
public class experimentController {
	
	@RequestMapping(value="/experiment")
	public String experiment(HttpServletRequest request){
		System.out.println("experiment start");
		
		WhiteMap param = new WhiteMap(request);
		
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);

		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return "white.jsp";
	}
}
