<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){
	//권한리스트 조회
	cfnSelectAuth().done(fnJsGrid);
});

//권한 grid
function fnJsGrid(data){
	
	for(let i=0; i<data.length; i++){
		data[i].state = "select";
	}
	
	let clone = common.clone(data);
	let authList = data;
	let authNoIdx = cfnNoIdx(authList, "authSeq");
	let cloneNoIdx = cfnNoIdx(clone, "authSeq");
	
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
				headerTemplate : function(){
					return $("<button>").attr("id", "add").addClass("btn-gray trs size-sm").text("+").on("click", function(){
						authList.push({authCmt:"", 
							authOrder: $("#authList").jsGrid("option", "data").length+1,
							authSeq:new Date().getTime(), 
							authNm:"", 
							state:"insert"});
						authNoIdx = cfnNoIdx(authList, "authSeq");
						$("#authList").jsGrid("refresh");
					});			
				},				
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("authSeq", item.authSeq).data("authOrder", item.authOrder).on("change", function() {
                    	let idx = authNoIdx[item.authSeq];
                    	let cIdx = cloneNoIdx[item.authSeq];
                			
               			if(isEmpty(item.authOrder)){
               	    		$("#authList").jsGrid("deleteItem", item);
               	    		delete authNoIdx[item.authSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.authSeq  === $(e).data("authSeq")){
                   	   					$(e).addClass("sync-red");               	   					
                   	   					if(String(clone[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   						authList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.authSeq === $(e).data("authSeq")){
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
					return fnRefreshedSync(item, "authOrder", "span");
				}
			},
			{ title:"권한명",	name:"authNm",		type:"text", align:"center", width: "40%", 
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "authNm", "input");
				}
			},
			{ title:"권한 설명",	name:"authCmt",	type:"text", align:"center", width: "50%",
				itemTemplate: function(value, item){					
					return fnRefreshedSync(item, "authCmt", "input");
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
					authNoIdx = cfnNoIdx(authList, "authSeq");
					for(let i=0; i<items.length; i++){						
						fnOnSync($("#authList .ui-sortable tr span")[i], i);
					}
				}
			});
			
			//수정 sync 체크
			$("input[name='sync']").on("keyup keydown change", function(){	
				fnOnSync(this);
			});
		}
	});
	
	//취소
	$("#btns #cancelBtn").on("click", function(){
		authList.splice(0, authList.length);
		for(let i=0; i<clone.length; i++){
			authList.push(common.clone(clone[i]));
		}
		$("#authList").jsGrid("refresh");		
	});
	
	//리스트 수
	/* $("#searchBar #pageSize").on("change", function(){
		let pageSize = String(this.value);
		if(pageSize === "all"){
			$("#authList").jsGrid("option", "paging", false);
		}else{
			$("#authList").jsGrid("option", "paging", true);
			$("#authList").jsGrid("option", "pageSize", Number(pageSize));
		}
	}); */
	
	//저장(반영)
	$("#btns #saveBtn").on("click", function(){
		
		//유효성 검사
		let isVali = true;
		$("input[name='sync']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){
			case "authNm":
				if(!isOnlyAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			case "authCmt":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 50){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 50자 까지 입력할 수 있습니다."}); return false;
				}
				break;			
			}			
		});
				
		let applyList = new Array();
		for(let i=0, j=1; i<authList.length; i++){
			if(authList[i].state !== "select"){
				applyList.push(authList[i]);
			}
		}
		
		if(applyList.length === 0){
			alert("저장할 데이터가 없습니다.");
		}else if(isVali && confirm("저장하시겠습니까?")){
			
			let param = {};
			param.clone = JSON.stringify(clone);
			param.authList = JSON.stringify(applyList);			
			cfnCmmAjax("/admin/applyAuthList", param).done(function(res){
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");
				}else if(Number(res)===0){
					alert("삭제하려는 권한이 사용중 입니다. 반영이 취소됩니다.");
				}else{
					alert("반영되었습니다.");
				}
				mf.submit('${navUrl}', '${sideUrl}', '${navNm}', '${sideNm}');				
			});
		}
	});
	
	//수정 sync 체크
	function fnOnSync(obj, sortIdx){
		
		let name = $(obj).data("name");
		let idx = authNoIdx[$(obj).data("authSeq")];
		let cIdx = cloneNoIdx[$(obj).data("authSeq")];
		
		if($(obj).hasClass("sync-green")){
			if(isEmpty(sortIdx)) authList[idx][name] = $(obj).val();
			else authList[idx][name] = sortIdx+1;
		}else{
			if(isEmpty(sortIdx)){
				authList[idx][name] = $(obj).val();
				if(String(clone[cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) authList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) authList[idx].state = "update";
				}
			}else{
				authList[idx][name] = sortIdx+1;
				if(idx === sortIdx){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) authList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) authList[idx].state = "update";
				}
			}
		}
	}
	
	//새로고침 sync
	function fnRefreshedSync(item, name, tag){
		
		let $el = null;
		switch(tag){
		case "input" :
			$el = $("<input>").attr("type", "text").addClass("input-gray wth100p").val(item[name]);
			break;
		case "span" :
			$el = $("<span>").val(item[name]).text(item[name]);
			break;
		}
		$el.attr("name", "sync").data("authSeq", item.authSeq).data("name", name);		

		if(item.state === "insert") $el.addClass("sync-green");	
		else if(item.state === "update"){									
			if(clone[cloneNoIdx[item.authSeq]][name] === item[name]){
				$el.removeClass("sync-blue");
			}else{
				$el.addClass("sync-blue");
			}			
		}else if(item.state === "delete"){
				$el.addClass("sync-red");
			if(clone[cloneNoIdx[item.authSeq]][name] !== $el.val()){
				$el.addClass("sync-blue");
			}
		}		
		return $el;
	}
}
</script>

<div class="button-bar">
	<div id="btns" class="btn-right">
		<button id="saveBtn" class="btn-gray trs">저장</button>
		<button id="cancelBtn" class="btn-gray trs">취소</button>
	</div>
</div>

<div>
	<div>
		<div class="title-icon"></div>
		<label class="title">권한 목록</label>
	</div>
	<div id="authList"></div>
</div>