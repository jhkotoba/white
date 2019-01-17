<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/cAdjust/css/cAdjust.css" type="text/css" />

<script type="text/javascript" src="${contextPath}/resources/cAdjust/js/cAdjust.js"></script>
<script type="text/javascript">
$(document).ready(function(){

	//리스트 출력
	fnJsGrid();
	
	//코드 셀렉트박스 조회
	cfnSelectCode("sc").done(function(data){
    	let tag = "";
    	for(let i=0; i<data.length; i++){
    		tag += "<option value="+data[i].code+">"+data[i].codeNm+"</option>";	    		
    	}
    	$("#writeForm #langCd").append("<option value=''>타입</option>"+tag);
    	$("#searchBar #langCd").append("<option value=''>전체</option>"+tag);
    	$("#editForm #langCd").append(tag);
	});	
    
  	//조회 버튼
	$("#searchBar #searchBtn").on("click", function(){		
		$("#searchForm #langCd").val($("#searchBar #langCd").val());
		$("#searchForm #type").val($("#searchBar #type").val());
		
		let type =  $("#searchForm #type").val();		
		if(type === "id" || type === "sourceSeq"){
			$("#searchForm #text").val($("#searchBar #text").val());
		}else{
			$("#searchForm #text").val("%"+$("#searchBar #text").val()+"%");
		}
	

		fnJsGrid(1);
	});
  	
  	//조회 엔터
  	$("#searchBar #text").on("keydown", function(e){
  		if (e.which == 13) $("#searchBar #searchBtn").trigger("click");  		
  	});
  	
	//조회타입 전체시 텍스트 비움
	$("#searchBar #type").on("change", function(itme){
		if(itme.target.value === "") $("#searchBar #text").val("");
	});	
	
	//글쓰기 버튼	
	$("button[name=write]").on("click", function(){		
		$("#writeForm").clear().show();
		$("#viewForm").clear().hide();
		$("#editForm").clear().hide();	
		$("body").scrollTop(0);
	});
	
	//글쓰기 - 저장 버튼
	$("#writeForm #save").on("click", function(){		
		let param = $("#writeForm").getParam();
		
		if(wVali.parent("writeForm").checkItem(["empty", "maxLen"])
				.check(param, true) === false)	return;
		
		if(!confirm("저장 하시겠습니까?")) return;
		
		cfnCmmAjax("/source/insertSource", param).done(function(data){
			if(Number(data) === 1) alert("새로운 글을 저장하였습니다.");
	    	else alert("저장에 실패하였습니다.");
			
			$("#writeForm").clear().hide();		    	  	
	    	$("#searchForm").clear();
			fnJsGrid(1);
    	});
	});
	
	//글쓰기 - 닫기
	$("#writeForm #close").on("click", function(){
		$("#writeForm").clear().hide();
	});
	
	//글수정
	$("#viewForm #edit").on("click", function(){
		$("#viewForm").hide();
		$("#editForm").show();
	});
	
	//글수정 - 저장
	$("#editForm #save").on("click", function(){
		
		if(!confirm("수정 하시겠습니까?")) return;
		
		let param = $("#editForm").getParam();
		
		if(wVali.parent("editForm").checkItem(["empty", "maxLen"])
				.check(param, true) === false)	return;		
		
		cfnCmmAjax("/source/updateSource", param).done(function(data){
			if(1 === Number(data)) alert("수정 하였습니다.");
	    	else alert("수정에 실패하였습니다.");
			
	    	$("#viewForm").clear().hide();
	    	$("#editForm").clear().hide();
			fnJsGrid(1);
    	});
	});
	
	//글수정 - 닫기
	$("#editForm #close").on("click", function(){
		$("#editForm").clear().hide();
	});	
	
	//글보기 - 삭제
	$("#viewForm #remove").on("click", function(){
		
		if(!confirm("삭제하시겠습니까?")) return;
		
		cfnCmmAjax("/source/deleteSource", {sourceSeq : $("#viewForm #sourceSeq").val()}).done(function(data){
			if(1 === Number(data)) alert("삭제 하였습니다.");
	    	else alert("삭제에 실패하였습니다.");
			
	    	$("#viewForm").clear().hide();
	    	$("#editForm").clear().hide();
	    	$("#searchForm").clear();
	    	
			fnJsGrid(1);
    	});
	});
	
	//글수정 - 닫기
	$("#viewForm #close").on("click", function(){
		$("#viewForm").clear().hide();
	});	
});

