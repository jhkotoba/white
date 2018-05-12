package com.ljh.white.styleSheet.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.ljh.white.common.White;
import com.ljh.white.common.collection.WhiteMap;

@Controller
public class StyleSheetController {
	
	@RequestMapping(value="/styleSheet")
	public String experiment(HttpServletRequest request, Device device){
		
		WhiteMap param = new WhiteMap(request);
		
		String navUrl = param.getString("navUrl");
		String sideUrl = param.getString("sideUrl");
		
		request.setAttribute("navUrl", navUrl);
		request.setAttribute("sideUrl", sideUrl);

		request.setAttribute("sectionPage", navUrl.replace("/", "")+sideUrl+".jsp");
		return White.device(device)+"/white.jsp";
	}
}
