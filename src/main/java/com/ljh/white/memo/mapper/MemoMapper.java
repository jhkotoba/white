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
	
	//메모 리스트 조회
	public List<Map<String, Object>> selectMemoList(Map<String, Object> map){
		return sqlSession.selectList("memoMapper.selectMemoList", map);
	}	
	
	//메모 리스트 추가
	public int insertMemoList(List<Map<String, Object>> list ){			
		return sqlSession.insert("memoMapper.insertMemoList", list);
	}
	
	//메모 리스트 조회
	public int updateMemoList(List<Map<String, Object>> list ){	
		return sqlSession.update("memoMapper.updateMemoList", list);
	}
	
	//메모 리스트 조회
	public int deleteMemoList(List<Map<String, Object>> list ){	
		return sqlSession.delete("memoMapper.deleteMemoList", list);
	}
}
