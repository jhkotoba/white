package com.ljh.white.exception;

public class NoDataException extends Exception{

	private static final long serialVersionUID = -6571206646082912257L;
	private int collectionSize = 0;
	
	public NoDataException(int collectionSize) {
		this.collectionSize = collectionSize;
	}

	public int getCollectionSize() {
		return collectionSize;
	}
	
}
