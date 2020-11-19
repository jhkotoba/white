package com.ljh.white.main.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.ljh.white.common.White;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.main.RModel;
import com.ljh.white.main.service.MainService;

@Controller
public class MainController {

	@Resource(name = "MainService")
	private MainService mainService;
	
	//메인페이지
	@RequestMapping(value="/")
	public String white(HttpServletRequest request){
		return "redirect:/main";
	}

	//메인페이지
	@RequestMapping(value="/main")
	public String main(HttpServletRequest request, Device device){
		request.setAttribute("sectionPage", "main/main.jsp");		
		return White.device(device)+"/white.jsp";
	}
	
	//로그인 유저확인
	@ResponseBody
	@RequestMapping(value="/main/loginCheck.ajax")
	public boolean loginCheck(HttpServletRequest request){		
		WhiteMap param = new WhiteMap();
		
		param.put("userId", request.getParameter("userId"));
		param.put("passwd", request.getParameter("passwd"));		
		return mainService.loginCheck(param);
	}
	
	//로그인
	@RequestMapping(value="/main/login")
	public String login(HttpServletRequest request, Device device){		
		WhiteMap param = new WhiteMap();
		
		param.put("userId", request.getParameter("userId"));
		param.put("passwd", request.getParameter("passwd"));
		mainService.login(request, param);
		
		return "redirect:/main";
	}
	
	//로그아웃
	@RequestMapping(value = "/main/logout")
	public String logout(HttpServletRequest request){
		//세션정보 삭제
		HttpSession session = request.getSession();
		session.removeAttribute("userId");
		session.removeAttribute("userSeq");
		session.removeAttribute("authority");
		session.removeAttribute("upperList");
		session.removeAttribute("lowerList");
		session.invalidate();
		
		return "redirect:/main";
	}
	
	//가입
	@RequestMapping(value = "/main/join")
	public String signUp(HttpServletRequest request, Device device){	
		if(request.getSession(false).getAttribute("userId") == null) {
			request.setAttribute("sectionPage", "main/join.jsp");		
			return White.device(device)+"/white.jsp";
		}else {
			return "redirect:/main";
		}
	}

	//화면이동 컨트롤러
	@RequestMapping(value="{upperUrl}")
	public String white(HttpServletRequest request, Device device) throws UnsupportedEncodingException{		
		WhiteMap param = new WhiteMap(request);	
		
		String upperUrl = param.getString("upperUrl");
		String lowerUrl = param.getString("lowerUrl");	
		
		request.setCharacterEncoding("UTF-8");
		
		request.setAttribute("upperUrl", upperUrl);
		request.setAttribute("lowerUrl", lowerUrl);
		request.setAttribute("upperNm", param.getString("upperNm"));
		request.setAttribute("lowerNm", param.getString("lowerNm"));
		request.setAttribute("prevParam", param.getString("param"));
		
		request.setAttribute("sectionPage", upperUrl.replace("/", "")+lowerUrl+".jsp");
		return White.device(device)+"/white.jsp";
	}
	
	/**
	 * 테스트 - ajax -> @RequestBody MODEL 수신테스트
	 * @param request
	 * @return
	 */
	@ResponseBody
	@PostMapping(value="/main/whiteTest1.ajax")	
	public String whiteTest1(@RequestBody RModel model){
		System.out.println("whiteTest2 @RequestBody MODEL");
		System.out.println(model.toString());
		System.out.println("getTest1:" + model.getTest1());
		System.out.println("getTest2:" + model.getTest2().toString());
		System.out.println("getTest3:" + model.getTest3().toString());
		return "{RESULT:0000}";	
	}
	
	/**
	 * 테스트 ajax -> @RequestBody Map 수신테스트
	 * @param request
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@ResponseBody
	@PostMapping(value="/main/whiteTest2.ajax")	
	public String whiteTest2(@RequestBody Map<String, Object> map){
		System.out.println("whiteTest2 @RequestBody MAP");
		System.out.println(map);
		System.out.println("getTest1:" + map.get("test1"));
		System.out.println("getTest2:" + map.get("test2"));
		System.out.println("getTest2 - STRING:" + ((Map)map.get("test2")).get("STRING"));
		System.out.println("getTest2 - NUMBER:" + ((Map)map.get("test2")).get("NUMBER"));
		System.out.println("getTest3:" + map.get("test3"));
		System.out.println("getTest3 - idx 0:" + ((List)map.get("test3")).get(0));
		System.out.println("getTest3 - idx 1:" + ((List)map.get("test3")).get(1));
		return "{RESULT:0000}";	
	}
	
	
	//파일업로드 TEXT, CSV SYSOUT으로 출력
	@RequestMapping(value="/main/upFile.ajax" )
	public String upFile(MultipartHttpServletRequest request, MultipartFile upfile){
		
		InputStream io = null;
		Scanner sc = null;
		
		try {
			request.setCharacterEncoding("utf-8");
			String path = request.getSession().getServletContext().getRealPath("/");
			String fileName = upfile.getOriginalFilename();
						
			String extension = fileName.substring(fileName.lastIndexOf(".")+1, fileName.length());
		
			System.out.println("## path:: " + path);
			System.out.println("## fileName:: " + fileName);
			System.out.println("## extension:: " + extension);
			
			if("TXT".equals(extension.toUpperCase())) {
				io = upfile.getInputStream();
								
				//InputStreamReader re = new InputStreamReader(io);
				//BufferedReader br = new BufferedReader(re);
				//String li = br.readLine();			
				//System.out.println(li);
				//br.lines();
				
				sc = new Scanner(io);
				while(sc.hasNextLine()) {
					String line = sc.nextLine();
					System.out.println("nextLine::");
					System.out.println(line);
				}
				
			}else if("CSV".equals(extension.toUpperCase())) {
				
			}else {
				throw new Exception("FILE NAME ERROR");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
            try {
                if (io != null) {
                	io.close();
                }
                if( sc != null) {
                	sc.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
		return "SUCCESS";
	}
	
	//파일업로드 
	@RequestMapping(value="/main/upFileSave.ajax" )
	public void upFileSave(MultipartHttpServletRequest request, MultipartFile upfile){
		
		OutputStream os = null;
		
		try {
			request.setCharacterEncoding("utf-8");
			String path = request.getSession().getServletContext().getRealPath("/");
			String fileName = upfile.getOriginalFilename();
		
			System.out.println("## path:: " + path);
			System.out.println("## fileName:: " + fileName);
			
			byte[] bytes = upfile.getBytes();
			File file = new File(path);		
		
			if (fileName != null && !fileName.equals("")) {
			   if (file.exists()) {
			       fileName = System.currentTimeMillis() + "_" + fileName;                    
			           file = new File(path + fileName);
			   }
			}

			os = new FileOutputStream(file);
			os.write(bytes);
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
            try {
                if (os != null) {
                	os.close();
                }               
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	}
}
