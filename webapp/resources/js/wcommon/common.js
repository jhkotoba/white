/**
 *  common.js
 */

$(document).ready(function(){
	
	//뒤로가기 방지
	history.pushState(null, null, location.href);
	window.onpopstate = function(event) {
		history.go(1);
	};
});

//삭제
/*let typeCode = {
	LEDGER_BACKUP_UPLOAD : "8001",
	LEDGER_BACKUP_DOWNLOAD : "8002",
		
		
		
}*/

//비어있는지 체크
let emptyCheck = {
	//데이터가 있으면 true 데이터가 없으면 false
	isNotEmpty : function(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	},
	//데이터가 있으면 false 데이터가 없으면 true
	isEmpty : function(_str){
		return !emptyCheck.isNotEmpty(_str);
	}
}

//날짜반환함수
let isDate = {	
	dateProcess : function dateProcess(isMonth, type){	
		
		let date = new Date();		
		let year = date.getFullYear();
		let month = (date.getMonth() + 1);	
		let day = date.getDate();
		
		let isYear = 0;

		if(emptyCheck.isNotEmpty(isMonth)){
			isYear = parseInt(isMonth/12);
			isMonth = isMonth%12;
			
			year = year + isYear;
			month = month + isMonth;
			
			if(month < 1){
				year = year - 1;
				month = 12 - Math.abs(month);				
			}
		}	
		
		if(year < 0) year = "0001";
		else if(year < 10) year = "0" + year;
		else if(year < 100) year = "00" + year;
		else year = String(year);
			
		month = month < 10 ? '0' + month : '' + month;
		day = day < 10 ? '0' + day : '' + day;				
				
		switch(type){
		case "today" : 
			return year + "-" + month + "-" + day;
			
		case "first" : 
			return year + "-" + month + "-01";
			
		case "last" : 
			let lastDay = new Date(year, month, 0).getDate();	
			return year + "-" + month + "-" + lastDay;
		}
	},
	//현재날짜 반환 yyyy-MM-dd
	today : function(){
		return this.dateProcess(0, "today");
	},
	//현재날짜 반환 yyyy-MM-(dd+day)
	/*todayAddDay : function(isDay){
		
	},*/
	//현재날짜 반환 yyyy-(MM+isMonth)-dd
	addMonToday : function(isMonth){
		return this.dateProcess(isMonth, "today");
	},
	//현재날짜 반환 yyyy-MM-lastDay
	lastDay : function(){                       
		return this.dateProcess(0, "last");
	},
	//현재날짜 반환 yyyy-(MM+isMonth)-lastDay
	addMonLastDay : function(isMonth){                       
		return this.dateProcess(isMonth, "last");
	},
	//현재날짜 반환 yyyy-MM-01
	firstDay : function(){                      
		return this.dateProcess(0, "first");
	},
	//현재날짜 반환 yyyy-(MM+isMonth)-01
	addMonfirstDay : function(isMonth){                      
		return this.dateProcess(isMonth, "first");
	},
	//현재날짜 시간 반환 yyyy-MM-dd hh:mm:ss
	curDate : function(){	
		let date = this.dateProcess(0, "today");
		let time = isTime.timeProcess(0,0,0);
		
		return date + " " + time;
	}
}
//시간반환함수
let isTime = {
	timeProcess : function timeProcess(hourData, minuteData, secondData){
		let date = new Date();
		
		let hour = date.getHours() + hourData;
		let minute = date.getMinutes() + minuteData;
		let second = date.getSeconds() + secondData;
			
		if(hour<0){
			hour = Math.abs(hour) % 24;			
			hour = date.getHours() + (23 - hour);
		}else if(hour>23){
			hour = hour % 24;
		}	
		
		if(minute<0){
			minute = Math.abs(minute) % 60;			
			minute = date.getMinutes() + (59 - minute);
		}else if(minute>59){
			minute = minute % 60;
		}
		
		if(second<0){
			second = Math.abs(second) % 60;			
			second = date.getSeconds() + (59 - second);
		}else if(second>59){
			second = second % 60;
		}
		
		hour = hour < 10 ? '0' + hour : '' + hour;
		minute = minute < 10 ? '0' + minute : '' + minute;
		second = second < 10 ? '0' + second : '' + second;
		
		return hour+":"+minute+":"+second;
	},
	//현재시간 반환  hh:mm:ss
	curTime : function(){		
		return this.timeProcess(0,0,0);
	},
	//현재시간 반환  (hh+hour):mm:ss
	addCurHour : function(hour){
		emptyCheck.isEmpty(hour) ? hour = 0 : hour; 				
		return this.timeProcess(hour,0,0);
	},
	//현재시간 반환  hh:(mm+minute):ss
	addCurMin : function(minute){
		emptyCheck.isEmpty(minute) ? minute = 0 : minute; 
		return this.timeProcess(0,minute,0);
	},
	//현재시간 반환  hh:mm:(ss+second)
	addCurSec : function(second){
		emptyCheck.isEmpty(second) ? second = 0 : second;  
		return this.timeProcess(0,0,second);
	},
	//현재시간 반환  (hh+hour):(mm+minute):(ss+second)
	addCurHMS : function(hour, minute, second){
		emptyCheck.isEmpty(second) ? second = 0 : second;
		emptyCheck.isEmpty(minute) ? minute = 0 : minute;
		emptyCheck.isEmpty(hour) ? hour = 0 : hour;
		return this.timeProcess(hour,minute,second);
	}	
}

