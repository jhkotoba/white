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
	 * 수정된 유저권한 적용
	 * @param param
	 * @return
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public WhiteMap applyUserAuthList(WhiteMap param) {
		
		WhiteMap result = new WhiteMap();
		
		//권한 추가
		String add = param.getString("add");
		if(!"".equals(add) && add != null) {	
			String[] addArr = add.split(",");
			List<WhiteMap> addList = new ArrayList<WhiteMap>();
			WhiteMap map = null;
			
			for(int i=0; i<addArr.length; i++) {
				map = new WhiteMap();
				map.put("userNo", param.get("userNo"));
				map.put("authNmSeq", addArr[i]);
				addList.add(map);
			}			
			result.put("add", adminMapper.insertAuthList(addList));
		}
		
		//권한 삭제
		String remove = param.getString("remove");
		if(!"".equals(remove) && remove != null) {
			result.put("remove", adminMapper.deleteAuthList(param));
		}
		
		return result;
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
	 * 상위메뉴 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectNavMenuList() {		
		return adminMapper.selectNavMenuList();		
		
	}	
	/**
	 * 하위메뉴 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSideMenuList() {		
		return adminMapper.selectSideMenuList();		
		
	}
	
	/**
	 * 네비메뉴 insert, update, delete (구)
	 * @param list
	 * @return
	 * @deprecated
	 * applyNavMenuList 로 대체
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
	 * 메뉴리스트 적용
	 * @param param
	 * @return -1: 반영전 수정할 데이터가 수정하기전에 바뀜, 0:삭제대상이 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyNavMenuList(WhiteMap param) {
	
		List<WhiteMap> menuList = param.convertListWhiteMap("navClone", false);
		List<WhiteMap> list = adminMapper.selectNavMenuList();
		
		//반영전 수정되었는지 체크
		if(menuList.size() != list.size()) {
			return -1;
		}else {
			for(int i=0; i<menuList.size(); i++) {
				if(!menuList.get(i).get("navNm").equals(list.get(i).get("navNm"))) {
					return -1;
				}else if(!menuList.get(i).get("navUrl").equals(list.get(i).get("navUrl"))) {
					return -1;
				}else if(!menuList.get(i).get("navAuthNmSeq").equals(list.get(i).get("navAuthNmSeq"))) {
					return -1;
				}else if(!menuList.get(i).get("navShowYn").equals(list.get(i).get("navShowYn"))) {
					return -1;
				}else if(!menuList.get(i).get("navOrder").equals(list.get(i).get("navOrder"))) {
					return -1;
				}
			}			
		}
		
		menuList = param.convertListWhiteMap("navList", false);		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		
		for(int i=0; i<menuList.size(); i++) {
			if("delete".equals(menuList.get(i).get("state"))) {
				deleteList.add(menuList.get(i));
			}else if("insert".equals(menuList.get(i).get("state"))) {
				insertList.add(menuList.get(i));
			}else {
				updateList.add(menuList.get(i));
			}
		}
		
		if(deleteList.size()>0 && adminMapper.selectIsUsedSideUrl(deleteList)>0) {
			return 0;
		}else {
			if(deleteList.size()>0) adminMapper.deleteNavMenuList(deleteList);
			if(insertList.size()>0) adminMapper.insertNavMenuList(insertList);	
			if(updateList.size()>0) adminMapper.updateNavMenuList(updateList);
			return 1;
		}
		
		
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
	 * 권한 적용
	 * @param param
	 * @return -1: 반영전 수정할 데이터가 수정하기전에 바뀜, 0:삭제대상이 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyAuthList(WhiteMap param) {
		
		List<WhiteMap> authList = param.convertListWhiteMap("clone", false);
		List<WhiteMap> list = adminMapper.selectAuthList();
		
		//반영전 수정되었는지 체크
		if(authList.size() != list.size()) {
			return -1;
		}else {
			for(int i=0; i<authList.size(); i++) {
				if(!authList.get(i).get("authCmt").equals(list.get(i).get("authCmt"))) {
					return -1;
				}else if(!authList.get(i).get("authOrder").equals(list.get(i).get("authOrder"))) {
					return -1;
				}else if(!authList.get(i).get("authNmSeq").equals(list.get(i).get("authNmSeq"))) {
					return -1;
				}else if(!authList.get(i).get("authNm").equals(list.get(i).get("authNm"))) {
					return -1;
				}
			}			
		}
		
		authList = param.convertListWhiteMap("authList", false);		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();	
	
		for(int i=0; i<authList.size(); i++) {
			if("delete".equals(authList.get(i).get("state"))) {
				deleteList.add(authList.get(i));
			}else if("insert".equals(authList.get(i).get("state"))) {
				insertList.add(authList.get(i));
			}else {
				updateList.add(authList.get(i));
			}
		}
		
		if(deleteList.size()>0 && adminMapper.selectIsUsedAuthNm(deleteList)>0) {
			return 0;
		}else {
			if(deleteList.size()>0) adminMapper.deleteAuthNmList(deleteList);
			if(insertList.size()>0) adminMapper.insertAuthNmList(insertList);	
			if(updateList.size()>0) adminMapper.updateAuthNmList(updateList);
			return 1;
		}
	}
	
}
