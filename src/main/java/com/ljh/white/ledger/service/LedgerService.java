package com.ljh.white.ledger.service;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ljh.white.common.collection.WhiteMap;
import com.ljh.white.ledger.mapper.LedgerMapper;


@Service("LedgerService")
public class LedgerService {
	
	@Resource(name = "LedgerMapper")
	private LedgerMapper ledgerMapper;
	
	/**
	 * 해당유저 목적 리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurList(WhiteMap param) {		
		return ledgerMapper.selectPurList(param);		
		
	}	
	/**
	 * 해당유저 상세목적 리스트
	 * @param param
	 * @return
	 */
	public List<WhiteMap> selectPurDtlList(WhiteMap param) {		
		return ledgerMapper.selectPurDtlList(param);
	}
	
	/**
	 * 목적리스트 적용
	 * @param param
	 * @return -1: 반영전 수정할 데이터가 수정하기전에 바뀜, -2:삭제대상이 사용되는 시퀀스. 삭제불가, 1:성공
	 */
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public int applyPurList(WhiteMap param) {
		
		//반영전 수정되었는지 체크
		List<WhiteMap> menuList = param.convertListWhiteMap("purClone", false);
		List<WhiteMap> list = ledgerMapper.selectPurList(param);		
		
		if(menuList.size() != list.size()) {
			return -1;
		}else {
			for(int i=0; i<menuList.size(); i++) {
				if(!menuList.get(i).get("navNm").equals(list.get(i).get("navNm"))) {
					return -1;
				}else if(!menuList.get(i).get("navUrl").equals(list.get(i).get("navUrl"))) {
					return -1;
				}else if(!menuList.get(i).get("navAuthNmSeq").equals(list.get(i).get("navAuthNmSeq"))) {
					return -1;
				}else if(!menuList.get(i).get("navShowYn").equals(list.get(i).get("navShowYn"))) {
					return -1;
				}else if(!menuList.get(i).get("navOrder").equals(list.get(i).get("navOrder"))) {
					return -1;
				}
			}			
		}
		
		menuList = param.convertListWhiteMap("navList", false);		
		List<WhiteMap> deleteList = new ArrayList<WhiteMap>();
		List<WhiteMap> insertList = new ArrayList<WhiteMap>();
		List<WhiteMap> updateList = new ArrayList<WhiteMap>();
		
		for(int i=0; i<menuList.size(); i++) {
			if("delete".equals(menuList.get(i).get("state"))) {
				deleteList.add(menuList.get(i));
			}else if("insert".equals(menuList.get(i).get("state"))) {
				insertList.add(menuList.get(i));
			}else {
				updateList.add(menuList.get(i));
			}
		}
		
		/*if(deleteList.size()>0 && ledgerMapper.selectIsUsedSideUrl(deleteList)>0) {
			return -2;
		}else {
			if(deleteList.size()>0) ledgerMapper.deleteNavMenuList(deleteList);
			if(insertList.size()>0) ledgerMapper.insertNavMenuList(insertList);	
			if(updateList.size()>0) ledgerMapper.updateNavMenuList(updateList);
			return 1;
		}*/
		
		return 0;
	}
}
