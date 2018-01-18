package com.ljh.white.memo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.memo.bean.MemoBean;
import com.ljh.white.memo.mapper.MemoMapper;

@Service("MemoService")
public class MemoService{	
	
	@Resource(name = "MemoMapper")
	private MemoMapper memoMapper;
	
	
	public JSONArray selectMemoList(String userSeq, String memoType){
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userSeq", userSeq);
		map.put("memoType", memoType);		
		
		return new JSONArray(memoMapper.selectMemoList(map));
	}	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public JSONArray memoSave(int userSeq, String memoType, String jsonStr) {
		
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
		
		JSONArray jsonArr = new JSONArray(jsonStr);
		JSONObject jsonObj = null;	
		
		for(int i=0; i<jsonArr.length(); i++) {
			Map<String, Object> memo = new HashMap<String, Object>();
			
			jsonObj = new JSONObject(jsonArr.get(i).toString());
			
			memo.put("userSeq", userSeq);			
			memo.put("memoType", memoType);
			memo.put("memoSeq", jsonObj.get("memoSeq").toString());
			memo.put("memoContent", jsonObj.get("memoContent").toString());	
			memo.put("state", jsonObj.get("state").toString());	
			
			if("insert".equals(jsonObj.get("state").toString())) {
				insertList.add(memo);
			}else if("update".equals(jsonObj.get("state").toString())) {
				updateList.add(memo);
			}else if("delete".equals(jsonObj.get("state").toString())) {
				deleteList.add(memo);
			}
			
			
		}
		
		if(!insertList.isEmpty()) {
			memoMapper.insertMemoList(insertList);
		}
		if(!updateList.isEmpty()) {
			memoMapper.updateMemoList(updateList);
		}
		if(!deleteList.isEmpty()) {
			memoMapper.deleteMemoList(deleteList);
		}
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userSeq", userSeq);
		map.put("memoType", memoType);		
		
		return new JSONArray(memoMapper.selectMemoList(map));
		
		
	}
}
