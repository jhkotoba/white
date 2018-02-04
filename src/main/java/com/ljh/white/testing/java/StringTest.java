package com.ljh.white.testing.java;

public class StringTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		String test1 = "___<___>___&___,___";
		test1 = test1.replaceAll("&","&amp;").replaceAll("<","&lt;").replaceAll(">","&gt;").replaceAll(",","&quot;");
		System.out.println(test1);		
		//before: ___<___>___&___,___
		//after:___&lt;___&gt;___&amp;___&quot;___
		
		String test2 = "---\"----";
		System.out.println(test2);
		test2 = test2.replaceAll("\"","");
		System.out.println(test2);		
		//before:---"----
		//after:-------
		
		
		
	}

}
