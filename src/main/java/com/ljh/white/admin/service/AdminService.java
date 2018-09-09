package com.ljh.white.admin.service;

import java.util.ArrayList;
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
	 * 유저 카운트 조회
	 * @param param
	 * @return
	 */
	public int selectUserCount(WhiteMap param) {
		return adminMapper.selectUserCount(param);	
	}
	
	/**
	 * 유저 정보 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUserList(WhiteMap param) {
		param.put("pagePre", (param.getInt("pageIndex")-1)*param.getInt("pageSize"));
		return adminMapper.selectUserList(param);
	}
	
	/**
	 * 
	 * @return
	 */
	public List<WhiteMap> selectAuthList(WhiteMap param) {			
		return adminMapper.selectAuthList(param);
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
	 * 수정된 유저권한 적용
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public void applyUserAuthList(WhiteMap param) {
		//권한 추가
		String add = param.getString("add");
		if(!"".equals(add) || add != null) {			
			String[] addArr = add.split(",");
			List<WhiteMap> addList = new ArrayList<WhiteMap>();
			WhiteMap map = null;
			
			for(int i=0; i<addArr.length; i++) {
				map = new WhiteMap();
				map.put("userNo", param.get("userNo"));
				map.put("authNmSeq", addArr[i]);
				addList.add(map);
			}			
			adminMapper.insertAuthList(addList);
		}
		
		//권한 삭제
		String remove = param.getString("remove");
		if(!"".equals(remove) || remove != null) {
			adminMapper.deleteAuthList(param);
		}
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	/*@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inDelAuthList(WhiteMap param) {
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);		
		
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
	}*/
	
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
	
	/**
	 * 네비메뉴 insert, update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inUpDelNavMenuList(WhiteMap param) {
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", false);
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
		WhiteMap resultMap = new WhiteMap();
		
		if(delList.size() > 0) {
			if(adminMapper.selectIsUsedSideUrl(delList)>0) {
				resultMap.put("msg", "used");
				return resultMap;			
			}else {
				resultMap.put("delCnt", adminMapper.deleteNavMenuList(delList));
			}					
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		if(inList.size() > 0 ) {
			resultMap.put("inCnt", adminMapper.insertNavMenuList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", adminMapper.updateNavMenuList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}		
		return resultMap;
	}
	
	/**
	 * 사이드메뉴 insert, update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inUpDelSideMenuList(WhiteMap param) {
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", false);
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
		WhiteMap resultMap = new WhiteMap();
		
		if(inList.size() > 0 ) {
			resultMap.put("inCnt", adminMapper.insertSideMenuList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", adminMapper.updateSideMenuList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}
		
		if(delList.size() > 0) {
			resultMap.put("delCnt", adminMapper.deleteSideMenuList(delList));			
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		return resultMap;
	}
	
	
	/**
	 * 권한 insert, update, delete
	 * @param list
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap inUpDelAuthNmList(WhiteMap param) {
		
		List<WhiteMap> inList = param.convertListWhiteMap("inList", false);
		List<WhiteMap> upList = param.convertListWhiteMap("upList", false);
		List<WhiteMap> delList = param.convertListWhiteMap("delList", false);
		
		WhiteMap resultMap = new WhiteMap();
		
		if(delList.size() > 0) {
			if(adminMapper.selectIsUsedAuthNm(delList)>0) {
				resultMap.put("msg", "used");
				return resultMap;			
			}else {
				resultMap.put("delCnt", adminMapper.deleteAuthNmList(delList));
			}					
		}else {
			resultMap.put("delCnt", 0);	
		}
		
		if(inList.size() > 0 ) {
			resultMap.put("inCnt", adminMapper.insertAuthNmList(inList));	
		}else {
			resultMap.put("inCnt", 0);	
		}
		
		if(upList.size() > 0 ) {			
			resultMap.put("upCnt", adminMapper.updateAuthNmList(upList));	
		}else {
			resultMap.put("upCnt", 0);	
		}		
		return resultMap;
	}
	
}
