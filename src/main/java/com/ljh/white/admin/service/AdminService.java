package com.ljh.white.admin.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ljh.white.admin.mapper.AdminMapper;
import com.ljh.white.common.collection.WhiteMap;

@Service("AdminService")
public class AdminService {
	
	@Resource(name = "AdminMapper")
	private AdminMapper adminMapper;
	
	public int selectUserCount(WhiteMap param) {
		return adminMapper.selectUserCount(param);	
	}
	
	public List<WhiteMap> selectUserList(WhiteMap param) {			
		param.put("pagePre", (param.getInt("pageNum")-1)*param.getInt("pageCnt"));
		
		List<WhiteMap> list = adminMapper.selectUserList(param);
		for(int i=0; i<list.size(); i++) {
			System.out.println(list.get(i));
			
		}
		
		return list;
	}
	
	
	
}
