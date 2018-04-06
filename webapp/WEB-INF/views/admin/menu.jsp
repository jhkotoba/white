<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/admin/menu.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/admin/selectNavSideMenuList.ajax',
		dataType: 'json',
		data : {
			mode : "select"
		},
	    success : function(data) {	
	    	nav.init(data.navList, data.authList).view();
	    	side.init(data.sideList, data.authList).view();
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//헤더메뉴 추가
	$("#navAddBtn").click(function(){		
		nav.add().view();
	});
	
	//취소
	$("#navCelBtn").click(function(){		
		nav.cancel().view();
	});
	
	//네비메뉴 저장, 수정, 삭제
	$("#navSaveBtn").click(function(){
		let rtn = nav.check();
		if(rtn.check === true){
			nav.save();
		}else{
			alert(rtn.msg);
		}
	});
	
	
	
	//사이드메뉴 추가
	$("#sideAddBtn").click(function(){		
		side.add().view();
	});
	
	//사이드메뉴 취소
	$("#sideCelBtn").click(function(){		
		side.cancel().view();
	});
	
	
	//사이드메뉴 저장
	$("#sideSaveBtn").click(function(){
		let rtn = side.check();
		if(rtn.check === true){
			side.save();
		}else{
			alert(rtn.msg);
		}
	});
});

</script>	
<div>
	<span class='add'>■추가</span>
	<span class='edit'>■수정</span>
	<span class='redLine'>■삭제</span>
</div>
<br>

<div class="left">
	<button id="navAddBtn" class="btn_azure03">추가</button>
	<button id="navSaveBtn" class="btn_azure03">네비메뉴 저장</button>
	<button id="navCelBtn" class="btn_azure03">취소</button>
	<div id="navList" class="scroll"></div>	
</div>

<div class="left">
	<button id="sideAddBtn" class="btn_azure03">추가</button>
	<button id="sideSaveBtn" class="btn_azure03">사이드메뉴 저장</button>
	<button id="sideCelBtn" class="btn_azure03">취소</button>
	<div id="sideList" class="scroll"></div>
</div>