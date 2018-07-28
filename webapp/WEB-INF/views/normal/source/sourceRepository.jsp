<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<link rel="stylesheet" href="${contextPath}/resources/cAdjust/css/cAdjust.css" type="text/css" />
<script type="text/javascript" src="${contextPath}/resources/cAdjust/js/cAdjust.js"></script>
<script type="text/javascript">
let codeList;
$(document).ready(function(){

	//코드 셀렉트박스 조회
	cmmCode.select("sc").done(function(data){			
		codeList = data;
    	let tag = "<option value=''>전체</option>";
    	for(let i=0; i<data.length; i++){
    		tag += "<option value="+data[i].code+">"+data[i].codeNm+"</option>";	    		
    	}
    	$("#sourceSearch #langCd").append(tag);	
	});	
	
	//리스트 출력
	fnJsGrid();
    
  	//조회 버튼
	$("#sourceSearch #search").on("click", function(){		
		$("#langCd").val($("#sourceSearch #langCd").val());
		$("#type").val($("#sourceSearch #type").val());
		
		$("#type").val() === "id"? 
		$("#text").val($("#sourceSearch #text").val()): 
		$("#text").val("%"+$("#sourceSearch #text").val()+"%");
		
		fnJsGrid(1);
	});
  	
	//조회타입 전체시 텍스트 비움
	$("#sourceSearch #type").on("change", function(itme){
		if(itme.target.value === ""){
			$("#sourceSearch #text").val("").attr("disabled","disabled");
		}else{
			$("#sourceSearch #text").removeAttr("disabled");
		}		
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
			{ title:"번호",	name:"sourceSeq",	type:"text", width:"4%"},
			{ title:"종류",	name:"codeNm",		type:"text", width:"8%"},
			{ title:"글제목",	name:"title",		type:"text", width:"70%"},
			{ title:"작성자",	name:"userId",		type:"text", width:"8%"},
			{ title:"날짜",	name:"regDate",		type:"text", width:"10%"}
        ]
    });
}

function fnView(sourceSeq){
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
</script>

<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">소스 저장소</h1>
	</div>	
</div>

<input id="langCd" type="hidden" value="">
<input id="type" type="hidden" value="">
<input id="text" type="hidden" value="">

<!-- 글보기 -->
<div id="sourceView" class="form-control updown-spacing hide">	
	<input id="sourceSeq" type="hidden" value="">
	<div class="right">			
		<button id="close">닫기</button>
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

<!-- 검색 -->
<div id="sourceSearch" class="left">
	<select id="langCd">				
	</select>
	<select id="type">
		<option value="">선택</option>
		<option value="id">아이디</option>		
		<option value="title">제목</option>
		<option value="content">내용</option>
	</select>
	<input id="text" type="text" disabled="disabled">
	<button id="search">조회</button>
</div>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>