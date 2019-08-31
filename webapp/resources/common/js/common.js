/**
 *  common.js
 */

$(document).ready(function(){	
	//플랫폼 확인
	let filter = "win16|win32|win64|mac|macintel";
	if(navigator.platform){
		if(0 > filter.indexOf(navigator.platform.toLowerCase())){
			common.platform = "mobile";
		}else{
			common.platform = "pc";
		}
	}	
});

//jsGrid 페이징
$(document).on("click", ".jsgrid-pager-page", function(e){	
	$(this).children("a").get(0).click();
});
$(document).on("click", ".jsgrid-pager-nav-button", function(e){	
	$(this).children("a").get(0).click();
});



//금액 입력란 설정
/*$(document).on("keyup", ".only-currency", function(){
	cfnGetNumber(this);
});
$(document).on("change", ".only-currency", function(){
	cfnSetComma(this);
});*/



//리스트 번호 idx 맵핑
function cfnNoIdx(list, noNm){
	let obj = new Object();
	
	if(noNm === undefined){
		for(let i=0; i<list.length; i++){
			obj[list[i].no] = i;
		}
	}else{
		for(let i=0; i<list.length; i++){
			obj[list[i][noNm]] = i;
		}
	}
	return obj;
}

//통화 입력 - 숫제만
/*function cfnGetNumber(obj){	
	let num01;
	let num02;
	num01 = obj.value;
	num02 = num01.replace(/\D/g,"");
	num01 = cfnSetComma(num02);
	obj.value =  num01;
}*/
//통화 입력 - 콤마추가
/*function cfnSetComma(inNum){     
	let outNum;
	outNum = String(inNum); 
	while (/(\d+)(\d{3})/.test(outNum)) {
		outNum = outNum.replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
	}
	return outNum;
}*/
//콤마제거
function cfnRemoveComma(str, isNum){
	if(isNum){
		return Number(str.replace(/,/g,""));
	}else{
		return str.replace(/,/g,"");
	}
}
//마이너스제거
function cfnRemoveMinus(str, isNum){
	if(isNum){
		return Number(str.replace(/-/g,""));
	}else{
		return str.replace(/-/g,"");
	}
}

function cfnRestore(text){
	return text.replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
}

//날짜 계산
function cfnDateCalc(dateString, form, value, patten){
	if(wcm.isDatePattern(dateString, isEmpty(patten) === true ? "yyyy-MM-dd" : patten )){
		if(isNotEmpty(form) && isNotEmpty(value)){
			let date = new Date(dateString).getTime();
			let number = 0;		
			
			switch(form){			
			case "year": 	date += (31557600000*value);	break;
			case "month":	date += (2629800000*value); 	break;				
			case "day":		date += (86400000*value);		break;				
			case "hour":    date += (3600000*value);		break;				
			case "minute":  date += (60000*value); 			break;				
			case "second":  date += (1000*value);			break;				
			default :		return null;
			}
			
			date = new Date(date);
			
			switch(patten){
			default :
			case "yyyy-MM-dd" :
				return date.getFullYear() + "-" + 
					(date.getMonth()+1 < 10 ? "0"+(date.getMonth()+1) : date.getMonth()+1) + "-" + 
					(date.getDate() < 10 ? "0"+date.getDate() : date.getDate());			
			}
			
		}else return null;
	}else return null;
}

//숫자 앞자리 1증가 2번째 자리부터 0으로 초기화
function cfnNumRaise(number){
	if(!isOnlyNum(number)) return null;
	let numStr = String(number);	
	let result = Number(numStr.substring(0, 1));
	result++;	
	for(let i=0; i<numStr.substring(1, numStr.length).length; i++)	result+="0";
	return Number(result);
} 

