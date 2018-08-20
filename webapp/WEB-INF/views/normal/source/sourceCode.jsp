<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/cAdjust/css/cAdjust.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/cAdjust/js/cAdjust.js"></script>
<script type="text/javascript">
let codeList;
$(document).ready(function(){

	//리스트 출력
	fnJsGrid();
	
	//코드 셀렉트박스 조회
	cmmCode.select("sc").done(function(data){			
		codeList = data;
    	let tag = "";
    	for(let i=0; i<data.length; i++){
    		tag += "<option value="+data[i].code+">"+data[i].codeNm+"</option>";	    		
    	}
    	$("#writeForm #langCd").append("<option value=''>타입</option>"+tag);
    	$("#sourceSearch #langCd").append("<option value=''>전체</option>"+tag);
    	$("#sourceEdit #langCd").append(tag);
	});	
    
  	//조회 버튼
	$("#sourceSearch #search").on("click", function(){		
		$("#paramForm #langCd").val($("#sourceSearch #langCd").val());
		$("#paramForm #type").val($("#sourceSearch #type").val());
		
		$("#paramForm #type").val() === "id"? 
		$("#paramForm #text").val($("#sourceSearch #text").val()): 
		$("#paramForm #text").val("%"+$("#sourceSearch #text").val()+"%");
		
		fnJsGrid(1);
	});
  	
	//조회타입 전체시 텍스트 비움
	$("#sourceSearch #type").on("change", function(itme){
		if(itme.target.value === "") $("#sourceSearch #text").val("");
	});	
	
	//글쓰기 버튼	
	$("button[name=write]").on("click", function(){		
		$("#writeForm").clearForm().show();		
		fnViewEmpty();
		fnEditEmpty();		
		$("body").scrollTop(0);
	});
	
	//글쓰기 - 저장 버튼
	$("#writeForm #save").on("click", function(){
		let param = {};
		param.langCd = $("#writeForm #langCd").val();
		param.title = $("#writeForm #title").val();
		param.content = $("#writeForm #content").val();
		
		if(param.langCd.replace(/^\s+|\s+$/g,"") === ""){
			alert("타입을 선택해주세요");
			return;
		}
		if(param.title.replace(/^\s+|\s+$/g,"") === ""){
			alert("제목을 입력해주세요.");
			return;
		}
		if(param.content.replace(/^\s+|\s+$/g,"") === ""){
			alert("내용을 입력해주세요.");
			return;
		}
		if($("#writeForm #title").val().length > 50){
			alert("제목 글이 50자를 초과합니다.");
			return;
		}
		if($("#writeForm #content").val().length > 4000){
			alert("제목 글이 4000자를 초과합니다.");
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/source/insertSource.ajax',
			data : param,
			dataType: 'json',
			async : true,
			success : function(data) {
		    	if(1 === Number(data)){
		    		alert("새로운 글을 저장하였습니다.");
		    	}else{
		    		alert("저장에 실패하였습니다.");
		    	}	
		    	$("#writeForm").clearForm().hide();		    	  	
		    	$("#paramForm").clearForm();
				fnJsGrid(1);
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
		
	});
	
	//글쓰기 - 닫기
	$("#writeForm #close").on("click", function(){
		$("#writeForm").clearForm().hide();
	});
	
	//글수정
	$("#sourceView #edit").on("click", function(){
		$("#sourceView").hide();
		$("#sourceEdit").show();
	});
	
	//글수정-저장
	$("#sourceEdit #save").on("click", function(){
		let param = {};
		param.sourceSeq = $("#sourceEdit #sourceSeq").val();
		param.langCd = $("#sourceEdit #langCd").val();
		param.title = $("#sourceEdit #title").val();
		param.content = $("#sourceEdit #content").val();
		
		if(param.title.replace(/^\s+|\s+$/g,"") === ""){
			alert("제목을 입력해주세요.");
			return;
		}
		if(param.content.replace(/^\s+|\s+$/g,"") === ""){
			alert("내용을 입력해주세요.");
			return;
		}		
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/source/updateSource.ajax',
			data : param,
			dataType: 'json',
			async : true,
			success : function(data) {
		    	if(1 === Number(data)){
		    		alert("수정 하였습니다.");		    		
		    	}else{
		    		alert("수정에 실패하였습니다.");
		    	}
		    	fnViewEmpty();
		    	fnEditEmpty();		    	
		    	
		    	$("#paramForm").clearForm();
		    	
				fnJsGrid(1);
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	});
	
	//글수정 - 닫기
	$("#sourceEdit #close").on("click", function(){
		fnEditEmpty();
	});	
	
	//글보기 - 삭제
	$("#sourceView #delete").on("click", function(){
		
		if(!confirm("삭제하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/source/deleteSource.ajax',
			data : {
				sourceSeq : $("#sourceView #sourceSeq").val()
			},
			dataType: 'json',
			async : true,
			success : function(data) {
		    	if(1 === Number(data)){
		    		alert("삭제 하였습니다.");		    		
		    	}else{
		    		alert("삭제에 실패하였습니다.");
		    	}
		    	fnViewEmpty();
		    	fnEditEmpty();
		    	
		    	$("#paramForm").clearForm();
		    	
				fnJsGrid(1);
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	});
	
	//글수정 - 닫기
	$("#sourceView #close").on("click", function(){
		fnViewEmpty();
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
        pageSize : isEmpty(pageSize) === true ? 10 : pageSize,
        pageButtonCount : isEmpty(pageBtnCnt) === true ? 10 : pageBtnCnt,
       
        autoload: true,        
        controller: {
            loadData: function(filter) {
            	let deferred = $.Deferred();
            	
            	let param = {};
            	param.langCd = $("#langCd").val();
            	param.type = $("#type").val();
            	param.text = $("#text").val();
            	
            	if(filter !== "" || filter !==undefined || filter !== null){
            		param.pageIndex = filter.pageIndex;
                	param.pageSize = filter.pageSize;                	
            	}else{
            		param.pageIndex = this.pageIndex;
                	param.pageSize = this.pageSize;
            	}            	
               
                $.ajax({
                	type: 'POST',
                	data : param,
                    url: common.path()+'/source/selectSourceList.ajax',
                    dataType: 'json',
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
        	fnView(args.item.sourceSeq);
        }, 
        fields: [
			{ title:"번호",	name:"sourceSeq",	type:"text", width:"4%", align:"center"},
			{ title:"언어",	name:"codeNm",		type:"text", width:"8%", align:"center"},
			{ title:"글제목",	name:"title",		type:"text", width:"70%"},
			{ title:"작성자",	name:"userId",		type:"text", width:"8%", align:"center"},
			{ title:"날짜",	name:"regDate",		type:"text", width:"10%", align:"center"}
        ]
    });
}

function fnView(sourceSeq){
	$("#writeForm").clearForm().hide();
	
	$("#sourceView").show();
	$("#sourceView #edit").addClass("hide");
	$("#sourceView #delete").addClass("hide");	
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/source/selectSourceDtlView.ajax',
		data : {
			sourceSeq : sourceSeq
		},
		dataType: 'json',
		async : true,
	    success : function(data) {
	    	fnViewInit(data);
	    	fnEditInit(data);			
			$("body").scrollTop(0);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
}

//검색정보 삭제
function fnSearchEmpty(){
	$("#langCd").val("");
	$("#type").val("");
	$("#text").val("");
}

//뷰 정보 추가
function fnViewInit(data){
	$("#sourceView #sourceSeq").val(data.sourceSeq);	    	
	$("#sourceView #no").text(data.sourceSeq);	    	
	$("#sourceView #title").text(data.title);
	$("#sourceView #regDate").text(data.regDate);
	$("#sourceView #userId").text(data.userId);
	$("#sourceView #codeNm").text(data.codeNm);
	
	let adjust = cAdjust.adjust(data.codeNm, data.content);	
	$("#sourceView #cAdjust").empty().append(adjust);
}

//뷰 정보 비우기
function fnViewEmpty(){
	$("#sourceView #no").text("");
	$("#sourceView #title").text("");
	$("#sourceView #regDate").text("");
	$("#sourceView #userId").text("");
	$("#sourceView #codeNm").text("");	
	$("#sourceView #content").empty();
	$("#sourceView").hide();
}

//수정 내용 추가
function fnEditInit(data){
	$("#sourceEdit #sourceSeq").val(data.sourceSeq);	    	    	
	$("#sourceEdit #title").val(data.title);
	$("#sourceEdit #regDate").text(data.regDate);
	$("#sourceEdit #userId").text(data.userId);
	$("#sourceEdit #codeNm").text(data.codeNm);			
	$("#sourceEdit #content").val(data.content);
	if('${sessionScope.userId}'!== '' && '${sessionScope.userId}' === String(data.userId)){
		$("#sourceView #edit").removeClass("hide");
		$("#sourceView #delete").removeClass("hide");
	}
	$("#sourceEdit #langCd").val(data.code).prop("selected", true);
}


//수정 내용 삭제
function fnEditEmpty(){
	$("#sourceEdit #sourceSeq").val("");	    	    	
	$("#sourceEdit #title").val("");
	$("#sourceEdit #regDate").text("");
	$("#sourceEdit #userId").text("");
	$("#sourceEdit #codeNm").text("");	
	$("#sourceEdit #content").val("");
	$("#sourceEdit").hide();
}

</script>

<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">소스코드</h1>
	</div>	
</div>

<form id="paramForm" name="paramForm" onsubmit="return false;">
	<input id="langCd" type="hidden" value="">
	<input id="type" type="hidden" value="">
	<input id="text" type="hidden" value="">
</form>

<!-- 글쓰기  -->
<form id="writeForm" class="updown-spacing hide" onsubmit="return false;">	
	<div class="flex">		
		<div class="flex-left">			
			<select id="langCd" class="select-gray">	
			</select>				
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
		<textarea id="content" class="textarea-gray" maxlength="4000" style="height:50%; width:100%;">		
		</textarea>		
	</div>
</form>

<!-- 글수정 -->
<div id="sourceEdit" class="updown-spacing hide">
	<input id="sourceSeq" type="hidden" value="">
	<div>
		<span>타입</span>
		<select id="langCd">	
		</select>
		<span>제목</span>
		<input class="input-gray" id="title" type="text" maxlength="50" style="width:70%;">
	</div>
	<div>
		<span>사용자</span>
		<span id="userId"></span>		
		<span>날짜</span>
		<span id="regDate"></span>
	</div>
	<div class="updown-spacing">
		<textarea id="content" class="code-textarea" maxlength="4000" style="height:50%; width:100%; background-color: balck">		
		</textarea>		
	</div>
	<div>
		<button class="btn-gray" id="save">저장</button>
		<button class="btn-gray" id="close">닫기</button>
	</div>
</div>

<!-- 글보기 -->
<div id="sourceView" class="updown-spacing hide">	
	<input id="sourceSeq" type="hidden" value="">
	<div class="right">
		<button class="btn-gray" id="edit" class="hide">수정</button>	
		<button class="btn-gray" id="delete" class="hide">삭제</button>	
		<button class="btn-gray" name="write">글쓰기</button>
		<button class="btn-gray" id="close">닫기</button>
	</div>

	<div>
		<span>번호</span>
		<span id="no"></span>
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
	<div id="cAdjust" class="updown-spacing">		
	</div>		
</div>

<div id="sourceSearch" class="search-bar">
	<select id="langCd" class="select-gray">				
	</select>
	<select class="select-gray" id="type">
		<option value="">선택</option>
		<option value="id">아이디</option>		
		<option value="title">제목</option>
		<option value="content">내용</option>
	</select>
	<input class="input-gray w3" id="text" type="text">
	<button class="btn-gray" id="search">조회</button>
	<button class="btn-gray pull-right" name="write">글쓰기</button>
</div>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>