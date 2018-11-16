<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/admin/selectMenuList").done(fnNavJsGrid);
});

function fnNavJsGrid(data){

	for(let i=0; i<data.navList.length; i++){
		data.navList[i].state = "select";
	}

	let clone = common.clone(data);
	data.sideList = null;
	
	let navNoIdx = cfnNoIdx(data.navList, "navSeq");
	let navCloneNoIdx = cfnNoIdx(clone.navList, "navSeq");
	let sideNoIdx = null;
	let sideCloneNoIdx = null;
	let initSide = true;
	let refNavSeq = isEmpty("${prevParam}")?clone.navList[0].navSeq:Number("${prevParam}");
	
	$("#navMenuList").jsGrid({
		height: "auto",
		width: "51%",		
		
		autoload: true,     
		data: data.navList,
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [			
			{ align:"center", width: "6%",
				headerTemplate : function(){
					return $("<button>").attr("id", "navAdd").addClass("btn-gray trs sm").text("+").on("click", function(){
						data.navList.push({navAuthNmSeq: "", navNm: "", navOrder:"", navSeq: new Date().getTime(), navShowYn:"N", navUrl:"", state:"insert"});		
						navNoIdx = cfnNoIdx(data.navList, "navSeq");
						$("#navMenuList").jsGrid("refresh");
					});					
				},
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("navSeq", item.navSeq).data("navOrder", item.navOrder).on("change", function() {
                    	let idx = navNoIdx[item.navSeq];
                    	let cIdx = navCloneNoIdx[item.navSeq];
                			
               			if(isEmpty(item.navOrder)){
               	    		$("#navMenuList").jsGrid("deleteItem", item);
               	    		delete navNoIdx[item.navSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='syncNav']").each(function(i, e){
                   	   				if(item.navSeq  === $(e).data("navSeq")){
                   	   					$(e).addClass("sync-red");
                   	   					
                   	   					if(String(clone.navList[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   	   					data.navList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='syncNav']").each(function(i, e){
                   	   				if(item.navSeq === $(e).data("navSeq")){
                   	   					$(e).removeClass("sync-red");
                   	   					
                   	   					if($(e).hasClass("sync-blue") || data.navList[idx].state === "update" ){
                   	   						data.navList[idx].state = "update";
                   	   					}else{   						
                   	   						data.navList[idx].state = "select";
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
			{ title:"순서",	name:"navOrder",	type:"text", align:"center", width: "8%"},
			{ title:"상위 이름",	name:"navNm",		type:"text", align:"center", width: "21%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "navNm", "navList", "input");
				}
			},
			{ title:"상위 URL",	name:"navUrl",		type:"text", align:"center", width: "33%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "navUrl", "navList", "input");
				}
			},
			{ title:"권한",	name:"navAuthNmSeq", align:"center", width: "20%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "navAuthNmSeq", "navList", "select");
				}
			},
			{ title:"표시",	name:"navShowYn",		type:"text", align:"center", width: "6%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "navShowYn", "navList", "button");
				}
			},
			{ title:"보기", align:"center", width: "6%",
				itemTemplate: function(value, item){					
					if(item.state === "insert"){
						return "";
					}else{
						return $("<button>").addClass("btn-gray sm").text(">").data("navSeq", item.navSeq)
							.attr("name", "svb").on("click", function(){						
							
							$("button[name='svb']").each(function(i, e){
								$(e).removeClass("btn-selected-gray");
							});
							$(this).addClass("btn-selected-gray");
							
							refNavSeq = item.navSeq;
							data.sideList = new Array();
							for(let i=0; i<clone.sideList.length; i++){
								if(item.navSeq === clone.sideList[i].navSeq){
									data.sideList.push(common.clone(clone.sideList[i]));
								}							
							}
							fnSideJsGrid();
						});
					}
				}
			}
		],
		onRefreshed: function() {
			let $gridData = $("#navMenuList .jsgrid-grid-body tbody");
			$gridData.sortable({
				update: function(e, ui) {
					let items = $.map($gridData.find("tr"), function(row) {
						return $(row).data("JSGridItem");
					});
					
					data.navList.splice(0, data.navList.length);
					for(let i=0; i<items.length; i++){
						data.navList.push(items[i]);
					}
					$("#navMenuList").jsGrid("refresh");
					navNoIdx = cfnNoIdx(data.navList, "navSeq");
				}
			});
			
			//수정 intpu sync 체크			
			$("input[name='syncNav']").on("keyup keydown change", function(){		
				fnOnSync(this, "navList");
			});
			
			//수정 select sync 체크
			$("select[name='syncNav']").on("change", function(){				
				fnOnSync(this, "navList");	
			});
			
			//수정 button sync 체크
			$("button[name='syncNav']").on("click", function(){
				if($(this).val() === "Y")	$(this).val("N").text("N");
				else						$(this).val("Y").text("Y");
				
				fnOnSync(this, "navList");
			});
			
			if(initSide){
				data.sideList = new Array();
				if(clone.sideList.length > 0){
					
					for(let i=0; i<clone.sideList.length; i++){
						if(refNavSeq === clone.sideList[i].navSeq){
							data.sideList.push(common.clone(clone.sideList[i]));
						}
					}
					$("button[name='svb']").each(function(i, e){
						if(refNavSeq === Number($(e).data("navSeq"))){
							$(e).addClass("btn-selected-gray");
							return;
						}
					});
				}
				fnSideJsGrid();
				initSide = false;
			}else{
				$("button[name='svb']").each(function(i, e){
					if(refNavSeq === Number($(e).data("navSeq"))){
						$(e).addClass("btn-selected-gray");
						return;
					}
				});
			}
		}	
	});	
	
	function fnSideJsGrid(){		
		$("#sideMenuList").empty();
		
		for(let i=0; i<data.sideList.length; i++){
			data.sideList[i].state = "select";
		}
		
		sideNoIdx = cfnNoIdx(data.sideList, "sideSeq");
		sideCloneNoIdx = cfnNoIdx(clone.sideList, "sideSeq");
		
		$("#sideMenuList").jsGrid({
			height: "auto",
			width: "48%",
			
			data: data.sideList,
			
			paging: false,
			pageSize: 10,
			
			fields: [
				{ align:"center", width: "7%",
					headerTemplate : function(){
						return $("<button>").attr("id", "sideAdd").addClass("btn-gray trs sm").text("+").on("click", function(){
							data.sideList.push({navSeq: refNavSeq, sideAuthNmSeq:"", sideNm:"", sideOrder:"", sideSeq: new Date().getTime(), sideShowYn:"N", sideUrl:"", state:"insert"});		
							sideNoIdx = cfnNoIdx(data.sideList, "sideSeq");
							$("#sideMenuList").jsGrid("refresh");
						});					
					},
	                itemTemplate: function(value, item) {
	                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
	                    .data("sideSeq", item.sideSeq).data("sideOrder", item.sideOrder).on("change", function() {
	                    	let idx = sideNoIdx[item.sideSeq];
	                    	let cIdx = sideCloneNoIdx[item.sideSeq];
	                			
	               			if(isEmpty(item.sideOrder)){
	               	    		$("#sideMenuList").jsGrid("deleteItem", item);
	               	    		delete sideNoIdx[item.sideSeq];               	    		
	               	    	}else{
	               	    		if($(this).is(":checked")) {
	                   	   			$("[name='syncSide']").each(function(i, e){
	                   	   				if(item.sideSeq  === $(e).data("sideSeq")){
	                   	   					$(e).addClass("sync-red");
	                   	   					
	                   	   					if(String(clone.sideList[cIdx][$(e).data("name")]) !== String($(e).val())){
	                   	   						$(e).addClass("sync-blue");
	                   	   					}
	                   	   					data.sideList[idx].state = "delete";
	                   	   				}
	                   	   			});
	                   	   		}else{
	                   	   			$("[name='syncSide']").each(function(i, e){
	                   	   				if(item.sideSeq === $(e).data("sideSeq")){
	                   	   					$(e).removeClass("sync-red");
	                   	   					
	                   	   					if($(e).hasClass("sync-blue") || data.sideList[idx].state === "update" ){
	                   	   						data.sideList[idx].state = "update";
	                   	   					}else{
	                   	   						data.sideList[idx].state = "select";
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
				{ title:"순서",	name:"sideOrder",	type:"text", align:"center", width: "9%"},
				{ title:"하위 이름",	name:"sideNm",		type:"text", align:"center", width: "20%",
					itemTemplate: function(value, item){													
						return fnRefreshedSync(item, "sideNm", "sideList", "input");
					}
				},
				{ title:"하위 URL",	name:"sideUrl",		type:"text", align:"center", width: "37%",
					itemTemplate: function(value, item){													
						return fnRefreshedSync(item, "sideUrl", "sideList", "input");
					}
				},
				{ title:"권한",	name:"sideAuthNmSeq", align:"center", width: "20%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "sideAuthNmSeq", "sideList", "select");
					}
				},				
				{ title:"표시",	name:"sideShowYn",		type:"text", align:"center", width: "7%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "sideShowYn", "sideList", "button");
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
						
						data.sideList.splice(0, data.sideList.length);
						for(let i=0; i<items.length; i++){
							data.sideList.push(items[i]);
						}
						$("#sideMenuList").jsGrid("refresh");
						sideNoIdx = cfnNoIdx(data.sideList, "sideSeq");
					}
				});
				
				//수정 intpu sync 체크
				$("input[name='syncSide']").on("keyup keydown change", function(){	
					fnOnSync(this, "sideList");
				});
				
				//수정 select sync 체크
				$("select[name='syncSide']").on("change", function(){			
					fnOnSync(this, "sideList");
				});
				
				//수정 button sync 체크
				$("button[name='syncSide']").on("click", function(){			
					if($(this).val() === "Y")	$(this).val("N").text("N");
					else						$(this).val("Y").text("Y");
					
					fnOnSync(this, "sideList");
				});
			}
		});
	}
	
	function fnOnSync(obj, listName){
		
		if(listName === "navList"){
			
			if($(obj).hasClass("sync-green")){
				data.navList[navNoIdx[$(obj).data("navSeq")]][$(obj).data("name")] = $(obj).val();
			}else{
				let name = $(obj).data("name");
				let idx = navNoIdx[$(obj).data("navSeq")];
				let cIdx = navCloneNoIdx[$(obj).data("navSeq")];
				
				data.navList[idx][name] = $(obj).val();
				
				if(String(clone.navList[cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.navList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.navList[idx].state = "update";
				}
			}
		}else if(listName === "sideList"){
			
			if($(obj).hasClass("sync-green")){
				data.sideList[sideNoIdx[$(obj).data("sideSeq")]][$(obj).data("name")] = $(obj).val();
			}else{
				let name = $(obj).data("name");
				let idx = sideNoIdx[$(obj).data("sideSeq")];
				let cIdx = sideCloneNoIdx[$(obj).data("sideSeq")];
				
				data.sideList[idx][name] = $(obj).val();			
				
				if(String(clone.sideList[cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.sideList[idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data.sideList[idx].state = "update";
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
			for(let i=0; i<data.authList.length; i++){
				$option = $("<option>").text(data.authList[i].authNm).val(data.authList[i].authNmSeq);
				if(String(item[name]) === String(data.authList[i].authNmSeq)){
					$el.append($option.attr("selected","selected"));
				}
				$el.append($option);
			}
			break;			
		case "button" :
			$el = $("<button>").addClass("btn-gray trs sm").val(item[name]).text(item[name]);
			break;
		}
		
		if(listName === "navList"){
			
			$el.attr("name", "syncNav").data("navSeq", item.navSeq).data("name", name);		

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){									
				if(String(clone[listName][navCloneNoIdx[item.navSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");				
				if(String(clone[listName][navCloneNoIdx[item.navSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}		
		}else if(listName === "sideList"){
			
			$el.attr("name", "syncSide").data("sideSeq", item.sideSeq).data("name", name);		

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){									
				if(String(clone[listName][sideCloneNoIdx[item.sideSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");
				if(String(clone[listName][sideCloneNoIdx[item.sideSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}		
		}		
		return $el;
	}
	
	//저장(반영)
	$("#searchBar #navSave").on("click", function(){		
		//유효성 검사
		let isVali = true;
		$("[name='syncNav']").each(function(i, e){
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
			param.navClone = JSON.stringify(clone.navList);
			param.navList = JSON.stringify(data.navList);
			
			cfnCmmAjax("/admin/applyNavMenuList", param).done(function(res){
				
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");
				}else if(Number(res)===-2){
					alert("삭제하려는 상위메뉴가 하위메뉴에서 사용중 입니다. 반영이 취소됩니다.");
				}else{					
					cfnCmmAjax("/admin/selectNavMenuList", param).done(function(result){
						initSide = false;
						clone.navList = common.clone(result);
						data.navList.splice(0, data.navList.length);
						
						for(let i=0; i<result.length; i++){
							data.navList.push(result[i]);
						}
						
						$("#navMenuList").jsGrid("refresh");
						navNoIdx = cfnNoIdx(data.navList, "navSeq");
						navCloneNoIdx = cfnNoIdx(clone.navList, "navSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//side 저장(반영)
	$("#searchBar #sideSave").on("click", function(){
		//유효성 검사
		let isVali = true;
		$("[name='syncSide']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){		
			case "sideNm":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;			
			case "sideUrl":
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
			
			for(let i=0, j=1; i<data.sideList.length; i++){
				if(data.sideList[i].state !== "delete"){
					data.sideList[i].sideOrder = (j++);	
				}
			}
			
			let param = {};			
			param.navSeq = refNavSeq;
			let cloneSideList = new Array();
			
			for(let i=0; i<clone.sideList.length; i++){
				if(refNavSeq === clone.sideList[i].navSeq){
					cloneSideList.push(common.clone(clone.sideList[i]));
				}
			}
			
			param.sideClone = JSON.stringify(cloneSideList);
			param.sideList = JSON.stringify(data.sideList);
			
			cfnCmmAjax("/admin/applySideMenuList", param).done(function(res){
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");				
				}else{					
					cfnCmmAjax("/admin/selectSideMenuList").done(function(result){						
						clone.sideList = common.clone(result);
						data.sideList.splice(0, data.sideList.length);						
						for(let i=0; i<clone.sideList.length; i++){
							if(refNavSeq === clone.sideList[i].navSeq){
								data.sideList.push(common.clone(clone.sideList[i]));
							}
						}						
						$("#sideMenuList").jsGrid("refresh");
						sideNoIdx = cfnNoIdx(data.sideList, "sideSeq");
						sideCloneNoIdx = cfnNoIdx(clone.sideList, "sideSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//취소
	$("#searchBar #cancel").on("click", function(){		
		initSide = true;
		data.navList.splice(0, data.navList.length);
		for(let i=0; i<clone.navList.length; i++){
			data.navList.push(clone.navList[i]);
		}
		$("#navMenuList").jsGrid("refresh");		
	});
}
</script>

<div id="searchBar" class="search-bar pull-right">	
	<button id="navSave" class="btn-gray trs ">상위메뉴 저장</button>
	<button id="sideSave" class="btn-gray trs ">하위메뉴 저장</button>
	<button id="cancel" class="btn-gray trs">취소</button>
</div>

<div style="margin-top: 50px;">
	<div id="navMenuList" class="pull-left"></div>
	<div id="sideMenuList"  class="pull-right"></div>
</div>