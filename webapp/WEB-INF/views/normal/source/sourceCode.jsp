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
	cmmCode.select("sc").done(function(data){		
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
		
		$("#searchForm #type").val() === "id"? 
		$("#searchForm #text").val($("#searchBar #text").val()): 
		$("#searchForm #text").val("%"+$("#searchBar #text").val()+"%");

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
		
		if(wVali.parent("writeForm").clause(["empty", "maxLen"])
				.check(param, true) === false)	return;
		
		$.ajax({
			url: common.path()+'/source/insertSource.ajax',
			data : param,
			success : function(data) {
		    	if(Number(data) === 1){
		    		alert("새로운 글을 저장하였습니다.");
		    	}else{
		    		alert("저장에 실패하였습니다.");
		    	}	
		    	$("#writeForm").clear().hide();		    	  	
		    	$("#searchForm").clear();
				fnJsGrid(1);
		    }
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
	
	//글수정-저장
	$("#editForm #save").on("click", function(){
		
		if(!confirm("수정하시겠습니까?")){
			return;
		}
		
		let param = $("#editForm").getParam();
		
		if(wVali.parent("editForm").clause(["empty", "maxLen"])
				.check(param, true) === false)	return;		
		
		$.ajax({
			url: common.path()+'/source/updateSource.ajax',
			data : param,
			success : function(data) {
		    	if(1 === Number(data)){
		    		alert("수정 하였습니다.");		    		
		    	}else{
		    		alert("수정에 실패하였습니다.");
		    	}
		    	$("#viewForm").clear().hide();
		    	$("#editForm").clear().hide();
				fnJsGrid(1);
		    }
		});
	});
	
	//글수정 - 닫기
	$("#editForm #close").on("click", function(){
		$("#editForm").clear().hide();
	});	
	
	//글보기 - 삭제
	$("#viewForm #delete").on("click", function(){
		
		if(!confirm("삭제하시겠습니까?")){
			return;
		}
		
		$.ajax({
			url: common.path()+'/source/deleteSource.ajax',
			data : {
				no : $("#viewForm #no").val()
			},
			success : function(data) {
		    	if(1 === Number(data)){
		    		alert("삭제 하였습니다.");		    		
		    	}else{
		    		alert("삭제에 실패하였습니다.");
		    	}
		    	$("#viewForm").clear().hide();
		    	$("#editForm").clear().hide();		    	
		    	$("#searchForm").clear();
		    	
				fnJsGrid(1);
		    }
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
       
        autoload: true,        
        controller: {
            loadData: function(filter) {
            	let deferred = $.Deferred();
            	
            	let param = $("#searchForm").getParam();            	
            	
            	if(filter !== "" || filter !==undefined || filter !== null){
            		param.pageIndex = filter.pageIndex;
                	param.pageSize = filter.pageSize;                	
            	}else{
            		param.pageIndex = this.pageIndex;
                	param.pageSize = this.pageSize;
            	}            	
               
                $.ajax({
                	data : param,
                    url: common.path()+'/source/selectSourceList.ajax',                   
                    success: function(data){
                        deferred.resolve({
    						data: data.list,    						
    						itemsCount: data.itemsCount
    					});
                    }
                });                
                return deferred.promise();
            }
        },
        rowClick: function(args) {        	
        	$("#writeForm").clear().hide();
        	$("#editForm").clear().hide();
        	
        	$("#viewForm").show();
        	$("#viewForm #edit").addClass("hide");
        	$("#viewForm #delete").addClass("hide");	
        	
        	$.ajax({
        		url: common.path()+'/source/selectSourceDtlView.ajax',
        		data : {
        			no : args.item.no
        		},
        	    success : function(data) {	    	
        	    	$("#viewForm").setParam(data);
        	    	$("#viewForm #cAdjust").empty().append(cAdjust.adjust(data.langNm, data.content));
        	    	
        	    	$("#editForm").setParam(data);
        	    	if('${sessionScope.userId}'!== '' && '${sessionScope.userId}' === String(data.userId)){
        	    		$("#viewForm #edit").removeClass("hide");
        	    		$("#viewForm #delete").removeClass("hide");
        	    	}	    	
        			$("body").scrollTop(0);
        	    }
        	});
        }, 
        fields: [
			{ title:"번호",	name:"no",			type:"text", width:"4%", align:"center"},
			{ title:"언어",	name:"langNm",		type:"text", width:"8%", align:"center"},
			{ title:"글제목",	name:"title",		type:"text", width:"70%"},
			{ title:"작성자",	name:"userId",		type:"text", width:"8%", align:"center"},
			{ title:"날짜",	name:"regDate",		type:"text", width:"10%", align:"center"}
        ]
    });
}
</script>

<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">소스코드</h1>
	</div>	
</div>

<!-- 글쓰기  -->
<form id="writeForm" class="updown-spacing hide" onsubmit="return false;">	
	<div class="flex">		
		<div class="flex-left">
			<span class="span-gray-rt">타입</span>		
			<select id="langCd" class="select-gray">	
			</select>
			<span class="span-gray-rt">제목</span>			
		</div>		
		<div class="flex-right">					
			<input class="input-gray w100" id="title" type="text" maxlength="50" placeholder="제목 입력">
		</div>
		<div class="flex-other">
			<button class="btn-gray" id="save">저장</button>
			<button class="btn-gray" id="close">닫기</button>
		</div>		
	</div>	
	<div>
		<textarea id="content" class="textarea-gray" maxlength="4000">		
		</textarea>		
	</div>
</form>

<!-- 글수정 -->
<form id="editForm" class="updown-spacing hide" onsubmit="return false;">
	<input id="no" type="hidden" value="">
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
			<input class="input-gray w100" id="title" type="text" maxlength="50" placeholder="제목 입력">
		</div>
		<div class="flex-other">
			<span class="span-gray-rt">날짜</span>
			<span id="regDate" class="span-gray"></span>
			<button class="btn-gray" id="save">수정</button>
			<button class="btn-gray" id="close">닫기</button>
		</div>
	</div>
	<div>	
		<textarea id="content" class="textarea-gray" maxlength="4000">		
		</textarea>		
	</div>
</form>

<!-- 글보기 -->
<form id="viewForm" class="updown-spacing hide" onsubmit="return false;">	
	<input id="no" type="hidden" value="">
	
	<div class="flex">
		<div class="flex-left">
			<span class="span-gray-rt">번호</span>
			<span id="no" class="span-gray"></span>
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
			<button class="btn-gray" id="edit">수정</button>
			<button class="btn-gray" id="delete" class="hide">삭제</button>	
			<button class="btn-gray" name="write">글쓰기</button>
			<button class="btn-gray" id="close">닫기</button>
		</div>
	</div>
	<div id="cAdjust" class="updown-spacing">
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
	</select>
	<input class="input-gray w3" id="text" type="text">
	<button class="btn-gray" id="searchBtn">조회</button>
	<button class="btn-gray pull-right" name="write">글쓰기</button>
</div>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>