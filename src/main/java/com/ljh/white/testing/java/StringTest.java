package com.ljh.white.testing.java;

public class StringTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		String test = "___<___>___&___,___";
		test = test.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll(",","&quot;");
		System.out.println(test);
	}

}
