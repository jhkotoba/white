<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	
	//권한리스트 조회
	fnSelectAuth().done(function(data){
		$("#authList").empty();		
		let tag = "";
		for(let i=0; i<data.length; i++){			
			tag += "<input type='checkbox' name='check' id='"+data[i].authNm+"' value='"+data[i].authNmSeq+"'>";
			tag += "<label for='"+data[i].authNm+"'>"+data[i].authCmt+"</label>	";
		}			
		$("#authList").append(tag);
		
		//권한 체크
		$("input[name='check']").on("click", function(){
			switch($(this).data("state")){
			case "have" 	: $(this).data("state", "remove"); break;
			case "remove" 	: $(this).data("state", "have"); break;
			case "add" 		: $(this).data("state", "none"); break;
			case "none"   	: $(this).data("state", "add"); break;				
			}
		});
	});
	
	//리스트 출력
	fnJsGrid();
	
  	//조회 버튼
	$("#searchBar #searchBtn").on("click", function(){		
		$("#searchForm #type").val($("#searchBar #type").val());
		
		$("#searchForm #type").val() === "id"? 
		$("#searchForm #text").val($("#searchBar #text").val()): 
		$("#searchForm #text").val("%"+$("#searchBar #text").val()+"%");
		
		$("#viewForm").clear().hide();

		fnJsGrid(1);
	});
  	
	//조회 엔터
  	$("#searchBar #text").on("keydown", function(e){
  		if (e.which == 13) $("#searchBar #searchBtn").trigger("click");  		
  	});
	
	//권한 저장
	$("#viewForm #save").on("click", function(){
		let param = {add : "", remove : ""};
		$("#authList").find("input").each(function(i){			
			if($(this).data("state") === "add"){				
				param.add += (isEmpty(param.add)===true?this.value:","+this.value);
			}else if($(this).data("state") === "remove"){
				param.remove += (isEmpty(param.remove)===true?this.value:","+this.value);			
			}
		});
		param.userNo = $("#viewForm #no").val();
		
		if(param.add === "" && param.remove === "") alert("수정할 내용이 없습니다."); return;
		
		fnCmmAjax("/admin/applyUserAuthList", param).done(function(){			
			fnSelectAuth(param.userNo).done(function(data){
        		$("input:checkbox[name='check']").data("state", "none").prop("checked", false);
        		for(let i=0; i<data.length; i++){
        			$("#authList #"+data[i].authNm).data("state", "have").prop("checked", true);
        		}
        		alert("권한을 적용하였습니다.");
        	});
			
		});
	});
});

//리스트 조회
function fnJsGrid(pageIdx, pageSize, pageBtnCnt){
	$("#userList").jsGrid({
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
            	
            	let param = $("#searchForm").getParam();
            	
            	if(filter !== "" || filter !==undefined || filter !== null){
            		param.pageIndex = filter.pageIndex;
                	param.pageSize = filter.pageSize;                	
            	}else{
            		param.pageIndex = this.pageIndex;
                	param.pageSize = this.pageSize;
            	}
            	
            	return fnCmmAjax("/admin/selectUserList", param, true);
            }
        },
        rowClick: function(args) {
        	$("#viewForm").setParam(args.item).show();
        	fnSelectAuth(args.item.no).done(function(data){
        		$("input:checkbox[name='check']").data("state", "none").prop("checked", false);
        		for(let i=0; i<data.length; i++){
        			$("#authList #"+data[i].authNm).data("state", "have").prop("checked", true);
        		}
        	});
        }, 
        fields: [
			/* { title:"사용자 번호",		name:"no",			type:"text", align:"center"}, */
			{ title:"사용자 아이디",		name:"userId",		type:"text", align:"center"},
			{ title:"사용자 이름",		name:"userName",	type:"text"}
        ]
    });
}
</script>


<!-- 글보기 -->
<form id="viewForm" class="blank hide" onsubmit="return false;">	
	<input id="no" type="hidden" value="">
	
	<div>
		<!-- <span class="span-gray-rt">번호</span>
		<span id="no" class="span-gray"></span> -->
		<span class="span-gray-rt">아이디</span>
		<span id="userId" class="span-gray"></span>
		<span class="span-gray-rt">이름</span>
		<span id="userName" class="span-gray"></span>
	</div>
	<div class="flex blank">
		<div class="flex-left left-th border-gray">권한설정</div>
		<div id="authList" class="flex-right border-gray"></div>
		<button class="btn-gray" id="save">저장</button>		
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
		<option value="id">아이디</option>		
		<option value="name">이름</option>
	</select>
	<input class="input-gray w3" id="text" type="text">
	<button class="btn-gray" id="searchBtn">조회</button>
</div>

<div id="userList"></div>