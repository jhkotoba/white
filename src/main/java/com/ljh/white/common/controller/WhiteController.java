package com.ljh.white.common.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;

/**
 * 공통 컨트롤러
 * @author JeHoon
 *
 */
@Controller
public class WhiteController {
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;	
	
	@ResponseBody
	@RequestMapping(value="/white/selectCodeList.ajax")
	public WhiteMap selectCodeList(HttpServletRequest request){		
		WhiteMap param = new WhiteMap(request);
		return whiteService.selectCodeList(param);		
	}

	/**
	 * 화면에서 데이터를 받아 엑셀 다운로드
	 * @param request
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="/white/excelPrint.print")
	public void dataPrintRecordList(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{		
		WhiteMap param = new WhiteMap(request);
		/*System.out.println(param);
		System.out.println("dataPrintRecordList");
		List<WhiteMap> list = param.convertListWhiteMap("param", false);
		
		for(int i=0; i<list.size(); i++) {
			System.out.println(list.get(i));
		}*/
		
		
		String filename = URLEncoder.encode(param.getString("filename"), "UTF-8").replace("+", "%20").replace("(", "%28").replace(")", "%29");
		
		response.setContentType("application/octet-stream");
		response.setHeader("Content-disposition", "attachment; filename=\""+filename+"\"");
	}
	

}
