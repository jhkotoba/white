<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	//리스트 출력
	fnJsGrid();
	
  	//조회 버튼
	$("#searchBar #searchBtn").on("click", function(){		
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
                    url: common.path()+'/admin/selectUserList.ajax',                   
                    success: function(data){console.log(data);
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
        	console.log(args);
        	$("#viewForm").setParam(args.item).show();        	
        }, 
        fields: [
			{ title:"사용자 번호",	name:"no",		type:"text", align:"center"},
			{ title:"사용자 아이디",	name:"userId",		type:"text", align:"center"},
			{ title:"사용자 이름",	name:"userName",	type:"text"}
        ]
    });
}
</script>


<!-- 글보기 -->
<form id="viewForm" class="updown-spacing hide" onsubmit="return false;">	
	<input id="no" type="hidden" value="">
	
	<div>
		<span class="span-gray-rt">번호</span>
		<span id="no" class="span-gray"></span>
		<span class="span-gray-rt">아이디</span>
		<span id="userId" class="span-gray"></span>
		<span class="span-gray-rt">이름</span>
		<span id="userName" class="span-gray"></span>
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
		<option value="title">제목</option>
	</select>
	<input class="input-gray w3" id="text" type="text">
	<button class="btn-gray" id="searchBtn">조회</button>
</div>


<div id="userList"></div>

