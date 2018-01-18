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
	
	
	public JSONArray getMemoList(String userSeq, String memoType){
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userSeq", userSeq);
		map.put("memoType", memoType);
		
		//List<Map<String, Object>> memoList = memoMapper.selectMemoList(map);
		return new JSONArray(memoMapper.selectMemoList(map));	
		
		//return memoList;
	}	
	
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public void memoSave(int userSeq, String memoType, String jsonStr) {
		
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
		
		JSONArray jsonArr = new JSONArray(jsonStr);
		JSONObject jsonObj = null;	
		
		System.out.println(jsonArr);
		System.out.println(jsonArr.length());
		
		for(int i=0; i<jsonArr.length(); i++) {
			Map<String, Object> memo = new HashMap<String, Object>();
			
			jsonObj = new JSONObject(jsonArr.get(i).toString());
			
			memo.put("userSeq", userSeq);
			memo.put("memoType", memoType);
			memo.put("memoContent", jsonObj.get("memoContent").toString());			
			
			if("insert".equals(jsonObj.get("state").toString())) {
				insertList.add(memo);
			}else if("update".equals(jsonObj.get("state").toString())) {
				updateList.add(memo);
			}else if("delete".equals(jsonObj.get("state").toString())) {
				deleteList.add(memo);
			}
			
			
		}
		
		if("insert".equals(jsonObj.get("state").toString()) && insertList.size() > 0) {
			memoMapper.insertMemoList(insertList);
		}else if("update".equals(jsonObj.get("state").toString())  && updateList.size() > 0) {
			//memoMapper.updateMemoList(updateList);
		}else if("delete".equals(jsonObj.get("state").toString())  && deleteList.size() > 0) {
			//memoMapper.deleteMemoList(deleteList);
		}
		
		
	}
}
