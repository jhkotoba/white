package com.ljh.white.admin.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.admin.mapper.AdminMapper;
import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.service.WhiteService;

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
		return this.selectSideMenuList(null);
	}
	public List<WhiteMap> selectSideMenuList(WhiteMap param) {
		return adminMapper.selectSideMenuList(param);
	}	
	
	/**
	 * 네비(상위) 메뉴리스트 적용
	 * @param param
	 * @return -1: 반영전 수정할 데이터가 수정하기전에 바뀜, -2:삭제대상이 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyNavMenuList(WhiteMap param) {
		
		//반영전 수정되었는지 체크
		List<WhiteMap> menuList = param.convertListWhiteMap("navClone", false);
		List<WhiteMap> list = adminMapper.selectNavMenuList();		
		
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
			return -2;
		}else {			
			if(insertList.size()>0) adminMapper.insertNavMenuList(insertList);	
			if(updateList.size()>0) adminMapper.updateNavMenuList(updateList);
			if(deleteList.size()>0) {
				adminMapper.deleteNavMenuList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "nav_menu");
				map.put("firstSeqNm", "nav_seq");							
				map.put("columnNm", "nav_order");
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
	public int applySideMenuList(WhiteMap param) {
		
		//반영전 수정되었는지 체크
		List<WhiteMap> menuList = param.convertListWhiteMap("sideClone", false);
		List<WhiteMap> list = adminMapper.selectSideMenuList(param.createKeyNewMap("navSeq"));
		
		if(menuList.size() != list.size()) {
			return -1;
		}else {
			for(int i=0; i<menuList.size(); i++) {
				if(!menuList.get(i).get("sideNm").equals(list.get(i).get("sideNm"))) {
					return -1;
				}else if(!menuList.get(i).get("sideUrl").equals(list.get(i).get("sideUrl"))) {
					return -1;
				}else if(!menuList.get(i).get("sideAuthNmSeq").equals(list.get(i).get("sideAuthNmSeq"))) {
					return -1;
				}else if(!menuList.get(i).get("sideShowYn").equals(list.get(i).get("sideShowYn"))) {
					return -1;
				}else if(!menuList.get(i).get("sideOrder").equals(list.get(i).get("sideOrder"))) {
					return -1;
				}
			}			
		}
		
		menuList = param.convertListWhiteMap("sideList", false);		
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
		
		if(insertList.size()>0) adminMapper.insertSideMenuList(insertList);	
		if(updateList.size()>0) adminMapper.updateSideMenuList(updateList);
		if(deleteList.size()>0) {
			adminMapper.deleteSideMenuList(deleteList);
			
			WhiteMap map = new WhiteMap();
			map.put("tableNm", "side_menu");
			map.put("firstSeqNm", "side_seq");				
			map.put("secondSeqNm", "nav_seq");				
			map.put("secondSeq", deleteList.get(0).getString("navSeq"));				
			map.put("columnNm", "side_order");
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
			if(insertList.size()>0) adminMapper.insertAuthNmList(insertList);	
			if(updateList.size()>0) adminMapper.updateAuthNmList(updateList);
			if(deleteList.size()>0) {
				adminMapper.deleteAuthNmList(deleteList);
				
				WhiteMap map = new WhiteMap();
				map.put("tableNm", "auth_name");
				map.put("firstSeqNm", "auth_nm_seq");							
				map.put("columnNm", "auth_order");
				whiteService.updateSortTable(map);
			}
			return 1;
		}
	}	
	
	/**
	 * 코드정의목록 조회
	 * @return
	 */
	public List<WhiteMap> selectCodeDefineList(WhiteMap param) {		
		return adminMapper.selectCodeDefineList(param);		
		
	}
	
	
}
