<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/ledger/selectAllPurList", {codePrt:"LP"}).done(fnPurGrid);
});

function fnPurGrid(data){
	
	for(let i=0; i<data.purList.length; i++){
		data.purList[i].state = "select";
	}
	
	let clone = common.clone(data);
	data.purDtlList = null;
	
	let purNoIdx = cfnNoIdx(data.purList, "purSeq");
	let purCloneNoIdx = cfnNoIdx(clone.purList, "purSeq");
	let purDtlNoIdx = null;
	let purDtlCloneNoIdx = null;
	let initPurDtl = true;
	let refPurSeq = isEmpty("${prevParam}")?clone.purList[0].purSeq:Number("${prevParam}");
	
	$("#purList").jsGrid({
		height: "auto",
		width: "51%",		
		
		autoload: true,     
		data: data.purList,
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [			
			{ align:"center", width: "8%",
				headerTemplate : function(){
					return $("<button>").attr("id", "purAdd").addClass("btn-gray trs sm").text("+").on("click", function(){
						data.purList.push({purpose: "", purOrder:"", purSeq: new Date().getTime(), state:"insert"});		
						purNoIdx = cfnNoIdx(data.purList, "purSeq");
						$("#purList").jsGrid("refresh");
					});			
				},
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("purSeq", item.purSeq).data("purOrder", item.purOrder).on("change", function() {
                    	let idx = purNoIdx[item.purSeq];
                    	let cIdx = purCloneNoIdx[item.purSeq];
                			
               			if(isEmpty(item.purOrder)){
               	    		$("#purList").jsGrid("deleteItem", item);
               	    		delete purNoIdx[item.purSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='syncPur']").each(function(i, e){
                   	   				if(item.purSeq  === $(e).data("purSeq")){
                   	   					$(e).addClass("sync-red");
                   	   					
                   	   					if(String(clone.purList[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   	   					data.purList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='syncPur']").each(function(i, e){
                   	   				if(item.purSeq === $(e).data("purSeq")){
                   	   					$(e).removeClass("sync-red");
                   	   					
                   	   					if($(e).hasClass("sync-blue") || data.purList[idx].state === "update" ){
                   	   						data.purList[idx].state = "update";
                   	   					}else{   						
                   	   						data.purList[idx].state = "select";
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
			{ title:"순서",	name:"purOrder",	type:"text", align:"center", width: "10%"},
			{ title:"목적",	name:"purpose",		type:"text", align:"center", width: "54%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "purpose", "purList", "input");
				}
			},
			{ title:"목적 종류",	name:"purType",		type:"text", align:"center", width: "20%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "purType", "purList", "select");
				}
			},
			{ title:"보기", align:"center", width: "8%",
				itemTemplate: function(value, item){					
					if(item.state === "insert"){
						return "";
					}else{
						return $("<button>").addClass("btn-gray sm").text(">").data("purSeq", item.purSeq)
							.attr("name", "svb").on("click", function(){						
							
							$("button[name='svb']").each(function(i, e){
								$(e).removeClass("btn-selected-gray");
							});
							$(this).addClass("btn-selected-gray");
							
							refPurSeq = item.purSeq;
							data.purDtlList = new Array();
							for(let i=0; i<clone.purDtlList.length; i++){
								if(item.purSeq === clone.purDtlList[i].purSeq){
									data.purDtlList.push(common.clone(clone.purDtlList[i]));
								}							
							}
							fnPurDtlJsGrid();
						});
					}
				}
			}
		],
		onRefreshed: function() {
			let $gridData = $("#purList .jsgrid-grid-body tbody");
			$gridData.sortable({
				update: function(e, ui) {
					let items = $.map($gridData.find("tr"), function(row) {
						return $(row).data("JSGridItem");
					});
					
					data.purList.splice(0, data.purList.length);
					for(let i=0; i<items.length; i++){
						data.purList.push(items[i]);
					}
					$("#purList").jsGrid("refresh");
					purNoIdx = cfnNoIdx(data.purList, "purSeq");
				}
			});
			
			//수정 intpu sync 체크			
			$("input[name='syncPur']").on("keyup keydown change", function(){		
				fnOnSync(this, "purList");
			});
			
			//수정 select sync 체크
			$("select[name='syncPur']").on("change", function(){				
				fnOnSync(this, "purList");	
			});			
			
			if(initPurDtl){
				data.purDtlList = new Array();
				if(clone.purDtlList.length > 0){
					
					for(let i=0; i<clone.purDtlList.length; i++){
						if(refPurSeq === clone.purDtlList[i].purSeq){
							data.purDtlList.push(common.clone(clone.purDtlList[i]));
						}
					}
					$("button[name='svb']").each(function(i, e){
						if(refPurSeq === Number($(e).data("purSeq"))){
							$(e).addClass("btn-selected-gray");
							return;
						}
					});
				}
				fnPurDtlJsGrid();
				initPurDtl = false;
			}else{
				$("button[name='svb']").each(function(i, e){
					if(refPurSeq === Number($(e).data("purSeq"))){
						$(e).addClass("btn-selected-gray");
						return;
					}
				});
			}
		}	
	});
	
	function fnPurDtlJsGrid(){		
		$("#purDtlList").empty();
		
		for(let i=0; i<data.purDtlList.length; i++){
			data.purDtlList[i].state = "select";
		}
		
		purDtlNoIdx = cfnNoIdx(data.purDtlList, "purDtlSeq");
		purDtlCloneNoIdx = cfnNoIdx(clone.purDtlList, "purDtlSeq");
		
		$("#purDtlList").jsGrid({
			height: "auto",
			width: "48%",
			
			data: data.purDtlList,
			
			paging: false,
			pageSize: 10,
			
			fields: [
				{ align:"center", width: "8%",
					headerTemplate : function(){
						return $("<button>").attr("id", "purDtlAdd").addClass("btn-gray trs sm").text("+").on("click", function(){
							data.purDtlList.push({purSeq: refPurSeq, purDetail:"", purDtlOrder:"", purDtlSeq: new Date().getTime(), state:"insert"});		
							purDtlNoIdx = cfnNoIdx(data.purDtlList, "purDtlSeq");
							$("#purDtlList").jsGrid("refresh");
						});					
					},
	                itemTemplate: function(value, item) {
	                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
	                    .data("purDtlSeq", item.purDtlSeq).data("purDtlOrder", item.purDtlOrder).on("change", function() {
	                    	let idx = purDtlNoIdx[item.purDtlSeq];
	                    	let cIdx = purDtlCloneNoIdx[item.purDtlSeq];
	                			
	               			if(isEmpty(item.purDtlOrder)){
	               	    		$("#purDtlList").jsGrid("deleteItem", item);
	               	    		delete purDtlNoIdx[item.purDtlSeq];               	    		
	               	    	}else{
	               	    		if($(this).is(":checked")) {
	                   	   			$("[name='syncPurDtl']").each(function(i, e){
	                   	   				if(item.purDtlSeq  === $(e).data("purDtlSeq")){
	                   	   					$(e).addClass("sync-red");
	                   	   					
	                   	   					if(String(clone.purDtlList[cIdx][$(e).data("name")]) !== String($(e).val())){
	                   	   						$(e).addClass("sync-blue");
	                   	   					}
	                   	   					data.purDtlList[idx].state = "delete";
	                   	   				}
	                   	   			});
	                   	   		}else{
	                   	   			$("[name='syncPurDtl']").each(function(i, e){
	                   	   				if(item.purDtlSeq === $(e).data("purDtlSeq")){
	                   	   					$(e).removeClass("sync-red");
	                   	   					
	                   	   					if($(e).hasClass("sync-blue") || data.purDtlList[idx].state === "update" ){
	                   	   						data.purDtlList[idx].state = "update";
	                   	   					}else{
	                   	   						data.purDtlList[idx].state = "select";
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
				{ title:"순서",	name:"purDtlOrder",	type:"text", align:"center", width: "12%"},
				{ title:"상세목적",	name:"purDetail",		type:"text", align:"center", width: "80%",
					itemTemplate: function(value, item){													
						return fnRefreshedSync(item, "purDetail", "purDtlList", "input");
					}
				}				
			],
			onRefreshed: function() {
				let $gridData = $("#sideMenuList .jsgrid-grid-body tbody");
				$gridData.sortable({
					update: function(e, ui) {
						let items = $.map($gridData.find("tr"), function(row) {
							return $(row).data("JSGridItem");
						});
						
						data.purDtlList.splice(0, data.purDtlList.length);
						for(let i=0; i<items.length; i++){
							data.purDtlList.push(items[i]);
						}
						$("#purDtlList").jsGrid("refresh");
						purDtlNoIdx = cfnNoIdx(data.purDtlList, "purDtlSeq");
					}
				});
				
				//수정 intpu sync 체크
				$("input[name='syncPurDtl']").on("keyup keydown change", function(){	
					fnOnSync(this, "purDtlList");
				});
			}
		});
	}
	
	function fnOnSync(obj, listName){
		
		if(listName === "purList"){
			
			if($(obj).hasClass("sync-green")){
				data.purList[purNoIdx[$(obj).data("purSeq")]][$(obj).data("name")] = $(obj).val();
			}else{
				let name = $(obj).data("name");
				let idx = purNoIdx[$(obj).data("purSeq")];
				let cIdx = purCloneNoIdx[$(obj).data("purSeq")];
				
				data.purList[idx][name] = $(obj).val();
				
				if(String(clone.purList[cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.purList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.purList[idx].state = "update";
				}
			}
		}else if(listName === "purDtlList"){
			
			if($(obj).hasClass("sync-green")){
				data.purDtlList[purDtlNoIdx[$(obj).data("purDtlSeq")]][$(obj).data("name")] = $(obj).val();
			}else{
				let name = $(obj).data("name");
				let idx = purDtlNoIdx[$(obj).data("purDtlSeq")];
				let cIdx = purDtlCloneNoIdx[$(obj).data("purDtlSeq")];
				
				data.purDtlList[idx][name] = $(obj).val();			
				
				if(String(clone.purDtlList[cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.purDtlList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.purDtlList[idx].state = "update";
				}
			}
		}
	}
	
	//새로고침 sync			
	function fnRefreshedSync(item, name, listName, tag){
		
		let $el = null;
		switch(tag){
		case "input" :
		default :
			$el = $("<input>").attr("type", "text").addClass("input-gray wth100p").val(item[name]);
			break;
		case "select" : 
			$el = $("<select>").addClass("select-gray");
			let $option = null;
			if(item.state === "insert"){
				$el.append($("<option>").text("").val(""));
			}			
			for(let i=0; i<data.purTypeList.length; i++){
				$option = $("<option>").text(data.purTypeList[i].codeNm).val(data.purTypeList[i].code);				
				if(String(item[name]) === String(data.purTypeList[i].code)){
					$el.append($option.attr("selected","selected"));
				}
				$el.append($option);
			}		
			break;
		}
		
		if(listName === "purList"){
			
			$el.attr("name", "syncPur").data("purSeq", item.purSeq).data("name", name);		

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){									
				if(String(clone[listName][purCloneNoIdx[item.purSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");				
				if(String(clone[listName][purCloneNoIdx[item.purSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}		
		}else if(listName === "purDtlList"){
			
			$el.attr("name", "syncPurDtl").data("purDtlSeq", item.purDtlSeq).data("name", name);		

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){									
				if(String(clone[listName][purDtlCloneNoIdx[item.purDtlSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");
				if(String(clone[listName][purDtlCloneNoIdx[item.purDtlSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}		
		}		
		return $el;
	}
	
	//저장(반영)
	$("#searchBar #purSave").on("click", function(){		
		//유효성 검사
		let isVali = true;
		$("[name='syncPur']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){
			case "navNm":			
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			case "navUrl":			
				if(!isOnlyOneURL($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "첫번째 문자에 /, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 40){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 40자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			}			
		});
		
		if(isVali && confirm("저장하시겠습니까?")){
			
			for(let i=0, j=1; i<data.navList.length; i++){
				if(data.navList[i].state !== "delete"){
					data.navList[i].navOrder = (j++);	
				}
			}
			
			let param = {};
			param.purClone = JSON.stringify(clone.purList);
			param.purList = JSON.stringify(data.purList);
			
			cfnCmmAjax("/admin/applyPurList", param).done(function(res){
				
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");
				}else if(Number(res)===-2){
					alert("삭제하려는 상위메뉴가 하위메뉴에서 사용중 입니다. 반영이 취소됩니다.");
				}else{					
					cfnCmmAjax("/admin/selectPurList", param).done(function(result){
						initSide = false;
						clone.purList = common.clone(result);
						data.purList.splice(0, data.purList.length);
						
						for(let i=0; i<result.length; i++){
							data.purList.push(result[i]);
						}
						
						$("#purList").jsGrid("refresh");
						purNoIdx = cfnNoIdx(data.purList, "purSeq");
						purCloneNoIdx = cfnNoIdx(clone.purList, "purSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//취소
	$("#searchBar #cancel").on("click", function(){		
		initPurDtl = true;
		data.purList.splice(0, data.purList.length);
		for(let i=0; i<clone.purList.length; i++){
			data.purList.push(clone.purList[i]);
		}
		$("#purList").jsGrid("refresh");		
	});
}
</script>


<div id="searchBar" class="search-bar pull-right">	
	<button id="purSave" class="btn-gray trs ">목적 저장</button>
	<button id="purDtlSave" class="btn-gray trs ">상세목적 저장</button>
	<button id="cancel" class="btn-gray trs">취소</button>
</div>

<div style="margin-top: 50px;">
	<div id="purList" class="pull-left"></div>
	<div id="purDtlList"  class="pull-right"></div>
</div>