//날짜반환함수
let isDate = {	
		_dateProcess : function(isMonth, type){	
		
		let date = new Date();		
		let year = date.getFullYear();
		let month = (date.getMonth() + 1);	
		let day = date.getDate();
		
		let isYear = 0;

		if(isNotEmpty(isMonth)){
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
		return this._dateProcess(0, "today");
	},	
	//현재날짜 반환 yyyy-(MM+isMonth)-dd
	addMonToday : function(isMonth){
		return this._dateProcess(isMonth, "today");
	},
	//현재날짜 반환 yyyy-MM-lastDay
	lastDay : function(){                       
		return this._dateProcess(0, "last");
	},
	//현재날짜 반환 yyyy-(MM+isMonth)-lastDay
	addMonLastDay : function(isMonth){                       
		return this._dateProcess(isMonth, "last");
	},
	//현재날짜 반환 yyyy-MM-01
	firstDay : function(){                      
		return this._dateProcess(0, "first");
	},
	//현재날짜 반환 yyyy-(MM+isMonth)-01
	addMonfirstDay : function(isMonth){                      
		return this._dateProcess(isMonth, "first");
	},
	//현재날짜 시간 반환 yyyy-MM-dd hh:mm:ss
	curDate : function(){	
		let date = this._dateProcess(0, "today");
		let time = isTime._timeProcess(0,0,0);
		
		return date + " " + time;
	}
}
//시간반환함수
let isTime = {
	_timeProcess : function(hourData, minuteData, secondData){
		let date = new Date();
		
		let hour = date.getHours() + hourData;
		if(hour<0){
			hour = Math.abs(hour) % 24;			
			hour = date.getHours() + (23 - hour);
		}else if(hour>23){
			hour = hour % 24;
		}
		hour = hour < 10 ? '0' + hour : '' + hour;
		
		let minute = date.getMinutes() + minuteData;
		if(minute<0){
			minute = Math.abs(minute) % 60;			
			minute = date.getMinutes() + (59 - minute);
		}else if(minute>59){
			minute = minute % 60;
		}
		minute = minute < 10 ? '0' + minute : '' + minute;
		
		let second = "";
		if(isNotEmpty(secondData)){
			let second = date.getSeconds() + secondData;
			if(second<0){
				second = Math.abs(second) % 60;			
				second = date.getSeconds() + (59 - second);
			}else if(second>59){
				second = second % 60;
			}
			
			second = second < 10 ? ':0' + second : ':' + second;
		}
		
		return hour+":"+minute+second;
	},
	//현재시간 반환  hh:mm:ss
	curTime : function(){		
		return this._timeProcess(0,0,0);
	},
	//현재시간 반환(시분)  hh:mm
	curTime : function(){		
		return this._timeProcess(0,0);
	},
	//현재시간 반환  (hh+hour):mm:ss
	addCurHour : function(hour){
		isEmpty(hour) ? hour = 0 : hour; 				
		return this._timeProcess(hour,0,0);
	},
	//현재시간 반환  hh:(mm+minute):ss
	addCurMin : function(minute){
		isEmpty(minute) ? minute = 0 : minute; 
		return this._timeProcess(0,minute,0);
	},
	//현재시간 반환  hh:mm:(ss+second)
	addCurSec : function(second){
		isEmpty(second) ? second = 0 : second;  
		return this._timeProcess(0,0,second);
	},
	//현재시간 반환  (hh+hour):(mm+minute):(ss+second)
	addCurHMS : function(hour, minute, second){
		isEmpty(second) ? second = 0 : second;
		isEmpty(minute) ? minute = 0 : minute;
		isEmpty(hour) ? hour = 0 : hour;
		return this._timeProcess(hour,minute,second);
	}	
}

//공통함수
let common = {	
	platform : 'pc',
	platformSize : 500,
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
	comma : function(x){
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
	},
	//문자열 체크해서 (+ - 첫자리 한정) 0 1 2 3 4 5 6 7 8 9 체크 이외 값인경우 false
	isNum : function(number){		
		number = String(number);		
		for(let i=0; i<number.length; i++){
			let ask = number.charCodeAt(i);			
			switch(ask){
			case 48 : case 49 : case 50 : case 51 : case 52 : case 53 : case 54 : case 55 : case 56 : case 57 : 
				break;
			case 43 : case 45 : 
				if(i === 0){					
				}else{
					return false;
				}
				break;	
			default : 
				return false;
			}
		}
		return true;		
	},
	
	//문자열 체크해서 0 1 2 3 4 5 6 7 8 9 체크 이외 값인경우 false
	isOnlyNum : function(number){		
		number = String(number);		
		for(let i=0; i<number.length; i++){
			let ask = number.charCodeAt(i);			
			switch(ask){
			case 48 : case 49 : case 50 : case 51 : case 52 : case 53 : case 54 : case 55 : case 56 : case 57 : 
				break;			
			default : 
				return false;
			}
		}
		return true;
		
	}
}

//비어있는지 체크
function isEmpty(_str){
	return !isNotEmpty(_str);
}

//비어있지 않는지 체크
function isNotEmpty(_str){
	let obj = String(_str);
	if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
	else return true;
}

//영문자, 숫자만 있는지 체크
function isOnlyAlphaNum(_str){
	if(isEmpty(_str)){
		return false;
	}else{
		return /^[A-Za-z0-9+]*$/.test(String(_str).replace(/\s/gi, ""));
	}
}

//URL 체크
function isOnlyOneURL(_str){	
	if(isEmpty(_str)){
		return false;
	}else{
		if(_str.indexOf("/") !== 0){
			return false;
		}else{
			return /^[A-Za-z0-9+]*$/.test(String(_str.split("/")[1]).replace(/\s/gi, ""));
		}
	}
}
//한글, 영문자, 숫자, 가로만 있는지 체크
function isOnlyHanAlphaNum(_str){
	if(isEmpty(_str)){
		return false;
	}else{
		return /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|()]+$/.test(String(_str).replace(/\s/gi, ""));
	}
}


