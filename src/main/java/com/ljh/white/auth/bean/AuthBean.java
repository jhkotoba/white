package com.ljh.white.auth.bean;

import java.io.Serializable;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.ljh.white.exception.NoDataException;

public class AuthBean implements Serializable {
	
	private static final long serialVersionUID = -2972452399043868833L;
	
	private static Logger logger = LogManager.getLogger(AuthBean.class);
	
	private int developer = 0;
	private int administrator = 0;
	private int ledger = 0;
	private int user = 0;

	public AuthBean(List<String> auth) {		
		this.setAuthBean(auth);		
	}
	
	public void setAuthBean(List<String> auth) {	
		
		try {
			
			if(auth==null) {
				throw new NullPointerException();
			}else if(auth.size() < 1){
				throw new NoDataException(auth.size());
			}
			
			this.developer = 0;    
			this.administrator = 0;
			this.ledger = 0;        
			this.user = 0;
			
			for(int i=0; i<auth.size(); i++) {
				switch(auth.get(i)) {
				
				case "developer" : 
					this.developer = 1;
					break;
				case "administrator" : 
					this.administrator = 1;
					break;
				case "ledger" :
					this.ledger = 1;
					break;
				case "user" :
					this.user = 1;
					break;			
				}
			}
			
		}catch(NullPointerException e) {
			logger.error("collection Is NULL");
			e.printStackTrace();
		}catch(NoDataException e) {
			logger.error("collection Size:"+e.getCollectionSize());
			e.printStackTrace();
		}finally {
			logger.debug("\ndeveloper:"+this.getDeveloper()+"\nadministrator:"+this.getAdministrator()+
						 "\nledger:"+this.getLedger()+"\nuser:"+this.getUser());
		}
	}	
	
	public int getDeveloper() {
		return developer;
	}

	public int getAdministrator() {
		return administrator;
	}

	public int getLedger() {
		return ledger;
	}

	public int getUser() {
		return user;
	}
}
