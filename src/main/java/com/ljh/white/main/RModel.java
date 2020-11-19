package com.ljh.white.main;

import java.util.List;
import java.util.Map;

public class RModel {

	private String test1;
	private Map<String, Object> test2;
	private List<String> test3;
	
	public String getTest1() {
		return test1;
	}
	public void setTest1(String test1) {
		this.test1 = test1;
	}
	public Map<String, Object> getTest2() {
		return test2;
	}
	public void setTest2(Map<String, Object> test2) {
		this.test2 = test2;
	}
	public List<String> getTest3() {
		return test3;
	}
	public void setTest3(List<String> test3) {
		this.test3 = test3;
	}
	@Override
	public String toString() {
		return "RModel [test1=" + test1 + ", test2=" + test2 + ", test3=" + test3 + "]";
	}	
}
