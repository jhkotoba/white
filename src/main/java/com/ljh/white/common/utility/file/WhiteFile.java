package com.ljh.white.common.utility.file;

import java.io.File;

import com.ljh.white.common.collection.WhiteMap;

public class WhiteFile {
	
	/* 폴더 생성 */
	public static boolean createFolder(WhiteMap whiteMap){		
	
		File file = new File(whiteMap.get("filePath").toString());
		
		if(file.exists()){
			return false;
		}else{
			file.mkdirs();
			return true;
		}
	}
}




