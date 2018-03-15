package com.ljh.white.admin.mapper;


import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("AdminMapper")
public class AdminMapper {

	private static Logger logger = LogManager.getLogger(AdminMapper.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	public int selectUserCount(WhiteMap param) {
		logger.debug(param);		
		return sqlSession.selectOne("adminMapper.selectUserCount", param);
	}
	
	public List<WhiteMap> selectUserList(WhiteMap param) {
		logger.debug(param);		
		return sqlSession.selectList("adminMapper.selectUserList", param);
	}
	
	public List<WhiteMap> selectAuthList(WhiteMap param) {	
		return sqlSession.selectList("adminMapper.selectAuthList", param);
	}
	
	public List<WhiteMap> selectUserAuth(WhiteMap param) {
		logger.debug(param);		
		return sqlSession.selectList("adminMapper.selectUserAuth", param);
	}
	
	public int insertAuthList(List<WhiteMap> param) {
		logger.debug(param);
		return sqlSession.insert("adminMapper.insertAuthList", param);
	}
	
	public int deleteAuthList(List<WhiteMap> param) {
		logger.debug(param);
		return sqlSession.delete("adminMapper.deleteAuthList", param);
	}
	
	/**
	 * 네비 메뉴 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectNavMenuList(WhiteMap param) {
		return sqlSession.selectList("adminMapper.selectNavMenuList", param);
	}
	
	/**
	 * 사이드 메뉴 리스트 조회
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectSideMenuList(WhiteMap param) {
		return sqlSession.selectList("adminMapper.selectSideMenuList", param);
	}
	
	/**
	 * 네비메뉴 insert
	 * @param list
	 * @return
	 */
	public int insertNavMenuList(List<WhiteMap> list) {		
		return sqlSession.insert("adminMapper.insertNavMenuList", list);		 
	}	
	
	/**
	 * 네비메뉴 update
	 * @param list
	 * @return
	 */
	public int updateNavMenuList(List<WhiteMap> list) {		
		return sqlSession.update("adminMapper.updateNavMenuList", list);		 
	}	
	
	/**
	 * 네비메뉴  delete 하기전 하위 사이드메뉴 체크
	 * @param list
	 * @return
	 */
	public int selectIsUsedSideUrl(List<WhiteMap> list) {		
		return sqlSession.selectOne("adminMapper.selectIsUsedSideUrl", list);		 
	}
	
	/**
	 * 네비메뉴  delete
	 * @param list
	 * @return
	 */
	public int deleteNavMenuList(List<WhiteMap> list) {		
		return sqlSession.delete("adminMapper.deleteNavMenuList", list);		 
	}
	
	/**
	 * 사이드메뉴 insert
	 * @param list
	 * @return
	 */
	public int insertSideMenuList(List<WhiteMap> list) {		
		return sqlSession.insert("adminMapper.insertSideMenuList", list);		 
	}	
	
	/**
	 * 사이드메뉴 update
	 * @param list
	 * @return
	 */
	public int updateSideMenuList(List<WhiteMap> list) {		
		return sqlSession.update("adminMapper.updateSideMenuList", list);		 
	}	
	
	/**
	 * 사이드메뉴  delete
	 * @param list
	 * @return
	 */
	public int deleteSideMenuList(List<WhiteMap> list) {		
		return sqlSession.delete("adminMapper.deleteSideMenuList", list);		 
	}
	
	
	/**
	 * 권한 insert
	 * @param list
	 * @return
	 */
	public int insertAuthNmList(List<WhiteMap> list) {		
		return sqlSession.insert("adminMapper.insertAuthNmList", list);		 
	}	
	
	/**
	 * 권한 update
	 * @param list
	 * @return
	 */
	public int updateAuthNmList(List<WhiteMap> list) {		
		return sqlSession.update("adminMapper.updateAuthNmList", list);		 
	}	
	
	/**
	 * 권한  delete 하기전 사용되는지 체크
	 * @param list
	 * @return
	 */
	public int selectIsUsedAuthNm(List<WhiteMap> list) {		
		return sqlSession.selectOne("adminMapper.selectIsUsedAuthNm", list);		 
	}
	
	/**
	 * 권한  delete
	 * @param list
	 * @return
	 */
	public int deleteAuthNmList(List<WhiteMap> list) {		
		return sqlSession.delete("adminMapper.deleteAuthNmList", list);		 
	}
}
