package com.ljh.white.common.service;

public interface WhiteService {
	
	
	/**
	 * 입력된 테이블, 컬럼, 데이터로 해당 데이터의 갯수를 구함
	 * @param table, column, data	
	 * @return count
	 * @date 2017.10.24
	 */
	public int isCntColumn(String table, String column, String data);
	
	
	
}
