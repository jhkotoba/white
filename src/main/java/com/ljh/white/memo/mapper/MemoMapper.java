package com.ljh.white.memo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("MemoMapper")
public class MemoMapper {

	@Autowired
	private SqlSession sqlSession;
	
	public List<Map<String, Object>> selectMemoList(Map<String, Object> map){
		return sqlSession.selectList("memoMapper.selectMemoList", map);
	}	
	
	public int insertMemoList(List<Map<String, Object>> list ){			
		return sqlSession.insert("memoMapper.insertMemoList", list);
	}
	
	public int updateMemoList(List<Map<String, Object>> list ){	
		return sqlSession.update("memoMapper.updateMemoList", list);
	}
	
	public int deleteMemoList(List<Map<String, Object>> list ){	
		return sqlSession.delete("memoMapper.deleteMemoList", list);
	}
}
