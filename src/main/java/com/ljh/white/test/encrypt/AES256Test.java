package com.ljh.white.test.encrypt;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import com.ljh.white.common.utility.cryptolect.AES256Util;

public class AES256Test {

	public static void main(String[] args) throws UnsupportedEncodingException {
		AES256Util aes = new AES256Util("1234567890123456");
		try {
			String enc = aes.aesEncode("1234");
			System.out.println("enc:"+enc);
			
			String dec = aes.aesDecode(enc);
			System.out.println("dec:"+dec);
		} catch (InvalidKeyException | NoSuchAlgorithmException | NoSuchPaddingException
				| InvalidAlgorithmParameterException | IllegalBlockSizeException | BadPaddingException e) {			
			e.printStackTrace();
		}

	}

}
