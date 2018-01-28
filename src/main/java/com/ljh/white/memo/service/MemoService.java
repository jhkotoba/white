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

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.memo.mapper.MemoMapper;

@Service("MemoService")
public class MemoService{	
	
	@Resource(name = "MemoMapper")
	private MemoMapper memoMapper;
	
	
	public List<WhiteMap> selectMemoList(WhiteMap param){//int userSeq, String memoType){		
		return memoMapper.selectMemoList(param);
	}	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public JSONArray memoSave(int userSeq, String memoType, String jsonStr) {
		
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		
		JSONArray jsonArr = new JSONArray(jsonStr);
		JSONObject jsonObj = null;	
		
		for(int i=0; i<jsonArr.length(); i++) {
			WhiteMap memo = new WhiteMap();
			
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
				
		WhiteMap map = new WhiteMap();
		map.put("userSeq", userSeq);
		map.put("memoType", memoType);		
		
		return new JSONArray(memoMapper.selectMemoList(map));
		
		
	}
}
