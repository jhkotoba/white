<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	
	//권한리스트 조회
	cfnSelectAuth().done(function(data){
		$("#authList").empty();		
		let tag = "";
		for(let i=0; i<data.length; i++){			
			tag += "<div class='check-item'><input type='checkbox' name='check' id='"+data[i].authNm+"' value='"+data[i].authNmSeq+"'>";
			tag += "<label for='"+data[i].authNm+"'>"+data[i].authCmt+"</label></div>";
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
	$("#searchBtn").on("click", function(){		
		
		$("#searchForm #type").val($("#searchBar #type").val());
		
		$("#searchForm #type").val() === "id"? 
		$("#searchForm #text").val($("#searchBar #text").val()): 
		$("#searchForm #text").val("%"+$("#searchBar #text").val()+"%");
		
		$("#viewForm").clear().hide();

		fnJsGrid(1);
	});
  	
	//조회 엔터
  	$("#searchBar #text").on("keydown", function(e){
  		if (e.which == 13) $("#searchBtn").trigger("click");  		
  	});
	
	//권한 저장
	$("#viewForm #save").on("click", function(){
		
		if(!confirm("저장하시겠습니까?")) return;
		
		let param = {add : "", remove : ""};
		$("#authList").find("input").each(function(i){			
			if($(this).data("state") === "add"){				
				param.add += (isEmpty(param.add)===true?this.value:","+this.value);
			}else if($(this).data("state") === "remove"){
				param.remove += (isEmpty(param.remove)===true?this.value:","+this.value);			
			}
		});
		param.userNo = $("#viewForm #no").val();		
		
		if(param.add === "" && param.remove === ""){
			alert("수정할 내용이 없습니다."); return;
		}
		
		cfnCmmAjax("/admin/applyUserAuthList", param).done(function(data){
			cfnSelectAuth(param.userNo).done(function(data){
        		$("input:checkbox[name='check']").data("state", "none").prop("checked", false);
        		for(let i=0; i<data.length; i++){
        			$("#authList #"+data[i].authNm).data("state", "have").prop("checked", true);
        		}
        		alert("권한을 적용하였습니다.");
        	});
			
		});
	});
	
	//닫기
	$("#viewForm #close").on("click", function(){
		$("#viewForm").clear().hide();
	})
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
        		
   		pagerContainer: "#userPager",
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
            	
            	return cfnCmmAjax("/admin/selectUserList", param, true);
            }
        },
        rowClick: function(args) {
        	$("#viewForm").setParam(args.item).show();
        	cfnSelectAuth(args.item.no).done(function(data){
        		$("input:checkbox[name='check']").data("state", "none").prop("checked", false);
        		for(let i=0; i<data.length; i++){
        			$("#authList #"+data[i].authNm).data("state", "have").prop("checked", true);
        		}
        	});
        }, 
        fields: [
			{ title:"번호",	name:"no",		type:"text", width: "5%",	align:"center"},
			{ title:"아이디",	name:"userId",	type:"text", width: "40%",	align:"center"},
			{ title:"이름",	name:"userNm",	type:"text", width: "55%",	align:"center"}
        ]
    });
}


//form clear
$.fn.clear = function() {
	return this.each(function() {
		let type = this.type, tag = this.tagName.toLowerCase();
		if (tag === 'form'){
			return $(':input',this).clear();
		}
		if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
			this.value = '';
		}else if (type === 'checkbox' || type === 'radio'){
			this.checked = false;
			this.value = '';
		}else if (tag === 'select'){
			this.selectedIndex = 0;
		}else if(tag === "span"){
			$(this).text("");
		}else if(tag === "label"){
			$(this).text("");
		}
		$(this).removeData();
    });
};

//form getParam
$.fn.getParam = function() {
	let param = {};	
	this.find("*").each(function(){
		if(this.value !== undefined){
			let type = this.type, tag = this.tagName.toLowerCase();			
			if(type === "text" || type === "password" || type === "hidden" || tag === "textarea"){
				param[this.id] = this.value;
			}else if(tag === "select"){
				param[this.id] = this.value;
			}else if (type === 'checkbox'){
				
			}else if(type === 'radio'){
				
			}
		}		
	});
	return param;	
};

//form setParam
$.fn.setParam = function(param){
	this.find("*").each(function(){
		if(param[this.id] !== undefined){
			let type = this.type, tag = this.tagName.toLowerCase();
			if(type === "text" || type === "password" || type === "hidden" || tag === "textarea"){
				this.value = param[this.id];
			}else if(tag === "select"){
				$(this).val(param[this.id]).prop("selected", true);			
			}else if (type === 'checkbox'){
				$(this).prop("checked", true).val(param[this.id]);
			}else if(type === 'radio'){				
			
			}else if(tag === "span"){
				$(this).text(param[this.id]);
			}else if(tag === "label"){
				$(this).text(param[this.id]);
			}
		}		
	});
	return this;
}
</script>



<!-- 글보기 -->
<form id="viewForm" class="blank hide" onsubmit="return false;">	
	<input id="no" type="hidden" value="">
	
	<div>
		<span class="span-gray-rt">번호</span>
		<span id="no" class="span-gray"></span>
		<span class="span-gray-rt">아이디</span>
		<span id="userId" class="span-gray"></span>
		<span class="span-gray-rt">이름</span>
		<span id="userNm" class="span-gray"></span>
		<div class="pull-right">			
			<button id="save" class="btn-gray trs">저장</button>
			<button id="close" class="btn-gray trs">닫기</button>	
		</div>	
	</div>
	
	<div class="flex blank">
		<div class="flex-left wth1 left-head border-gray hht1-li">권한설정</div>
		<div id="authList" class="flex-right border-gray hht1"></div>			
	</div>	
</form>

<!-- 검색 -->
<form id="searchForm" name="searchForm" onsubmit="return false;">
	<input id="type" type="hidden" value="">
	<input id="text" type="hidden" value="">
</form>

<!-- 조회 입력란 -->
<div>
	<div>
		<div class="title-icon"></div>
		<label class="title">사용자 정보</label>
	</div>
	<div id="searchBar" class="search-bar">
		<table class="wth100p">
			<colgroup>
				<col width="5%" class="search-th"/>
				<col width="10%">
				<col width="5%" class="search-th"/>
				<col width="10%"/>
				<col width="*"/>
			</colgroup>
			<tr>
				<th>검색구분</th>
				<td>
					<select class="select-gray wth100p" id="type">
						<option value="id">아이디</option>
						<option value="name">이름</option>
					</select>
				</td>
				<th>검색명</th>
				<td>
					<input class="input-gray wth3 wth100p" id="text" type="text">
				</td>
				<td>
					<div class="btn-right">
						<button class="btn-gray trs" id="searchBtn">조회</button>	
					</div>										
				</td>
			</tr>
		</table>
	</div>
</div>

<div id="userList"></div>
<div id="userPager" class="pager"></div>