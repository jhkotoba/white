package com.ljh.white.experiment.java;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MilSecTest {

	
	public static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

	public static void main(String[] args) throws ParseException, InterruptedException {
				
		SimpleDateFormat simpleToday = new SimpleDateFormat ( "yyyy-MM-dd");
		Date currentTime = new Date ( );
		String today = simpleToday.format ( currentTime );
		String exitTime = "18:30:00";
		
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");		
		
		long goal = simpleDateFormat.parse(today+" "+exitTime).getTime();
		long nowMil = 0;			
		
		while(true){
			nowMil = System.currentTimeMillis();	
			if(goal>nowMil){
				System.out.println(goal-nowMil);
				Thread.sleep(1);
				
			}else{
				break;
			}		
			
		}
	}
}
