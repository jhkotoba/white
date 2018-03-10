<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC>
<head>
<meta charset=UTF-8>
<title>WhiteHome</title>
<script type="text/javascript">

$(document).ready(function(){			
	$("#sideMenu>ul>li").click(function(){
		
		if(this.id === "Setup"){
			let taget = $("#"+this.id+">ol");
			if(taget.css("display")==="none"){
				taget.show();
			}else{
				taget.hide();
			}
		}else{
			white.sideSubmit("ledgerRe", this.id);
		}		
	});
	
	$("#sideMenu>ul>li>ol>li").click(function(){
		white.sideSubmit("ledgerRe", this.id);
	});
});

</script>
</head>
<body>
	<form id="moveForm" action="">
		<input id="move" name="move" type="hidden" value=""></input>
	</form>	
	
	<div id="sideMenu" class="sideMenu">		
		<ul>
			<li>메인</li>
			<li id="Select">조회</li>
			<li id="Insert">입력</li>
			<li id="Stats">통계</li>
			<li id="Setup">설정				
				<ol style="display: none">			
					<li id="Purpose">목적설정</li>
					<li id="Bank">은행설정</li>										
				</ol>
			</li>					
		</ul>		
	</div>	
</body>
 --%>