//공통함수
let common = {
	//깊은복사
	clone : function deepObjCopy (dupeObj) {
		var retObj = new Object();
		if (typeof(dupeObj) == 'object') {
			if (typeof(dupeObj.length) != 'undefined')
				var retObj = new Array();
			for (var objInd in dupeObj) {	
				if (typeof(dupeObj[objInd]) == 'object') {
					retObj[objInd] = deepObjCopy(dupeObj[objInd]);
				} else if (typeof(dupeObj[objInd]) == 'string') {
					retObj[objInd] = dupeObj[objInd];
				} else if (typeof(dupeObj[objInd]) == 'number') {
					retObj[objInd] = dupeObj[objInd];
				} else if (typeof(dupeObj[objInd]) == 'boolean') {
					((dupeObj[objInd] == true) ? retObj[objInd] = true : retObj[objInd] = false);
				}
			}
		}
		return retObj;
	},
	//프로젝트 path
	path : function(){
		let offset = location.href.indexOf(location.host)+location.host.length;
	    let ctxPath = location.href.substring(offset,location.href.indexOf('/',offset+1));
	    return ctxPath;
	},
	//콤마 자리수 추가
	numSetComma : function(x){
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	},
	//String("data1,data2,data3") 이나 배열(["data1","data2","data3"])로 받아서 일괄 show
	allShow : function(showArr){
		if(typeof(showArr)==="string")
			showArr = showArr.split(",");
		for(let i=0; i<showArr.length; i++)			
			$("#"+showArr[i]).show();
	},
	//String("data1,data2,data3") 이나 배열(["data1","data2","data3"])로 받아서 일괄 hide 
	allHide : function(hideArr){
		if(typeof(hideArr)==="string")
			hideArr = hideArr.split(",");
		for(let i=0; i<hideArr.length; i++)			
			$("#"+hideArr[i]).show();
	}
}

//문자열 관련
let str = {
	//첫번째 글자를 대문자
	firstUpper : function(str){
		return str.charAt(0).toUpperCase() + str.slice(1);
	},
	//앞뒤 공백삭제
	trim : function(str){
		return str.replace(/^\s+|\s+$/g,"");
	},
	//전체 공백삭제
	trimAll : function(str){
		return str.replace(/\s/gi, "");
	}
}

function getContextPath(){
    let offset = location.href.indexOf(location.host)+location.host.length;
    let ctxPath = location.href.substring(offset,location.href.indexOf('/',offset+1));
    return ctxPath;
}

//숫자 앞 0 추가 함수 n원본 , digits 추가할 0의 개수
/*function leadingZeros(n, digits) {
	var zero = '';
	n = n.toString();

	if (n.length < digits) {
		for (var i = 0; i < digits - n.length; i++)
		zero += '0';
	}
	return zero + n;
}*/
