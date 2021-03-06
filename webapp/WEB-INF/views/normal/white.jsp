<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<!DOCTYPE html PUBLIC>
<html>
<head>
<meta charset=UTF-8>
<title>whiteHome</title>

<link rel="stylesheet" href="${contextPath}/resources/air-datepicker/css/datepicker-custom.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/jsgrid/css/jsgrid-custom.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/jsgrid/css/jsgrid-theme-custom.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/wVali/css/wVali.css" type="text/css"/>
<link rel="stylesheet" href="${contextPath}/resources/common/css/common.css" type="text/css" />

<script type="text/javascript" src="${contextPath}/resources/jquery/js/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jquery/js/jquery-ui.js"></script>
<script type="text/javascript" src="${contextPath}/resources/air-datepicker/js/datepicker.js"></script>
<script type="text/javascript" src="${contextPath}/resources/air-datepicker/js/i18n/datepicker.ko.js"></script>
<script type="text/javascript" src="${contextPath}/resources/jsgrid/js/jsgrid.js"></script>
<script type="text/javascript" src="${contextPath}/resources/wVali/js/wVali.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/cmmCode.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/cmmAjax.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/common.js"></script>
<script type="text/javascript" src="${contextPath}/resources/common/js/commonEvent.js"></script>


</head>
<body class="body">
<c:if test="${sessionScope.userId eq null}">
<script type="text/javascript">
$(document).ready(function(){	
	//로그인창 보이기
	$("#loginBtn").on("click", function(){		
		$(".blind").show(800);
		$("#loginForm").fadeIn("slow", function(e){
			
		});
	});
	//외부창 클릭시 로그인창 닫기
	$(document).mouseup(function (e){
		let container = $("#loginForm");
		if( container.has(e.target).length === 0){
			$(".blind").hide(600);
			$("#loginForm").fadeOut("slow", function(e){
				
			});
		}
	});	
	//사용자 체크, 로그인
	$("#loginSmt").on("click", function(e){
		
		let param = {};
		param.userId = $("#loginForm #userId").val();
		param.passwd = $("#loginForm #passwd").val();
		
		$.ajax({
			url: common.path()+'/main/loginCheck.ajax',			
			data : param,
		    success : function(data) {
		    	if(data){		    		
		    		$(".blind").hide(200);
					$("#loginForm").fadeOut(200);
		    		
		    		$("#loginForm").attr("method", "post").attr("onsubmit", "")
		    			.attr("action", common.path()+"/main/login").submit();
		    	}else{
		    	
		    	}
		    }
		});		
	});
});
</script>
</c:if>

<nav class="nav">
	<a class="nav-brand h6" href="${contextPath}/main">white</a>
	<ul>
		<c:forEach items="${sessionScope.upperList}" var="upper">
			<c:if test="${upper.auth eq 1 }">
				<li class="dropdown">
					<a href="javascript:void(0);">${upper.upperNm}</a>
					<div class="dropdown-content">								
						<c:forEach items="${sessionScope.lowerList}" var="lower">									
							<c:if test="${upper.upperSeq eq lower.upperSeq }">
								<c:if test="${lower.auth eq 1 }">
									<a class="lowerHeight" href="javascript:mf.submit('${upper.upperUrl}', '${lower.lowerUrl}', '${upper.upperNm}', '${lower.lowerNm}')">${lower.lowerNm}</a>
								</c:if>
							</c:if>
						</c:forEach>
					</div>
				</li>
			</c:if>
		</c:forEach>
	</ul>	
	<div class="user">
		<c:if test="${sessionScope.userId eq null}">
			<a class="a-brand h6" href="${contextPath}/main/join">Join</a>
			<a class="a-brand h6" href="javascript:void(0)" id="loginBtn">login</a>			
		</c:if>	
		<c:if test="${sessionScope.userId ne null}">
			<span>${sessionScope.userId}</span>			
			<a class="a-brand h6" href="${contextPath}/main/logout">Logout</a>
		</c:if>
	</div>			
</nav>	
<section>
	<main role="main" class="main">	
		<c:if test="${upperNm ne null}">
			<span class="path">${upperNm} > ${upperNm}</span>
		</c:if>
		<jsp:include page="${requestScope.sectionPage}" flush="false" />
	</main>
</section>	
<footer>		
</footer>

<c:if test="${sessionScope.userId eq null}">
<form id="loginForm" class="login" onsubmit="return false;" style="display: none;">
	<h5>Login</h5>
	<div class="login-center">
		<h6>Id</h6>
		<input id="userId" name="userId" class="input-gray login-text wth100p" type="text">
		<h6>Password</h6>
		<input id="passwd" name="passwd" class="input-gray login-text wth100p" type="password">
		<div>
			<button id="loginSmt" class="btn-gray trs">Login</button>
			<a class="btn-gray trs" href="${contextPath}/main/signUp">Sign up</a>
		</div>
	</div>
</form>
</c:if>

<c:if test="${sessionScope.userId ne null}">
<form id="moveForm" action="">
	<input id="upperUrl" name="upperUrl" type="hidden" value="${upperUrl}"></input>
	<input id="lowerUrl" name="lowerUrl" type="hidden" value="${lowerUrl}"></input>
	<input id="upperNm" name="upperNm" type="hidden"></input>
	<input id="lowerNm" name="lowerNm" type="hidden"></input>
	<input id="param" name="param" type="hidden"></input>
</form>
<form id="downloadForm">
	<input id="filename" name="filename" type="hidden"></input>
	<input id="data" name="data" type="hidden"></input>
</form>
</c:if>
<div id="blind"></div>
</body>
</html>