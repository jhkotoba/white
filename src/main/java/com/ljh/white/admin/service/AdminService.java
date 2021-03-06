package com.ljh.white.admin.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.admin.mapper.AdminMapper;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.white.service.WhiteService;

@Service("AdminService")
public class AdminService {
	
	@Resource(name = "AdminMapper")
	private AdminMapper adminMapper;
	
	@Resource(name = "WhiteService")
	private WhiteService whiteService;
	
	
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
				map.put("authSeq", addArr[i]);
				addList.add(map);
			}			
			result.put("add", adminMapper.insertPosAuthList(addList));
		}
		
		//권한 삭제
		String remove = param.getString("remove");
		if(!"".equals(remove) && remove != null) {
			result.put("remove", adminMapper.deleteAuthList(param));
		}
		
		return result;
	}	
	
	/**
	 * 상위메뉴 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUpperMenuList() {		
		return adminMapper.selectUpperMenuList();		
		
	}
		
	/**
	 * 하위메뉴 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectLowerMenuList() {		
		return this.selectLowerMenuList(null);
	}
	public List<WhiteMap> selectLowerMenuList(WhiteMap param) {
		return adminMapper.selectLowerMenuList(param);
	}	
	
	/**
	 * 상위 메뉴리스트 적용
	 * @param param
	 * @return -1: 반영전 수정할 데이터가 수정하기전에 바뀜, -2:삭제대상이 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyUpperMenuList(WhiteMap param) {
		
		//반영전 수정되었는지 체크
		List<WhiteMap> menuList = param.convertListWhiteMap("upperClone", false);
		List<WhiteMap> list = adminMapper.selectUpperMenuList();		
		
		if(menuList.size() != list.size()) {
			return -1;
		}else {
			for(int i=0; i<menuList.size(); i++) {
				if(!menuList.get(i).get("upperNm").equals(list.get(i).get("upperNm"))) {
					return -1;
				}else if(!menuList.get(i).get("upperUrl").equals(list.get(i).get("upperUrl"))) {
					return -1;
				}else if(!menuList.get(i).get("authSeq").equals(list.get(i).get("authSeq"))) {
					return -1;
				}else if(!menuList.get(i).get("showYn").equals(list.get(i).get("showYn"))) {
					return -1;
				}else if(!menuList.get(i).get("upperOdr").equals(list.get(i).get("upperOdr"))) {
					return -1;
				}
			}			
		}
		
		menuList = param.convertListWhiteMap("upperList", false);		
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
		
		if(deleteList.size()>0 && adminMapper.selectIsUsedLowerUrl(deleteList)>0) {
			return -2;
		}else {			
			if(insertList.size()>0) adminMapper.insertUpperMenuList(insertList);	
			if(updateList.size()>0) adminMapper.updateUpperMenuList(updateList);
			if(deleteList.size()>0) {
				adminMapper.deleteUpperMenuList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "UPPER_MENU");
				map.put("firstSeqNm", "UPPER_SEQ");							
				map.put("columnNm", "UPPER_ODR");
				whiteService.updateSortTable(map);	
			}
			return 1;
		}
	}
	
	
	/**
	 * 사이드(하위) 메뉴리스트 적용
	 * @param param
	 * @return -1: 반영전 수정할 데이터가 수정하기전에 바뀜, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyLowerMenuList(WhiteMap param) {
		
		//반영전 수정되었는지 체크
		List<WhiteMap> menuList = param.convertListWhiteMap("lowerClone", false);
		List<WhiteMap> list = adminMapper.selectLowerMenuList(param.createKeyNewMap("upperSeq"));
		
		if(menuList.size() != list.size()) {
			return -1;
		}else {
			for(int i=0; i<menuList.size(); i++) {
				if(!menuList.get(i).get("lowerNm").equals(list.get(i).get("lowerNm"))) {
					return -1;
				}else if(!menuList.get(i).get("lowerUrl").equals(list.get(i).get("lowerUrl"))) {
					return -1;
				}else if(!menuList.get(i).get("authSeq").equals(list.get(i).get("authSeq"))) {
					return -1;
				}else if(!menuList.get(i).get("showYn").equals(list.get(i).get("showYn"))) {
					return -1;
				}else if(!menuList.get(i).get("lowerOdr").equals(list.get(i).get("lowerOdr"))) {
					return -1;
				}
			}			
		}
		
		menuList = param.convertListWhiteMap("lowerList", false);		
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
		
		if(insertList.size()>0) adminMapper.insertLowerMenuList(insertList);	
		if(updateList.size()>0) adminMapper.updateLowerMenuList(updateList);
		if(deleteList.size()>0) {
			adminMapper.deleteLowerMenuList(deleteList);
			
			WhiteMap map = new WhiteMap();
			map.put("tableNm", "LOWER_MENU");
			map.put("firstSeqNm", "LOWER_SEQ");				
			map.put("secondSeqNm", "UPPER_SEQ");				
			map.put("secondSeq", deleteList.get(0).getString("upperSeq"));				
			map.put("columnNm", "LOWER_ODR");
			whiteService.updateSortTable(map);			
		}
		return 1;
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
				}else if(!authList.get(i).get("authOdr").equals(list.get(i).get("authOdr"))) {
					return -1;
				}else if(!authList.get(i).get("authSeq").equals(list.get(i).get("authSeq"))) {
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
		
		if(deleteList.size()>0 && adminMapper.selectIsUsedAuth(deleteList)>0) {
			return 0;
		}else {			
			if(insertList.size()>0) adminMapper.insertAuthList(insertList);	
			if(updateList.size()>0) adminMapper.updateAuthList(updateList);
			if(deleteList.size()>0) {
				adminMapper.deleteAuthList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "AUTH");
				map.put("firstSeqNm", "AUTH_SEQ");							
				map.put("columnNm", "AUTH_ODR");
				whiteService.updateSortTable(map);
			}
			return 1;
		}
	}	
	
	/**
	 * 코드정의목록 조회
	 * @return
	 */
	public int selectCodeDefineCount(WhiteMap param) {		
		return adminMapper.selectCodeDefineCount(param);
	}
	
	/**
	 * 코드정의목록 조회
	 * @return
	 */
	public List<WhiteMap> selectCodeDefineList(WhiteMap param) {
		param.put("pagePre", (param.getInt("pageIndex")-1)*param.getInt("pageSize"));
		return adminMapper.selectCodeDefineList(param);		
	}
}
