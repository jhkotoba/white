package com.ljh.white.common.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;



@Repository("WhiteMapper")
public class WhiteMapper {
	
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
}
