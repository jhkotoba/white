<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>
<script type="text/javascript">

$(document).ready(function(){			
	$("#sideMenu>ul>li").click(function(){
		
		if(this.id === "setup"){
			let taget = $("#"+this.id+">ol");
			if(taget.css("display")==="none"){
				taget.show();
			}else{
				taget.hide();
			}
		}else{
			sideSubmit(this.id);
		}		
	});
	
	$("#sideMenu>ul>li>ol>li").click(function(){
		sideSubmit(this.id);
	});
});

function sideSubmit(id){	
	$("#moveForm #move").attr("value", id);	
	$("#moveForm").attr("method", "post");
	$("#moveForm").attr("action", common.path()+"/ledgerRe/ledgerReMain.do").submit();
}

</script>
</head>
<body>
	<form id="moveForm" action="">
		<input id="move" name="move" type="hidden" value=""></input>
	</form>	
	
	<div id="sideMenu" class="sideMenu">		
		<ul>
			<li id="main">메인</li>
			<li id="select">조회</li>
			<li id="insert">입력</li>
			<li id="stats">통계</li>
			<li id="setup">설정</a>				
				<ol style="display: none">			
					<li id="purpose">목적설정</li>
					<li id="bank">은행설정</li>										
				</ol>
			</li>					
		</ul>		
	</div>	
</body>
