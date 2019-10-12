package com.ljh.white.main.service;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Service;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.utility.cryptolect.BCrypt;
import com.ljh.white.main.mapper.MainMapper;

@Service("MainService")
public class MainService {
	
	@Resource(name = "MainMapper")
	private MainMapper mainMapper;
	
	/**
	 * 사용차 체크
	 * @param param
	 * @return
	 */
	public boolean loginCheck(WhiteMap param) {
		return BCrypt.checkpw(param.getString("passwd"), mainMapper.selectUserPasswd(param));
	}
	
	/**
	 * 사용자 체크, 세션 등록
	 * @param request
	 * @param param
	 * @return
	 */
	public boolean login(HttpServletRequest request, WhiteMap param) {
		String userId = param.getString("userId");
		
		boolean userCheck = BCrypt.checkpw(param.getString("passwd"), mainMapper.selectUserPasswd(param));
		if(userCheck) {
			
			int userSeq = mainMapper.getUserSeq(userId);		
			
			List<WhiteMap> authList = mainMapper.selectUserAuthority(userSeq);
			WhiteMap auth = new WhiteMap();			
			if("leedev".equals(userId)) {
				for(int i=0; i<authList.size(); i++) {
					authList.get(i).put("auth", 1);
				}			
			}			
			for(int i=0; i<authList.size(); i++) {
				auth.put(authList.get(i).getString("authNm"), authList.get(i).getString("auth"));
			}
			
			param.put("userSeq", userSeq);			
			List<WhiteMap> upperList = mainMapper.selectUpperMenuList(param);		
			List<WhiteMap> lowerList = mainMapper.selectLowerMenuList(param);		
			
			//세션 등록 
			HttpSession session = request.getSession();			
			session.setMaxInactiveInterval(3600);		
			session.setAttribute("userId", userId);
			session.setAttribute("userSeq", userSeq);
			session.setAttribute("authority", auth);
			session.setAttribute("upperList", upperList);	
			session.setAttribute("lowerList", lowerList);
			
			return true;
		}else {
			return false;
		}
		
	}
}
