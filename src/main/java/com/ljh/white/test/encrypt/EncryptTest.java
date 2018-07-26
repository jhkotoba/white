package com.ljh.white.test.encrypt;

import com.ljh.white.common.utility.cryptolect.BCrypt;

public class EncryptTest {

	public static void main(String[] args) {
		
		String str = "1111";
		String encrypt = BCrypt.hashpw(str, BCrypt.gensalt());
		System.out.println(encrypt);
	}

}
