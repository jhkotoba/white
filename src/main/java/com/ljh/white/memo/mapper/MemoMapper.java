package com.ljh.white.memo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;

@Repository("MemoMapper")
public class MemoMapper {

	@Autowired
	private SqlSession sqlSession;
	
	//메모 리스트 조회
	public List<WhiteMap> selectMemoList(WhiteMap map){
		return sqlSession.selectList("memoSelectMapper.selectMemoList", map);
	}	
	
	//메모 리스트 추가
	public int insertMemoList(List<WhiteMap> list ){			
		return sqlSession.insert("memoInsertMapper.insertMemoList", list);
	}
	
	//메모 리스트 조회
	public int updateMemoList(List<WhiteMap> list ){	
		return sqlSession.update("memoUpdateMapper.updateMemoList", list);
	}
	
	//메모 리스트 조회
	public int deleteMemoList(List<WhiteMap> list ){	
		return sqlSession.delete("memoDeleteMapper.deleteMemoList", list);
	}
}
