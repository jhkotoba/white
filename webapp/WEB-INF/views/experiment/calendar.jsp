<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.calendar{position:absolute; height: 200px; width:200px; border: 1px solid #dee2e6; background: white;}
</style>

<script type="text/javascript">
window.onload = function(){
	
	let cal1 = whiteCalendar("searchDate1");
	let cal2 = whiteCalendar("searchDate2");
	let cal3 = whiteCalendar("searchDate3");
	let cal4 = whiteCalendar("searchDate4");
	
	//document.getElementsByClassName('calendar').onclick = function(){
	//alert("AAAA");
		//document.getElementsByClassName('calendar').style.display = "none";
	//}
	
};





//달력 호출 함수
function whiteCalendar(target, date){
	if(date === "" || date === undefined || date === null){		
		let date = new Date();
		let month = (date.getMonth() + 1);	
		let day = date.getDate();
		month = month < 10 ? '0' + month : '' + month;
		day = day < 10 ? '0' + day : '' + day;		
		return new calendar(target, date.getFullYear()+"-"+month+"-"+day);
	}else{
		return new calendar(target, date);
	}	
}

//calendar
let calendar = function(target, date){	
	this.target = document.getElementById(target);
	this.dateText = date;
	this.option = {
		monthTitle : [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" ],
		weekTitle : [ "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
		dateFormat : "yyyy-mm-dd"
	};
	
	//날짜 입력란 생성
	let ipt = document.createElement("input");
	ipt.setAttribute("id", target+"-date");
	ipt.setAttribute("type", "text");
	ipt.setAttribute("readonly", "readonly");
	ipt.setAttribute("value", this.dateText);
	ipt.setAttribute("onclick", "calendarShowHide('"+target+"-calendar');");
	this.target.appendChild(ipt);
	
	//클릭시 캘린더영역 생성	
	let cal = document.createElement("div");
	cal.setAttribute("id", target+"-calendar");
	cal.setAttribute("name", "calendar");
	cal.setAttribute("class", "calendar");
	cal.style.display = "none";
	this.target.appendChild(cal);
	
	//캘린더 위치조정
	let offsets = this.target.getBoundingClientRect();
	cal.style.left = offsets.left;
	cal.style.top = offsets.top+40;

	//날짜 수정시 반영하는 함수
	this.dateSet = function(){
		this.target.setAttribute("value", this.dateText);
	}
}
//숨김 or 표시
function calendarShowHide(id){
	let el = document.getElementById(id);	
	if(el.style.display === "none"){
		el.style.display = "";
	}else{
		el.style.display = "none";
	}	
}

</script>

<div class="article">
	<div id="searchDate1">	
	</div>
	<br><br>
	
	<div id="searchDate2">	
	</div>
	<br><br>
	
	<table border="1">
		<tr>
			<th>Test</th>
		</tr>
		<tr>
			<td>
				<div id="searchDate3">	
			</td>
		</tr>
	</table>
	<br><br>
	
	<div id="searchDate4">	
	<br><br>
</div>

