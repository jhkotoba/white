<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript" src="${contextPath}/resources/js/admin/menu.js?ver=0.008"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	if(window.innerWidth > common.platformSize){
		$("#navMenuWidth").addClass("left");
		$("#sideMenuWidth").addClass("left");
	}	
	
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
<div class="article">
	<div id="navMenuWidth" class="width-vmin">
		<h6 class="nsrb">Nav Menu</h6>
		<div class="btn-group" role="group">	
			<button id="navAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="navSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">네비메뉴 저장</button>
			<button id="navCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="navList"></div>	
	</div>	
	
	<div id="sideMenuWidth" class="width-vmin">
		<h6 class="nsrb">Side Menu</h6>
		<div class="btn-group" role="group">	
			<button id="sideAddBtn" type="button" class="btn btn-secondary btn-fs nsrb">추가</button>
			<button id="sideSaveBtn" type="button" class="btn btn-secondary btn-fs nsrb">하단메뉴 저장</button>
			<button id="sideCelBtn" type="button" class="btn btn-secondary btn-fs nsrb">취소</button>
		</div>
		<div id="sideList"></div>
	</div>
</div>