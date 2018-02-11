package com.ljh.white.experiment.java;

import java.util.ArrayList;
import java.util.List;

public class ListAddAllTest {

	public static void main(String[] args) {
		
		
		List<testVo> list = new ArrayList<testVo>();
		list.add(new testVo("test1"));
		list.add(new testVo("test2"));
		list.add(new testVo("test3"));
		
		System.out.println("list");
		for(int i=0; i<list.size(); i++) {
			System.out.println(list.get(i).getTest());
		}
		System.out.println("");
		//default
		
		//addAll TEST
		System.out.println("listCopy");
		List<testVo> listCopy = new ArrayList<testVo>();
		listCopy.addAll(list);		
		for(int i=0; i<listCopy.size(); i++) {
			System.out.println(listCopy.get(i).getTest());
		}
		System.out.println("");
		//result:addAll() OK
		
		//empty ?
		System.out.println("listCopyEmpty");
		List<testVo> listCopyEmpty = new ArrayList<testVo>();
		listCopy.addAll(listCopyEmpty);		
		for(int i=0; i<listCopyEmpty.size(); i++) {
			System.out.println(listCopyEmpty.get(i).getTest());
		}
		System.out.println("");
		//result:addAll() OK
		
		//NULL ?
		System.out.println("listCopyNull");
		List<testVo> listCopyNull = new ArrayList<testVo>();
		listCopy.addAll(null);		
		for(int i=0; i<listCopyNull.size(); i++) {
			System.out.println(listCopyNull.get(i).getTest());
		}
		System.out.println("");
		//result:addAll Error java.lang.NullPointerException
		
	}

}


class testVo{
	private String test;
	
	public testVo(String test) {
		this.setTest(test);
	}
	public String getTest() {
		return test;
	}
	public void setTest(String test) {
		this.test = test;
	}
	@Override
	public String toString() {
		return "testVo [test=" + test + "]";
	}
	
}