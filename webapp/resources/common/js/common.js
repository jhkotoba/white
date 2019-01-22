/**
 *  common.js
 */
$(document).ready(function(){
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

//ajax 셋업
$.ajaxSetup({
	type: "post",
	dataType: "json",
	async : true,
	error : function(request, status, error){
		if(request.status === 488){
			alert("세션이 만료되었습니다. 로그인 해주세요.");
			location.href = getContextPath()+"/main";
		}else{			
			alert("통신에 실패하였습니다.");
			let deferred = $.Deferred();
			deferred.reject({"request":request, "status":status, "error":status});			
		}
    }
});

//ajax 시작할때 실행되는 영역
$(document).ajaxSend(function() {
	 $(".blind").show(100);
});

//ajax 성공하면 실행되는 영역
$(document).ajaxComplete(function() {
	$(".blind").hide(400);
});

//금액 입력란 설정
$(document).on("keyup", ".only-currency", function(){
	cfnGetNumber(this);
});
$(document).on("change", ".only-currency", function(){
	cfnSetComma(this);
});

//form clear
$.fn.clear = function() {
	return this.each(function() {
		let type = this.type, tag = this.tagName.toLowerCase();
		if (tag === 'form'){
			return $(':input',this).clear();
		}
		if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
			this.value = '';
		}else if (type === 'checkbox' || type === 'radio'){
			this.checked = false;
			this.value = '';
		}else if (tag === 'select'){
			this.selectedIndex = 0;
		}else if(tag === "span"){
			$(this).text("");
		}else if(tag === "label"){
			$(this).text("");
		}
		$(this).removeData();
    });
};

//form getParam
$.fn.getParam = function() {
	let param = {};	
	this.find("*").each(function(){
		if(this.value !== undefined){
			let type = this.type, tag = this.tagName.toLowerCase();			
			if(type === "text" || type === "password" || type === "hidden" || tag === "textarea"){
				param[this.id] = this.value;
			}else if(tag === "select"){
				param[this.id] = this.value;
			}else if (type === 'checkbox'){
				
			}else if(type === 'radio'){
				
			}
		}		
	});
	return param;	
};

//form setParam
$.fn.setParam = function(param){
	this.find("*").each(function(){
		if(param[this.id] !== undefined){
			let type = this.type, tag = this.tagName.toLowerCase();
			if(type === "text" || type === "password" || type === "hidden" || tag === "textarea"){
				this.value = param[this.id];
			}else if(tag === "select"){
				$(this).val(param[this.id]).prop("selected", true);			
			}else if (type === 'checkbox'){
				$(this).prop("checked", true).val(param[this.id]);
			}else if(type === 'radio'){				
			
			}else if(tag === "span"){
				$(this).text(param[this.id]);
			}else if(tag === "label"){
				$(this).text(param[this.id]);
			}
		}		
	});
	return this;
}

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

//ajax 코드 조회
function cfnSelectCode(codePrt){
	return cfnCmmAjax("/white/selectCodeList", {"codePrt" : codePrt});	
}

//ajax 권한 리스트 조회 - no(유저번호) 없으면 전체 조회
function cfnSelectAuth(no, async){
	if(isEmpty(no)){
		return cfnCmmAjax("/admin/selectAuthList");	
	}else{
		return cfnCmmAjax("/admin/selectUserAuth", {"no" : no});	
	}
}

//ajax 공통
function cfnCmmAjax(url, param, isGrid){
	let deferred = $.Deferred();
	$.ajax({
		url: getContextPath()+url+".ajax",
		data : isEmpty(param) === true ? null : param,
	    success : function(data) {
	    	if(isGrid === true) deferred.resolve({data: data.list, itemsCount: data.itemsCount});
	    	else deferred.resolve(data);
	    }	    
	});		
	return deferred.promise();
}

//동기 ajax
function cfnCmmSyncAjax(url, param){
	let result = null;
	$.ajax({
		url: getContextPath()+url+".ajax",
		async : false,
		data : isEmpty(param) === true ? null : param,
	    success : function(data) {
	    	result = data;
	    }
	});
	return result;
}

//통화 입력 - 숫제만
function cfnGetNumber(obj){	
	let num01;
	let num02;
	num01 = obj.value;
	num02 = num01.replace(/\D/g,"");
	num01 = cfnSetComma(num02);
	obj.value =  num01;
}
//통화 입력 - 콤마추가
function cfnSetComma(inNum){     
	let outNum;
	outNum = String(inNum); 
	while (/(\d+)(\d{3})/.test(outNum)) {
		outNum = outNum.replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
	}
	return outNum;
}

//날짜반환함수
let isDate = {	
	dateProcess : function dateProcess(isMonth, type){	
		
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
		return this.timeProcess(0,0,0);
	},
	//현재시간 반환(시분)  hh:mm
	curTime : function(){		
		return this.timeProcess(0,0);
	},
	//현재시간 반환  (hh+hour):mm:ss
	addCurHour : function(hour){
		isEmpty(hour) ? hour = 0 : hour; 				
		return this.timeProcess(hour,0,0);
	},
	//현재시간 반환  hh:(mm+minute):ss
	addCurMin : function(minute){
		isEmpty(minute) ? minute = 0 : minute; 
		return this.timeProcess(0,minute,0);
	},
	//현재시간 반환  hh:mm:(ss+second)
	addCurSec : function(second){
		isEmpty(second) ? second = 0 : second;  
		return this.timeProcess(0,0,second);
	},
	//현재시간 반환  (hh+hour):(mm+minute):(ss+second)
	addCurHMS : function(hour, minute, second){
		isEmpty(second) ? second = 0 : second;
		isEmpty(minute) ? minute = 0 : minute;
		isEmpty(hour) ? hour = 0 : hour;
		return this.timeProcess(hour,minute,second);
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

//날짜 형식 체크 ex) 2019-01-01 08:00
function isRecordDatePattern(date, patten){
	let date_pattern = null;
	switch(patten){	
	case "time":
		date_pattern = /^([1-9]|[01][0-9]|2[0-3]):([0-5][0-9])$/;
		break;		
	case "datetime":
		date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1]) (0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/;
		break;	
	case "date" :
	default :
		date_pattern = /^(19|20)\d{2}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[0-1])$/;	
		break;
	}
	return date_pattern.test(date);
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