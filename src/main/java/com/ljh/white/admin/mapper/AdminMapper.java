package com.ljh.white.admin.mapper;


import java.util.List;

import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.extend.CommonMapper;

@Repository("AdminMapper")
public class AdminMapper extends CommonMapper{	
	
	/**
	 * 사용자 수 조회
	 * @param param
	 * @return
	 */
	public int selectUserCount(WhiteMap param) {
		return selectInt("adminMapper.selectUserCount", param);
	}
	
	/**
	 * 사용자 정보 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUserList(WhiteMap param) {
		return selectList("adminMapper.selectUserList", param);
	}
	
	/**
	 * 권한 리스트 조회
	 * @return
	 */
	public List<WhiteMap> selectAuthList() {
		return selectList("adminMapper.selectAuthList");
	}
	
	/**
	 * 사용자 권한 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUserAuth(WhiteMap param) {
		return selectList("adminMapper.selectUserAuth", param);
	}
	
	/**
	 * 사용자 권한 추가
	 * @param param
	 * @return
	 */
	public int insertAuthList(List<WhiteMap> param) {
		return insert("adminMapper.insertAuthList", param);
	}
	
	/**
	 * 사용자 권한 삭제
	 * @param param
	 * @return
	 */
	public int deleteAuthList(WhiteMap param) {
		return delete("adminMapper.deleteAuthList", param);
	}
	
	/**
	 * 상위 메뉴 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectUpperMenuList() {
		return selectList("adminMapper.selectUpperMenuList");
	}
	
	
	/**
	 * 하위 메뉴 리스트 전체 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectLowerMenuList(WhiteMap param) {
		return selectList("adminMapper.selectLowerMenuList", param);
	}
	
	/**
	 * 상위메뉴 insert
	 * @param list
	 * @return
	 */
	public int insertUpperMenuList(List<WhiteMap> list) {
		return insert("adminMapper.insertUpperMenuList", list);		 
	}	
	
	/**
	 * 상위메뉴 update
	 * @param list
	 * @return
	 */
	public int updateUpperMenuList(List<WhiteMap> list) {
		return update("adminMapper.updateUpperMenuList", list);		 
	}	
	
	/**
	 * 상위메뉴  delete 하기전 하위 사이드메뉴 체크
	 * @param list
	 * @return
	 */
	public int selectIsUsedLowerUrl(List<WhiteMap> list) {
		return selectInt("adminMapper.selectIsUsedLowerUrl", list);		 
	}
	
	/**
	 * 상위메뉴  delete
	 * @param list
	 * @return
	 */
	public int deleteUpperMenuList(List<WhiteMap> list) {
		return delete("adminMapper.deleteUpperMenuList", list);		 
	}
	
	/**
	 * 하위메뉴 insert
	 * @param list
	 * @return
	 */
	public int insertLowerMenuList(List<WhiteMap> list) {
		return insert("adminMapper.insertLowerMenuList", list);		 
	}	
	
	/**
	 * 하위메뉴 update
	 * @param list
	 * @return
	 */
	public int updateLowerMenuList(List<WhiteMap> list) {
		return update("adminMapper.updateLowerMenuList", list);		 
	}	
	
	/**
	 * 하위메뉴  delete
	 * @param list
	 * @return
	 */
	public int deleteLowerMenuList(List<WhiteMap> list) {
		return delete("adminMapper.deleteLowerMenuList", list);		 
	}
	
	
	/**
	 * 권한 insert
	 * @param list
	 * @return
	 */
	public int insertPosAuthList(List<WhiteMap> list) {
		return insert("adminMapper.insertPosAuthList", list);		 
	}	
	
	/**
	 * 권한 update
	 * @param list
	 * @return
	 */
	public int updateAuthList(List<WhiteMap> list) {
		return update("adminMapper.updateAuthList", list);		 
	}	
	
	/**
	 * 권한  delete 하기전 사용되는지 체크
	 * @param list
	 * @return
	 */
	public int selectIsUsedAuth(List<WhiteMap> list) {
		return selectInt("adminMapper.selectIsUsedAuth", list);		 
	}
	
	/**
	 * 권한  delete
	 * @param list
	 * @return
	 */
	public int deleteAuthList(List<WhiteMap> list) {
		return delete("adminMapper.deleteAuthList", list);		 
	}
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public int selectCodeDefineCount(WhiteMap param) {
		return selectInt("adminMapper.selectCodeDefineCount", param);
	}
	
	
	/**
	 * 
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectCodeDefineList(WhiteMap param) {
		return selectList("adminMapper.selectCodeDefineList", param);
	}
	
	
}
