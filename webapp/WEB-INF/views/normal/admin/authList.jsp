<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<style>
.jsgrid-cell {padding: 0 0 0 0;}
</style>
<script type="text/javascript">
$(document).ready(function(){
	//권한리스트 조회
	cfnSelectAuth().done(function(data){
		fnJsGrid(data);
	});
});

//권한 grid
function fnJsGrid(data){
	
	for(let i=0; i<data.length; i++){
		data[i].state = "select";
	}
	
	let clone = common.clone(data);
	let authList = data;
	let authNoIdx = cfnNoIdx(authList, "authNmSeq");
	
	$("#authList").jsGrid({
		height: "auto",
		width: "100%",
		
		autoload: true,     
		data: authList,
		
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [
			{ align:"center", width: "5%",
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("authNmSeq", item.authNmSeq).data("authOrder", item.authOrder).on("change", function() {
                    	let idx = authNoIdx[item.authNmSeq];
                			
               			if(isEmpty(item.authOrder)){
               	    		$("#authList").jsGrid("deleteItem", item);
               	    		delete authNoIdx[item.authNmSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("input[name='sync']").each(function(i, e){				
                   	   				if(item.authNmSeq  === $(e).data("authNmSeq")){
                   	   					$(e).addClass("sync-red");               	   					
                   	   					if(clone[idx][$(e).data("name")] !== $(e).val()){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   						authList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("input[name='sync']").each(function(i, e){				
                   	   				if(item.authNmSeq === $(e).data("authNmSeq")){
                   	   					$(e).removeClass("sync-red");               	   					
                   	   					if($(e).hasClass("sync-blue") || authList[idx].state === "update"){
                   	   						authList[idx].state = "update";
                   	   					}else{   						
                   	   						authList[idx].state = "select";
                   	   					}   					
                   	   				}
                   	   			});
                   	    	}
               	    	}
                	});                    
                    if(item.state === "delete") chk.prop('checked', true);                    	
                    return chk;
                }	            
			},
			{ title:"순서",	name:"authOrder",	type:"text", align:"center", width: "5%",
				itemTemplate: function(value, item){
					return isEmpty(value) ? "" : Number(value)-1;					 
				}
			},
			{ title:"권한명",	name:"authNm",		type:"text", align:"center", width: "40%", 
				itemTemplate: function(value, item){
					$(this).removeClass("jsgrid-cell");									
					return fnRefreshedSync(item, "authNm");
				}
			},
			{ title:"권한 설명",	name:"authCmt",	type:"text", align:"center", width: "50%",
				itemTemplate: function(value, item){
					$(this).removeClass("jsgrid-cell");
					return fnRefreshedSync(item, "authCmt");
				}
			}
		],
		onRefreshed: function() {
			let $gridData = $("#authList .jsgrid-grid-body tbody");
			$gridData.sortable({
				update: function(e, ui) {
					let items = $.map($gridData.find("tr"), function(row) {
						return $(row).data("JSGridItem");
					});
					
					authList.splice(0, authList.length);
					for(let i=0; i<items.length; i++){
						authList.push(items[i]);
					}
					$("#authList").jsGrid("refresh");
				}
			});
			
			//수정 sync 체크
			let name, idx;
			$("input[name='sync']").on("keyup keydown change", function(){				
				if($(this).hasClass("sync-green")){
					authList[authNoIdx[$(this).data("authNmSeq")]][$(this).data("name")] = $(this).val();
				}else{					
					name = $(this).data("name");
					idx = authNoIdx[$(this).data("authNmSeq")];
				
					authList[idx][name] = $(this).val();
					
					if(clone[idx][name] === $(this).val()){		
						$(this).removeClass("sync-blue");
						if(!$(this).hasClass("sync-red")) authList[idx].state = "select";
					}else{
						$(this).addClass("sync-blue");
						if(!$(this).hasClass("sync-red")) authList[idx].state = "update";
					}
				}
			});
		}
	});
	
	//권한추가
	$("#searchBar #add").on("click", function(){
		authList.push({authCmt:"", authOrder: "", authNmSeq:new Date().getTime(), authNm:"", state:"insert"});
		authNoIdx = cfnNoIdx(authList, "authNmSeq");
		$("#authList").jsGrid("refresh");
	});
	
	//취소
	$("#searchBar #cancel").on("click", function(){		
		authList.splice(0, authList.length);
		for(let i=0; i<clone.length; i++){
			authList.push(clone[i]);
		}
		$("#authList").jsGrid("refresh");		
	});
	
	//리스트 수
	$("#searchBar #pageSize").on("change", function(){
		let pageSize = String(this.value);
		if(pageSize === "all"){
			$("#authList").jsGrid("option", "paging", false);
		}else{
			$("#authList").jsGrid("option", "paging", true);
			$("#authList").jsGrid("option", "pageSize", Number(pageSize));
		}
	});
	
	//저장(반영)
	$("#searchBar #save").on("click", function(){
		
		//유효성 검사
		let checkItem = ["authCmt", "authNm"];
		for(let i=0; i<authList.length; i++){
			for(let j=0; j<checkItem.length; j++){
				if(isEmpty(authList[i][checkItem[j]])){						
					$("input[name='sync']").each(function(idx, e){						
       	   				if(authList[i].authNmSeq === $(e).data("authNmSeq") && checkItem[j] === $(e).data("name")){
	       	   				wVali.alert({
	       	   					element : $(e),
	    						checkItem: checkItem[j], 
	    						msg: "값을 입력해 주세요."
	    					});	       	   				
       	   				}
       	   			});
					return;
				}
			}
		}
		
		let param = {};
		param.clone = JSON.stringify(clone);
		param.authList = JSON.stringify(authList);
		
		cfnCmmAjax("/admin/applyAuthList", param).done(function(){
			cfnSelectAuth().done(function(data){
				fnJsGrid(data);
			});
		});
		
	});
	
	//새로고침 sync
	function fnRefreshedSync(item, name){	
		let el = $("<input>").attr("type", "text").attr("name", "sync")
			.data("authNmSeq", item.authNmSeq).data("name", name)
			.addClass("input-gray wth100p").val(item[name]);

		if(item.state === "insert") $(el).addClass("sync-green");	
		else if(item.state === "update"){									
			if(clone[authNoIdx[item.authNmSeq]][name] === item[name]){
				$(el).removeClass("sync-blue");
			}else{
				$(el).addClass("sync-blue");
			}			
		}else if(item.state === "delete"){
			$(el).addClass("sync-red");
			if(clone[authNoIdx[item.authNmSeq]][name] !== $(el).val()){
				$(el).addClass("sync-blue");
			}
		}		
		return el;
	}
}
</script>

<div id="searchBar" class="search-bar">
	<button id="add" class="btn-gray">추가</button>
	<div class="pull-right">		
		<select id="pageSize" class="select-gray">
			<option value="all">전체</option>
			<option value="20">20개</option>
			<option value="10">10개</option>
			<option value="5">5개</option>
		</select>	
		<button id="save" class="btn-gray">저장</button>
		<button id="cancel" class="btn-gray">취소</button>
	</div>
</div>
<div id="authList"></div>