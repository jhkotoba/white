package com.ljh.white.main.mapper;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.common.extend.CommonMapper;

@Repository("MainMapper")
public class MainMapper extends CommonMapper{
		
	public String selectUserPasswd(WhiteMap param) {
		return selectString("mainMapper.selectUserPasswd", param);
	}
	
	public int getUserSeq(String userId){
		return selectInt("mainMapper.getUserSeq", userId);			
	}
	
	public List<WhiteMap> selectUserAuthority(int userSeq){		
		return selectList("mainMapper.selectUserAuthority", userSeq);			
	}

	public List<WhiteMap> selectUpperMenuList(WhiteMap param){
		return selectList("mainMapper.selectUpperMenuList", param);			
	}
	
	public List<WhiteMap> selectLowerMenuList(WhiteMap param){	
		return selectList("mainMapper.selectLowerMenuList", param);			
	}
}
