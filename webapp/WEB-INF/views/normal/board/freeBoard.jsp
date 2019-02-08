<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<c:set var="board" value="free"></c:set>

<script type="text/javascript">
$(document).ready(function(){

	//리스트 출력
	fnJsGrid();
    
  	//조회 버튼
	$("#searchBar #searchBtn").on("click", function(){		
		$("#searchForm #type").val($("#searchBar #type").val());
		
		let type =  $("#searchForm #type").val();
		
		if(type === "id")	$("#searchForm #text").val($("#searchBar #text").val());
		else $("#searchForm #text").val("%"+$("#searchBar #text").val()+"%");

		fnJsGrid(1);
	});
  	
  	//조회 엔터
  	$("#searchBar #text").on("keydown", function(e){
  		if (e.which == 13) $("#searchBar #searchBtn").trigger("click");  		
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
		param.board = "${board}";
		
		if(wVali.parent("writeForm").checkItem(["empty", "maxLen"])
				.check(param, true) === false)	return;
		
		if(!confirm("저장 하시겠습니까?")) return;
		
		cfnCmmAjax("/board/insertBoard", param).done(function(data){
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
		param.board = "${board}";
		
		if(wVali.parent("editForm").checkItem(["empty", "maxLen"])
				.check(param, true) === false)	return;		
		
		cfnCmmAjax("/board/updateBoard", param).done(function(data){
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
		
		cfnCmmAjax("/board/deleteBoard", {boardSeq : $("#viewForm #boardSeq").val(), board : "free"}).done(function(data){
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
	$("#boardList").jsGrid({
        height: "auto",
        width: "100%",
        
        paging: true,
        pageLoading: true,
        pageIndex : isEmpty(pageIdx) === true ? 1 : pageIdx,
        pageSize : isEmpty(pageSize) === true ? 20 : pageSize,
        pageButtonCount : isEmpty(pageBtnCnt) === true ? 10 : pageBtnCnt,
        		
		pagerContainer: "#boardPager",
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
            	param.board = "${board}";
            	
            	if(filter !== "" || filter !==undefined || filter !== null){
            		param.pageIndex = filter.pageIndex;
                	param.pageSize = filter.pageSize;                	
            	}else{
            		param.pageIndex = this.pageIndex;
                	param.pageSize = this.pageSize;
            	}
            	
            	return cfnCmmAjax("/board/selectBoardList", param, true);
            }
        },
        rowClick: function(args) {        	
        	$("#writeForm").clear().hide();
        	$("#editForm").clear().hide();
        	
        	$("#viewForm").show();
        	$("#viewForm #edit").hide();
        	$("#viewForm #remove").hide();
        	
        	cfnCmmAjax("/board/selectBoardDtlView", {boardSeq : args.item.boardSeq, board : "free"}).done(function(data){
        		$("#viewForm").setParam(data);
    	    	$("#viewForm #content").text(data.content);
    	    	
    	    	$("#editForm").setParam(data);    	    	
    	    	if('${sessionScope.userId}'!== '' && '${sessionScope.userId}' === String(data.userId)){
    	    		$("#viewForm #edit").show();
    	    		$("#viewForm #remove").show();
    	    	}  	
    			$("body").scrollTop(0);
        	});
        }, 
        fields: [
			{ title:"번호",	name:"boardSeq",	type:"text", width:"5%", align:"center"},
			{ title:"글제목",	name:"title",		type:"text", width:"70%"},
			{ title:"작성자",	name:"userId",		type:"text", width:"10%", align:"center"},
			{ title:"작성날짜",name:"regDate",		type:"text", width:"15%", align:"center"}			
        ]
    });
}
</script>

<!-- 글쓰기  -->
<form id="writeForm" class="blank hide" onsubmit="return false;">	
	<div class="flex">		
		<div class="flex-left">	
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
		<textarea id="content" class="textarea-gray tx-pre hht4 wth100p gray-scroll" maxlength="4000">		
		</textarea>		
	</div>
</form>

<!-- 글수정 -->
<form id="editForm" class="blank hide" onsubmit="return false;">
	<input id="boardSeq" type="hidden" value="">
	<div class="flex">
		<div class="flex-left">
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
		<textarea id="content" class="textarea-gray tx-pre hht4 wth100p gray-scroll" maxlength="4000">		
		</textarea>		
	</div>
</form>

<!-- 글보기 -->
<form id="viewForm" class="blank hide" onsubmit="return false;">	
	<input id="boardSeq" type="hidden" value="">
	
	<div class="flex">
		<div class="flex-left">
			<span class="span-gray-rt">번호</span>
			<span id="boardSeq" class="span-gray"></span>
			<span class="span-gray-rt">사용자</span>
			<span id="userId" class="span-gray"></span>
			<span class="span-gray-rt">제목</span>
		</div>
		<div class="flex-right">
			<span class="span-gray-block" id="title"></span>
		</div>
		<div class="flex-other">
			<span class="span-gray-rt">수정 날짜</span>
			<span id="editDate" class="span-gray"></span>
			<span class="span-gray-rt">작성 날짜</span>
			<span id="regDate" class="span-gray"></span>
			<button class="btn-gray trs" id="edit">수정</button>
			<button class="btn-gray trs" id="remove" class="hide">삭제</button>	
			<button class="btn-gray trs" name="write">글쓰기</button>
			<button class="btn-gray trs" id="close">닫기</button>
		</div>
	</div>
	<div>
		<pre id="content" class='pre-gray hht4 gray-scroll'></pre>
	</div>
	
	<div id="commentlist"></div>
	<div id="commentReg">
		<button class="btn-gray trs wth10p hht1">댓글 등록</button>
		<textarea class="textarea-gray hht1 gray-scroll wth89p pull-right" maxlength="500"></textarea>
	</div>
</form>

<!-- 검색 -->
<form id="searchForm" name="searchForm" onsubmit="return false;">
	<input id="type" type="hidden" value="">
	<input id="text" type="hidden" value="">
</form>

<!-- 조회 입력란 -->
<div id="searchBar" class="search-bar">
	<select class="select-gray" id="type">
		<option value="">선택</option>
		<option value="id">아이디</option>		
		<option value="title">제목</option>
		<option value="content">내용</option>
		<option value="boardSeq">번호</option>
	</select>
	<input class="input-gray wth3" id="text" type="text">
	<button class="btn-gray trs" id="searchBtn">조회</button>
	<button class="btn-gray trs pull-right" name="write">글쓰기</button>
</div>

<!-- 게시물 리스트 -->
<div id="boardList"></div>
<div id="boardPager" class="pager"></div>