//특수문자가 있는지 체크
function isSpChar(_str){	
	return /[~!@\#$%<>^&*\()\-=+_\’]/gi.test(String(_str));
}

//숫자, 하이픈만 있는지 체크
function isOnlyNumHyphen(_str){
	if(isEmpty(_str)){
		return false;
	}else{
		return /^[0-9|-]+$/.test(String(_str));
	}
}

//숫자만 있는지 체크
function isOnlyNum(_str){
	if(isEmpty(_str)){
		return false;
	}else{
		return /^[0-9|]+$/.test(String(_str));
	}
}

function cfnGetContextPath(){
	return getContextPath();
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

//moveForm
let mf = {	
	 submit : function(navUrl, sideUrl, navNm, sideNm, param){
		$("#moveForm #navUrl").attr("value", navUrl);
		$("#moveForm #sideUrl").attr("value", sideUrl);		
		$("#moveForm #navNm").attr("value", navNm);
		$("#moveForm #sideNm").attr("value", sideNm);
		if(isNotEmpty(param)) $("#moveForm #param").attr("value", param);		
		
		$("#moveForm").attr("method", "post");
		$("#moveForm").attr("action", common.path()+navUrl).submit();
	}
}

//공통함수
const wcm = {
	//########################### 빈값, null, undefined, 값타입 체크  ###########################
	//비어있는지 체크 후 비어있으면 ""반환, 비어있지않으면 대상값 반환
	isEmptyRtn : function(_str){
		if(this.isNotEmpty(_str)){
			return _str;
		}else{
			return "";
		}
	},
	//비어있는지 체크
	isEmpty : function(_str){
		return !this.isNotEmpty(_str);
	},
	//비어있지 않는지 체크
	isNotEmpty : function(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	},	
	//########################### 날짜 조회, 계산, 편집, 체크 ###########################
	//오늘날짜 반환
	getToday : function(){
		let date = new Date();		
		let month = (date.getMonth() + 1);	
		let day = date.getDate();
		month = month < 10 ? "0" + month : "" + month;
		day = day < 10 ? "0" + day : "" + day;
		return date.getFullYear() + "-" + month + "-" + day;
	},
	//올해 이번달 첫날 반환
	getToMonthFirstDay : function(){
		let date = new Date();
		let month = (date.getMonth() + 1);		
		month = month < 10 ? "0" + month : "" + month;		
		return date.getFullYear() + "-" + month + "-01";
	},
	//올해 이번달 마지막 날 반환
	getToMonthLastDay : function(){
		let date = new Date();
		let year = date.getFullYear();
		let month = (date.getMonth() + 1);		
		month = month < 10 ? "0" + month : "" + month;		
		let lastDay = new Date(year, month, 0).getDate();	
		return year + "-" + month + "-" + lastDay;	
	},
	//날짜 형식 체크 ex) 2019-01-01 08:00	
	isDatePattern : function(date, patten){
		try{			
			let datePattern = null;
			
			if(this.isEmpty(patten)){
				patten = "YYYY-MM-DD";
			}
			
			switch(patten.toUpperCase()){
			case "YYYY-MM-DD":	
				datePattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;	
				break;
			case "YYYY-MM-DD HH:MM":
				datePattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/;
				break;	
			case "YYYY-MM-DD HH:MM:SS":
				datePattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])$/;	
				break;
			}
			
			if(datePattern.test(date)){				
				let checkDate = date.replace(/[^0-9]/g,"");
				
				if(isNaN(checkDate) || checkDate.length < 8){
					return false;
				}
				
				let year = Number(checkDate.substring(0, 4));
				let month = Number(checkDate.substring(4, 6));
				let day = Number(checkDate.substring(6, 8));
		         
		        if(month < 1 || month > 12 ) {
		            return false;
		        }
		         
		        var lastDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		        var maxDay = lastDays[month-1];		         
		        
		        if(month === 2 && (year % 4 === 0 && year % 100 !== 0 || year % 400 ===0)){
		            maxDay = 29;
		        }
		         
		        if(day <= 0 || day > maxDay){
		            return false;
		        }
		        return true;
			}else{
				return false;
			}
		}catch(err){			
	        return false;
	    }
	},	
	//########################### 문자열 편집, 계산, 체크 ###########################		
	//문자열의 해당인덱스 삭제
	strIdxSlice : function(str, index){
		let string = String(str);
		return string.slice(0, index) + string.slice(index+1);		
	},
	//콤마 자리수 추가
	setComma : function(x){
		if(this.isEmpty(x)){
			return x;
		}else{
			return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
	},
	//콤마 삭제
	removeComma : function(str){
		return String(str).replace(/,/g,"");
	},
	//########################### 비동기 통신 ###########################
	//변수 초기화
	xhttpClear : function(){
		this.url = null; this.data = null; this.async = true; this.dataType = "JSON";
	},
	//비동기 통신 데이터
	xhttpData : {
		url : "", data : null, async : true, dataType : "JSON"
	},
	//비동기 통신
	xhttp : function(option, callback){
		if(option === null || option === undefined) return;		
		
		//값 초기화
		this.xhttpClear();
		
		//XMLHttpRequest 선언
		let xhr = new XMLHttpRequest();		
		
		//url값
	    let offset = location.href.indexOf(location.host)+location.host.length;
	    
	    if(typeof option === "string"){
	    	this.xhttpData.url = location.href.substring(offset,location.href.indexOf('/',offset+1)) + option;
	    }else{
	    	this.xhttpData.url = location.href.substring(offset,location.href.indexOf('/',offset+1)) + option.url;
			if(option.async === null || option.async === undefined || option.async === ""){
				this.xhttpData.async = true;
			}else{
				this.xhttpData.async = option.async;
			}
			//반환값 타입
			if(option.dataType === null || option.dataType === undefined || option.dataType === ""){
				this.xhttpData.dataType = "JSON";
			}else{
				this.xhttpData.dataType = option.dataType.toUpperCase();
			}
			//데이터 저장
			this.xhttpData.data = option.data;
	    }
		
		//XMLHttpRequest open
		xhr.open("POST", this.xhttpData.url, this.xhttpData.async);
		
		//readyState 호출함수 정의
		xhr.onreadystatechange = () => {
			if (xhr.readyState == 4) {
				if (xhr.status == 200) {					
					if(xhr.responseText !== null && xhr.responseText !== undefined && xhr.responseText !== ""){
						//반환 타입
						switch(this.dataType){
						default :					
						case "TEXT": callback(xhr.responseText); break;
						case "JSON": callback(JSON.parse(xhr.responseText)); break;
						}
					}					
				}else{
					alert("xhr.status:"+xhr.status);
				}
			}
			return this;
		}		
		
		//전송할 데이터 가공
		if(this.xhttpData.data === null || this.xhttpData.data === undefined || this.xhttpData.data === ""){
			xhr.send();	
		}else{
			let formData = new FormData();			
			let keys = Object.keys(this.xhttpData.data);			
			for(let i=0; i<keys.length; i++){				
				formData.append(keys[i], String(this.xhttpData.data[keys[i]]));
			}			
			xhr.send(formData);	
		}
	},
	
	//########################### 공통 코드 조회 ###########################
	//공통코드 조회
	getCode : function(codePrt, callback){		
		let param = {};
		param.dataType = null;		
		
		switch(typeof codePrt){		
		case "number" :
			param.codePrt = String(codePrt);
			param.dataType = "string";
			break;
		case "string" :			
			param.codePrt = codePrt;
			param.dataType = "string";
			break;
		case "object" :
			if(codePrt.length === undefined){
				param.codePrt = codePrt;
				param.dataType = "object";
			}else if(typeof codePrt.length === "number"){
				param.codePrt = JSON.stringify(codePrt);
				param.dataType = "array";
			}
			break;
		}
		if(param.dataType === null){
			console.log("data type: number, string, array OK");
			return;
		}else{
			this.xhttp({
				url : "/white/selectCodeList.ajax",
				data : param,
				blind : false,
			}, function(result){
				if(param.dataType === "string"){
					callback(result.codePrt);
				}else{
					callback(result);
				}				
			});
		}
		
	},
	//공통코드 조회후 셀렉트박스 생성	
	createCode : function(targetId, codePrt, first, callback){
		this.getCode(codePrt, list => {
			let select = document.getElementById(targetId);
			//첫번째 option 선택 or 전체 설정
			if(first !== null && first !== undefined && first !== ""){
				switch(first.toUpperCase()){
				case "ALL":
					option = document.createElement("option");
					option.value = "";
					option.textContent = "전체";
					select.appendChild(option);
					break;
				case "SELECT":
					option = document.createElement("option");
					option.value = "";
					option.textContent = "선택";
					select.appendChild(option);
					break;
				}
			}			
			if(select !== null && select.tagName === "SELECT"){				
				let option = null;
				for(let i=0; i<list.length; i++){
					option = document.createElement("option");
					option.value = list[i].code;
					option.textContent = list[i].codeNm;
					select.appendChild(option);		
				}
			}
			if(typeof callback === "function"){
				callback(this);
			}
			
		});
	},
	//공통코드 조회후 셀렉트박스 생성(복수)
	createCodes : function(pList, callback){
		//object로 오면 배열로 만들기
		if(typeof pList === "object" && pList.length === undefined){
			pList = new Array(pList);
		}
		
		//서버가 읽도록 가공
		let cList = new Array();
		for(let i=0; i<pList.length; i++){				
			cList.push(pList[i].prtCode);
		}
		
		let option, select, list = null;
		this.getCode(cList, res => {
			pList.forEach(code => {				
				select = document.getElementById(code.targetId);				
				if(select !== null && select.tagName === "SELECT"){
					list = res[code.prtCode];
					
					//첫번째 option 선택 or 전체 설정
					if(code.first !== null && code.first !== undefined && code.first !== ""){
						switch(code.first.toUpperCase()){
						case "ALL":
							option = document.createElement("option");
							option.value = "";
							option.textContent = "전체";
							select.appendChild(option);
							break;
						case "SELECT":
							option = document.createElement("option");
							option.value = "";
							option.textContent = "선택";
							select.appendChild(option);
							break;
						}
					}					
					//select option list 생성
					for(let i=0; i<list.length; i++){
						option = document.createElement("option");
						option.value = list[i].code;
						option.textContent = list[i].codeNm;
						select.appendChild(option);								
					}
				}
			});
			if(typeof callback === "function"){
				callback(this);
			}
		});		
	}
}