<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
let codeList;
$(document).ready(function(){

	//코드 셀렉트박스 조회
	code.select("sourceCode").done(function(data){			
		codeList = data;
    	let tag = "<option value=''>전체</option>";
    	for(let i=0; i<data.length; i++){
    		tag += "<option value="+data[i].codeKey+">"+data[i].codeNm+"</option>";	    		
    	}
    	$("#sourceSearch #codeKey").append(tag);	
	});	
	
	//리스트 출력
	jsGridCall();
    
  	//조회 버튼
	$("#sourceSearch #search").on("click", function(){		
		$("#codeKey").val($("#sourceSearch #codeKey").val());
		$("#type").val($("#sourceSearch #type").val());
		
		$("#type").val() === "id"? 
		$("#text").val($("#sourceSearch #text").val()): 
		$("#text").val("%"+$("#sourceSearch #text").val()+"%");
		
		jsGridCall(1);
	});
  	
	//조회타입 전체시 텍스트 비움
	$("#sourceSearch #type").on("change", function(itme){
		if(itme.target.value === ""){
			$("#sourceSearch #text").val("").attr("disabled","disabled");
		}else{
			$("#sourceSearch #text").removeAttr("disabled");
		}		
	});	
	
	//글쓰기 버튼	
	$("button[name=write]").on("click", function(){
		let tag = "";
		for(let i=0; i<codeList.length; i++){
			tag += "<option value="+codeList[i].codeKey+">"+codeList[i].codeNm+"</option>";	    		
		}
		$("#sourceWrite #codeKey").append(tag);
		$("#sourceWrite #codeKey").find('option:first').attr('selected', 'selected');
		
		$("#sourceWrite #title").val("");
		$("#sourceWrite #content").val("");
		
		sourceViewEmpty();
		$("#sourceView").hide();
		$("#sourceWrite").show();
	});
	
	//글쓰기 - 타이블 글자수 표시
	$("#sourceWrite #title").on("keydown", function(){
		let len = $("#sourceWrite #title").val().length;
		if(len > 50){
			alert("더이상 입력하실 수 없습니다.");
		}
		$("#sourceWrite #titleCnt").text(len);
	});
	
	//글쓰기 - 타이블 글자수 표시
	$("#sourceWrite #content").on("keydown", function(){
		ta.ck($("#sourceWrite #content").val());
		let len = $("#sourceWrite #content").val().length;
		if(len > 4000){
			alert("더이상 입력하실 수 없습니다.");
		}
		$("#sourceWrite #contentCnt").text(len);
	});
	
	//글쓰기 - 저장 버튼
	$("#sourceWrite #save").on("click", function(){
		let param = {};
		param.codeKey = $("#sourceWrite #codeKey").val();
		param.title = $("#sourceWrite #title").val();
		param.content = $("#sourceWrite #content").val();
		
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
		    	sourceWriteEmpty();
		    	$("#sourceWrite").hide();
		    	$("#codeKey").val("");
				$("#type").val("");
				$("#text").val("");
				
				jsGridCall(1);
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
		
	});
	
	//글수정
	$("#sourceView #edit").on("click", function(){
		$("#sourceView").hide();
		$("#sourceEdit").show();
	});
	
	//글수정-저장
	$("#sourceEdit #save").on("click", function(){
		alert("개발중..");
	});
	
});

