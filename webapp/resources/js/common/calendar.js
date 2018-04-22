/**
 * calendar.js
 */

//달력 호출 함수
function whiteCalendar(id, date){
	if(date === "" || date === undefined || date === null){		
		let date = new Date();
		let month = (date.getMonth() + 1);	
		let day = date.getDate();
		month = month < 10 ? '0' + month : '' + month;
		day = day < 10 ? '0' + day : '' + day;		
		return new calendar(id, date.getFullYear()+"-"+month+"-"+day);
	}else{
		return new calendar(id, date);
	}	
}

let calendar = function(id, date){	
	this.target = document.getElementById(id);
	this.date = date;
	this.option = {
		monthTitle : [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
		weekTitle : [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
		dateFormat : "yyyy-mm-dd"
	};
	
	this.calendar = calFn.create();
	
	//this.calendar 
};

let calFn = {
	
	create : function(){
		console.log("calFn.create");
	}
	
		
}
	
	
	/*//날짜 입력란 생성
	let ipt = document.createElement("input");
	ipt.setAttribute("id", target+"-date");
	ipt.setAttribute("name", "date");
	ipt.setAttribute("type", "text");
	ipt.setAttribute("readonly", "readonly");
	ipt.setAttribute("value", date);
	ipt.setAttribute("onclick", "calendarShowHide('"+target+"-calendar');");
	this.target.appendChild(ipt);
	
	//클릭시 캘린더영역 생성	
	let cal = document.createElement("div");
	cal.setAttribute("id", target+"-calendar");
	cal.setAttribute("name", "calendar");
	cal.setAttribute("class", "calendar");
	
	let header = document.createElement("div");
	header.innerHTML = "<span style='float: left;'>title</span><span style='float: right;'>X</span>";
	cal.appendChild(header);
	
	
	
	
	cal.style.display = "none";
	this.target.appendChild(cal);
	
	//캘린더 위치조정
	let offsets = this.target.getBoundingClientRect();
	cal.style.left = offsets.left;
	cal.style.top = offsets.top+40;

	//날짜 수정시 반영하는 함수
	this.dateSet = function(newDate){
		this.target.setAttribute("value", newDate);
	}*/
//}
//숨김 or 표시
/*function calendarShowHide(id){
	let el = document.getElementById(id);	
	if(el.style.display === "none"){
		el.style.display = "";
	}else{
		el.style.display = "none";
	}	
}*/