//리스트 조회
function fnJsGrid(pageIdx, pageSize, pageBtnCnt){
	$("#sourceList").jsGrid({
        height: "auto",
        width: "100%",
        
        paging: true,
        pageLoading: true,
        pageIndex : isEmpty(pageIdx) === true ? 1 : pageIdx,
        pageSize : isEmpty(pageSize) === true ? 20 : pageSize,
        pageButtonCount : isEmpty(pageBtnCnt) === true ? 10 : pageBtnCnt,
        		
		pagerContainer: "#sourcePager",
		pagerFormat: "{first} {prev} {pages} {next} {last}",
		pagePrevText: "Prev",
		pageNextText: "Next",
		pageFirstText: "First",
		pageLastText: "Last",
		pageNavigatorNextText: "&#8230;",
		pageNavigatorPrevText: "&#8230;",        		
       
        autoload: true,        
        controller: {
            loadData: function(filter) {
            	
            	let param = $("#searchForm").getParam();            	
            	
            	if(filter !== "" || filter !==undefined || filter !== null){
            		param.pageIndex = filter.pageIndex;
                	param.pageSize = filter.pageSize;                	
            	}else{
            		param.pageIndex = this.pageIndex;
                	param.pageSize = this.pageSize;
            	}
            	
            	return cfnCmmAjax("/source/selectSourceList", param, true);
            }
        },
        rowClick: function(args) {        	
        	$("#writeForm").clear().hide();
        	$("#editForm").clear().hide();
        	
        	$("#viewForm").show();
        	$("#viewForm #edit").hide();
        	$("#viewForm #remove").hide();
        	
        	cfnCmmAjax("/source/selectSourceDtlView", {sourceSeq : args.item.sourceSeq}).done(function(data){
        		$("#viewForm").setParam(data);
    	    	$("#viewForm #cAdjust").empty().append(cAdjust.adjust(data.langNm, data.content));
    	    	
    	    	$("#editForm").setParam(data);    	    	
    	    	if('${sessionScope.userId}'!== '' && '${sessionScope.userId}' === String(data.userId)){
    	    		$("#viewForm #edit").show();
    	    		$("#viewForm #remove").show();
    	    	}  	
    			$("body").scrollTop(0);
        	});
        }, 
        fields: [
			{ title:"번호",	name:"sourceSeq",	type:"text", width:"4%", align:"center"},
			{ title:"언어",	name:"langNm",		type:"text", width:"8%", align:"center"},
			{ title:"글제목",	name:"title",		type:"text", width:"70%"},
			{ title:"작성자",	name:"userId",		type:"text", width:"8%", align:"center"},
			{ title:"날짜",	name:"regDate",		type:"text", width:"10%", align:"center"}
        ]
    });
}
</script>

<!-- 글쓰기  -->
<form id="writeForm" class="blank hide" onsubmit="return false;">	
	<div class="flex">		
		<div class="flex-left">
			<span class="span-gray-rt">타입</span>		
			<select id="langCd" class="select-gray">	
			</select>
			<span class="span-gray-rt">제목</span>			
		</div>		
		<div class="flex-right">					
			<input class="input-gray wth100p" id="title" type="text" maxlength="50" placeholder="제목 입력">
		</div>
		<div class="flex-other">
			<button class="btn-gray trs trs" id="save">저장</button>
			<button class="btn-gray trs" id="close">닫기</button>
		</div>		
	</div>	
	<div>
		<textarea id="content" class="textarea-gray" maxlength="4000">		
		</textarea>		
	</div>
</form>

<!-- 글수정 -->
<form id="editForm" class="blank hide" onsubmit="return false;">
	<input id="sourceSeq" type="hidden" value="">
	<div class="flex">
		<div class="flex-left">
			<span class="span-gray-rt">타입</span>
			<select id="langCd" class="select-gray">
			</select>
			<span class="span-gray-rt">사용자</span>
			<span id="userId" class="span-gray"></span>
			<span class="span-gray-rt">제목</span>
		</div>
		<div class="flex-right">
			<input class="input-gray wth100p" id="title" type="text" maxlength="50" placeholder="제목 입력">
		</div>
		<div class="flex-other">
			<span class="span-gray-rt">날짜</span>
			<span id="regDate" class="span-gray"></span>
			<button class="btn-gray trs" id="save">수정</button>
			<button class="btn-gray trs" id="close">닫기</button>
		</div>
	</div>
	<div>	
		<textarea id="content" class="textarea-gray" maxlength="4000">		
		</textarea>		
	</div>
</form>

<!-- 글보기 -->
<form id="viewForm" class="blank hide" onsubmit="return false;">	
	<input id="sourceSeq" type="hidden" value="">
	
	<div class="flex">
		<div class="flex-left">
			<span class="span-gray-rt">번호</span>
			<span id="sourceSeq" class="span-gray"></span>
			<span class="span-gray-rt">타입</span>
			<span id="langNm" class="span-gray"></span>
			<span class="span-gray-rt">사용자</span>
			<span id="userId" class="span-gray"></span>
			<span class="span-gray-rt">제목</span>
		</div>
		<div class="flex-right">
			<span class="span-gray-block" id="title"></span>
		</div>
		<div class="flex-other">
			<span class="span-gray-rt">날짜</span>
			<span id="regDate" class="span-gray"></span>
			<button class="btn-gray trs" id="edit">수정</button>
			<button class="btn-gray trs" id="remove" class="hide">삭제</button>	
			<button class="btn-gray trs" name="write">글쓰기</button>
			<button class="btn-gray trs" id="close">닫기</button>
		</div>
	</div>
	<div id="cAdjust" class="blank">
	</div>
</form>

<!-- 검색 -->
<form id="searchForm" name="searchForm" onsubmit="return false;">
	<input id="langCd" type="hidden" value="">
	<input id="type" type="hidden" value="">
	<input id="text" type="hidden" value="">
</form>

<!-- 조회 입력란 -->
<div id="searchBar" class="search-bar">
	<select id="langCd" class="select-gray">				
	</select>
	<select class="select-gray" id="type">
		<option value="">선택</option>
		<option value="id">아이디</option>		
		<option value="title">제목</option>
		<option value="content">내용</option>
		<option value="sourceSeq">번호</option>
	</select>
	<input class="input-gray wth3" id="text" type="text">
	<button class="btn-gray trs" id="searchBtn">조회</button>
	<button class="btn-gray trs pull-right" name="write">글쓰기</button>
</div>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>
<div id="sourcePager" class="pager"></div>