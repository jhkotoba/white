package com.ljh.white.memo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ljh.white.memo.bean.MemoBean;

@Repository("MemoMapper")
public class MemoMapper {

	@Autowired
	private SqlSession sqlSession;
	
	public List<Map<String, Object>> selectMemoList(Map<String, Object> map){
		return sqlSession.selectList("memoMapper.selectMemoList", map);
	}
	
	
	public int insertMemoList(List<Map<String, Object>> list ){		
		//System.out.println("#####################");
		//System.out.println(list);
		return sqlSession.insert("memoMapper.insertMemoList", list);
	}
}
