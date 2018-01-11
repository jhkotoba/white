package com.ljh.white.testing.java;

import java.util.ArrayList;

import java.io.Serializable;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ljh.white.auth.bean.AuthBean;




public class AuthBeanTest {

	public static void main(String[] args){
		
		List<String> list = new ArrayList<String>();
		list.add("developer");
		
		System.out.println("AuthBean TEST1");		
		AuthBean auth = new AuthBean(list);
		
		
		System.out.println("\nAuthBean TEST2");		
		AuthBean auth2 = new AuthBean(null);
	}

}

