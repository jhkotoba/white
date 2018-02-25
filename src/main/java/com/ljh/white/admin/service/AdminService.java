package com.ljh.white.admin.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.admin.mapper.AdminMapper;
import com.ljh.white.common.collection.WhiteMap;

@Service("AdminService")
public class AdminService {
	
	@Resource(name = "AdminMapper")
	private AdminMapper adminMapper;
	
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public int selectUserCount(WhiteMap param) {
		return adminMapper.selectUserCount(param);	
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUserList(WhiteMap param) {			
		param.put("pagePre", (param.getInt("pageNum")-1)*param.getInt("pageCnt"));		
		return adminMapper.selectUserList(param);
	}
	
	/**
	 * 
	 * @return
	 */
	public List<WhiteMap> selectAuthList() {			
		return adminMapper.selectAuthList();
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUserAuth(WhiteMap param) {			
		return adminMapper.selectUserAuth(param);
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inDelAuthList(WhiteMap param) {
		
		List<WhiteMap> inList = param.getListWhiteMap("inList");
		List<WhiteMap> delList = param.getListWhiteMap("delList");		
		
		WhiteMap resultMap = new WhiteMap();
		if(inList.size() > 0 ) {			
			resultMap.put("inCnt", adminMapper.insertAuthList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(delList.size() > 0) {			
			resultMap.put("delCnt", adminMapper.deleteAuthList(delList));
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		return resultMap;		
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectNavMenuList(WhiteMap param) {		
		return adminMapper.selectNavMenuList(param);		
		
	}	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSideMenuList(WhiteMap param) {		
		return adminMapper.selectSideMenuList(param);		
		
	}
	
}
