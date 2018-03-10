package com.ljh.white.common.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;



@Repository("WhiteMapper")
public class WhiteMapper {
	
	private static Logger logger = LogManager.getLogger(WhiteMapper.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * 입력된 테이블, 컬럼, 데이터로 해당 데이터의 갯수를 구함
	 * @param map
	 * @return count
	 */
	public int selectIsCntColumn(Map<String, Object> map ){		
		return sqlSession.selectOne("whiteMapper.selectIsCntColumn", map);
	}
	
	public List<WhiteMap> selectSideMenuList(WhiteMap param){		
		logger.debug("param: "+param);
		return sqlSession.selectList("whiteMapper.selectSideMenuList", param);			
	}
}