//리스트 조회
function jsGridCall(pageIdx, pageSize, pageBtnCnt){
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
            	param.codeKey = $("#codeKey").val();
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
        	sourceView(args.item.sourceSeq);
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

function sourceView(sourceSeq){
	sourceWriteEmpty();
	$("#sourceWrite").hide();
	$("#sourceView").show();	
	
	$.ajax({		
		type: 'POST',
		url: common.path()+'/source/selectSourceDtlView.ajax',
		data : {
			sourceSeq : sourceSeq
		},
		dataType: 'json',
		async : true,
	    success : function(data) {
	    	$("#sourceView #sourceSeq").val(data.sourceSeq);	    	
	    	$("#sourceView #no").text(data.sourceSeq);	    	
			$("#sourceView #title").text(data.title);
			$("#sourceView #regDate").text(data.regDate);
			$("#sourceView #userId").text(data.userId);
			$("#sourceView #codeNm").text(data.codeNm);			
			$("#sourceView #content").empty().append(data.content);
			
			//수정 구역도 미리 구성
			$("#sourceEdit #sourceSeq").val(data.sourceSeq);	    	    	
			$("#sourceEdit #title").val(data.title);
			$("#sourceEdit #regDate").text(data.regDate);
			$("#sourceEdit #userId").text(data.userId);
			$("#sourceEdit #codeNm").text(data.codeNm);			
			$("#sourceEdit #content").val(data.content);
			
			let tag = "";
			for(let i=0; i<codeList.length; i++){
				if(data.codeNm === codeList[i].codeNm){
					tag += "<option value="+codeList[i].codeKey+" selected='selected'>"+codeList[i].codeNm+"</option>";
				}else{
					tag += "<option value="+codeList[i].codeKey+">"+codeList[i].codeNm+"</option>";
				}
			}
			$("#sourceEdit #codeKey").append(tag);
	    },
	    error : function(request, status, error){
	    	alert("error");
	    }
	});
}

//뷰 정보 비우기
function sourceViewEmpty(){
	$("#sourceView #no").text("");
	$("#sourceView #title").text("");
	$("#sourceView #regDate").text("");
	$("#sourceView #userId").text("");
	$("#sourceView #codeNm").text("");	
	$("#sourceView #content").empty();
	
	//수정부분도 삭제
	$("#sourceEdit #sourceSeq").val("");	    	    	
	$("#sourceEdit #title").val("");
	$("#sourceEdit #regDate").text("");
	$("#sourceEdit #userId").text("");
	$("#sourceEdit #codeNm").text("");	
	$("#sourceEdit #content").val("");
}

//글쓰기정보 비우기
function sourceWriteEmpty(){
	$("#sourceWrite #no").val("");
	$("#sourceWrite #title").val("");
	$("#sourceWrite #codeKey").find('option:first').attr('selected', 'selected');
	$("#sourceWrite #content").val("");
}

</script>

<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">소스 저장소</h1>
	</div>	
</div>

<input id="codeKey" type="hidden" value="">
<input id="type" type="hidden" value="">
<input id="text" type="hidden" value="">

<!-- 글쓰기  -->
<div id="sourceWrite" class="form-control updown-spacing hide">
	<div>
		<span>타입</span>
		<select id="codeKey">	
		</select>
		<span>제목</span>
		<input id="title" type="text" maxlength="50" style="width:70%;">
		<span id="titleCnt">0</span><span>/50</span>
	</div>	
	<div class="updown-spacing">
		<textarea id="content" class="ta-code" maxlength="4000" style="height:50%; width:100%; background-color: balck">		
		</textarea>
		<span id="contentCnt">0</span><span>/4000</span>
	</div>
	<button id="save">저장</button>
	<button onclick="$('#sourceWrite').hide();">닫기</button>
</div>

<!-- 글수정 -->
<div id="sourceEdit" class="form-control updown-spacing hide">
	<input id="sourceSeq" type="hidden" value="">
	<div>
		<span>타입</span>
		<select id="codeKey">	
		</select>
		<span>제목</span>
		<input id="title" type="text" maxlength="50" style="width:70%;">
		<span id="titleCnt">0</span><span>/50</span>
	</div>
	<div>
		<span>사용자</span>
		<span id="userId"></span>		
		<span>날짜</span>
		<span id="regDate"></span>
	</div>
	<div class="updown-spacing">
		<textarea id="content" class="ta-code" maxlength="4000" style="height:50%; width:100%; background-color: balck">		
		</textarea>
		<span id="contentCnt">0</span><span>/4000</span>
	</div>
	<button id="save">저장</button>
	<button onclick="$('#sourceEdit').hide();">닫기</button>
</div>

<!-- 글보기 -->
<div id="sourceView" class="form-control updown-spacing hide">	
	<input id="sourceSeq" type="hidden" value="">
	<div class="right">
		<button id="edit">수정</button>		
		<button name="write">글쓰기</button>
		<button onclick="$('#sourceView').hide();">닫기</button>
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
	<div class="updown-spacing">
		<pre id="content" class="ta-code"></pre>
	</div>		
</div>

<!-- 검색 -->
<div id="sourceSearch" class="left">
	<select id="codeKey">				
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
<div class="right">
	<button name="write">글쓰기</button>
</div>

<!-- 게시물 리스트 -->
<div id="sourceList"></div>