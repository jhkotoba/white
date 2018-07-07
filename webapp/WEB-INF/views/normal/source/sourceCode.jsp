<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<link rel="stylesheet" href="${contextPath}/resources/white/css/white.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/white/js/white.js"></script>
<script type="text/javascript">
$(document).ready(function(){	
	
	let white = new White("sourceList");
	let sourceCode = {};
	
	//option
	white.isPaging = true;
	
	//table
	white.head = ["번호", "종류", "글제목", "날짜"];
	white.hWidth = ["5%", "5%", "75%", "15%"];
	white.column = [
		{name: "sourceSeq", type: "text"}, 
		{name: "codeNm", type: "text"},		
		{name: "title", type: "text", event: "onClick"},
		{name: "regDate", type: "text"}		
	];	
	
	//param
	white.param = white.pagingData;
	
	//class
	white.tbCls = "table table-hover";
	
	//function onClickEvent
	white.fnOnClickEvent = function(item, idx){		
		$("#sourceWrite").hide();
		$("#sourceView").show();
		
		let param = {};
		param.sourceSeq = item.list[idx].sourceSeq;
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/source/selectSourceDtlView.ajax',
			data : param,
			dataType: 'json',
			async : true,
		    success : function(data) {	    	
				$("#sourceView #title").text(data.title);
				$("#sourceView #regDate").text(data.regDate);
				$("#sourceView #userId").text(data.userId);
				$("#sourceView #codeNm").text(data.codeNm);
				$("#sourceView #content").text(data.content);
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	}
	
	//function ajax
	white.fnAjax = function(){	
		let param = white.param;
		param.codeKey = $("#codeKey").val();
		param.searchType = $("#type").val();
		param.searchText = $("#text").val();
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/source/selectSourceCodeList.ajax',
			data : param,
			dataType: 'json',
			async : true,
		    success : function(data) {	    	
				white.list = data.list;
				white.totalCnt = data.totalCnt;
				white.draw();
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	};
	white.fnAjax();
	
	//코드 셀렉트박스 조회
	$.ajax({		
		type: 'POST',
		url: common.path()+'/white/selectCodeList.ajax',
		data : {
			codeType : "SOURCECODE"
		},
		dataType: 'json',
		async : true,
	    success : function(data) {	    	
	    	sourceCode.codeList = data;
	    	let tag = "<option value=''>전체</option>";
	    	for(let i=0; i<data.length; i++){
	    		tag += "<option value="+data[i].codeKey+">"+data[i].codeNm+"</option>";	    		
	    	}
	    	$("#sourceSearch #codeKey").append(tag);
	    	
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
	
	//조회 버튼
	$("#sourceSearch #search").on("click", function(){
		sourceViewEmpty();
		$("#sourceView").hide();
		
		$("#codeKey").val($("#search #codeKey").val());
		$("#type").val($("#sourceSearch #type").val());
		$("#text").val($("#sourceSearch #text").val());
		white.pageNum = 1;
		white.fnAjax();
		
	});
	
	//글쓰기 버튼	
	$("button[name=write]").on("click", function(){
		let tag = "";
		for(let i=0; i<sourceCode.codeList.length; i++){
			tag += "<option value="+sourceCode.codeList[i].codeKey+">"+sourceCode.codeList[i].codeNm+"</option>";	    		
		}
		$("#sourceWrite #codeKey").append(tag);
		$("#sourceWrite #codeKey").find('option:first').attr('selected', 'selected');
		
		$("#sourceWrite #title").val("");
		$("#sourceWrite #content").val("");
		
		sourceViewEmpty();
		$("#sourceView").hide();
		$("#sourceWrite").show();
	});
	
	//글쓰기 - 저장 버튼
	$("#sourceWrite #save").on("click", function(){
		
	});
});

//게시글 보기
/* function fnSourceView(sourceSeq){
	$("#sourceWrite").hide();
	$("#sourceView").show();
	
	let param = {};
	param.sourceSeq = sourceSeq;
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/source/selectSourceDtlView.ajax',
		data : param,
		dataType: 'json',
		async : true,
	    success : function(data) {	    	
			$("#sourceView #title").text(data.title);
			$("#sourceView #regDate").text(data.regDate);
			$("#sourceView #userId").text(data.userId);
			$("#sourceView #codeNm").text(data.codeNm);
			$("#sourceView #content").text(data.content);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
} */

//뷰 정보 비우기
function sourceViewEmpty(){
	$("#sourceView #title").text("");
	$("#sourceView #regDate").text("");
	$("#sourceView #userId").text("");
	$("#sourceView #codeNm").text("");
	$("#sourceView #content").text("");
}

</script>

<input id="codeKey" type="hidden" value="">
<input id="type" type="hidden" value="">
<input id="text" type="hidden" value="">
<div id="sourceWrite" class="form-control updown-spacing hide">
	<div>
		<span>타입</span>
		<select id="codeKey">	
		</select>
		<span>제목</span>
		<input id="title" type="text" style="width:70%;">		
	</div>	
	<div class="updown-spacing">
		<textarea id="content" style="height:50%; width:100%;"></textarea>
	</div>
	<button id="save">저장</button>
	<button onclick="$('#sourceWrite').hide();">닫기</button>
</div>
<div id="sourceView" class="form-control updown-spacing hide">
	
	<div class="right">
		<button>수정</button>
		<!-- <button id>저장</button> -->		
		<button name="write">글쓰기</button>
		<button onclick="$('#sourceView').hide();">닫기</button>
	</div>

	<div>
		<span>타입</span>
		<span id="codeNm"></span>
		<span>제목</span>
		<span id="title"></span>		
	</div>
	<div>
		<span>사용자</span>
		<span id="userId"></span>		
		<span>날짜</span>
		<span id="regDate"></span>
	</div>
	<div class="updown-spacing">
		<pre><span id="content"></span></pre>
	</div>		
</div>

<div id="sourceSearch" class="left">
	<select id="codeKey">				
	</select>
	<select id="type">
		<option value="">선택</option>
		<option value="id">아이디</option>		
		<option value="title">제목</option>
		<option value="content">내용</option>
	</select>
	<input id="text" type="text">
	<button id="search">조회</button>
</div>
<div class="right">
	<button name="write">글쓰기</button>
</div>

<div id="sourceList"></div>