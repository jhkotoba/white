<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/admin/selectMenuList").done(fnUpperJsGrid);
});

function fnUpperJsGrid(data){

	for(let i=0; i<data.upperList.length; i++){
		data.upperList[i].state = "select";
	}

	let clone = common.clone(data);
	data.lowerList = null;
	
	let upperNoIdx = cfnNoIdx(data.upperList, "upperSeq");
	let upperCloneNoIdx = cfnNoIdx(clone.upperList, "upperSeq");
	let lowerNoIdx = null;
	let lowerCloneNoIdx = null;
	let initLower = true;
	let refUpperSeq = isEmpty("${prevParam}")?clone.upperList[0].upperSeq:Number("${prevParam}");
	
	$("#upperMenuList").jsGrid({
		height: "auto",
		width: "51%",		
		
		autoload: true,     
		data: data.upperList,
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [			
			{ align:"center", width: "6%",
				headerTemplate : function(){
					return $("<button>").attr("id", "upperAdd").addClass("btn-gray trs size-sm").text("+").on("click", function(){
						data.upperList.push({authSeq: "", 
							upperNm: "",
							upperOdr: $("#upperMenuList").jsGrid("option", "data").length+1,
							upperSeq: new Date().getTime(),
							showYn:"N",
							upperUrl:"",
							state:"insert"});		
						upperNoIdx = cfnNoIdx(data.upperList, "upperSeq");
						$("#upperMenuList").jsGrid("refresh");
					});					
				},
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("upperSeq", item.upperSeq).data("upperOdr", item.upperOdr).on("change", function() {
                    	let idx = upperNoIdx[item.upperSeq];
                    	let cIdx = upperCloneNoIdx[item.upperSeq];
                			
               			if(isEmpty(item.upperOdr)){
               	    		$("#upperMenuList").jsGrid("deleteItem", item);
               	    		delete upperNoIdx[item.upperSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='syncUpper']").each(function(i, e){
                   	   				if(item.upperSeq  === $(e).data("upperSeq")){
                   	   					$(e).addClass("sync-red");
                   	   					
                   	   					if(String(clone.upperList[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   	   					data.upperList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='syncUpper']").each(function(i, e){
                   	   				if(item.upperSeq === $(e).data("upperSeq")){
                   	   					$(e).removeClass("sync-red");
                   	   					
                   	   					if($(e).hasClass("sync-blue") || data.upperList[idx].state === "update" ){
                   	   						data.upperList[idx].state = "update";
                   	   					}else{   						
                   	   						data.upperList[idx].state = "select";
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
			{ title:"순서",	name:"upperOdr",	type:"text", align:"center", width: "8%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "upperOdr", "upperList", "span");
				}
			},
			{ title:"상위 이름",	name:"upperNm",		type:"text", align:"center", width: "21%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "upperNm", "upperList", "input");
				}
			},
			{ title:"상위 URL",	name:"upperUrl",		type:"text", align:"center", width: "33%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "upperUrl", "upperList", "input");
				}
			},
			{ title:"권한",	name:"authSeq", align:"center", width: "20%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "authSeq", "upperList", "select");
				}
			},
			{ title:"표시",	name:"showYn",		type:"text", align:"center", width: "6%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "showYn", "upperList", "button");
				}
			},
			{ title:"보기", align:"center", width: "6%",
				itemTemplate: function(value, item){					
					if(item.state === "insert"){
						return "";
					}else{
						return $("<button>").addClass("btn-gray size-sm").text(">").data("upperSeq", item.upperSeq)
							.attr("name", "svb").on("click", function(){						
							
							$("button[name='svb']").each(function(i, e){
								$(e).removeClass("btn-selected-gray");
							});
							$(this).addClass("btn-selected-gray");
							
							refUpperSeq = item.upperSeq;
							data.lowerList = new Array();
							for(let i=0; i<clone.lowerList.length; i++){
								if(item.upperSeq === clone.lowerList[i].upperSeq){
									data.lowerList.push(common.clone(clone.lowerList[i]));
								}							
							}
							fnLowerJsGrid();
						});
					}
				}
			}
		],
		onRefreshed: function() {
			let $gridData = $("#upperMenuList .jsgrid-grid-body tbody");
			$gridData.sortable({
				update: function(e, ui) {
					let items = $.map($gridData.find("tr"), function(row) {
						return $(row).data("JSGridItem");
					});
					
					upperNoIdx = cfnNoIdx(data.upperList, "upperSeq")
					for(let i=0; i<items.length; i++){
						fnOnSync($("#upperMenuList .ui-sortable tr span")[i], "upperSeq", i);
					}
				}
			});
			
			//수정 intpu sync 체크			
			$("input[name='syncUpper']").on("keyup keydown change", function(){		
				fnOnSync(this, "upperSeq");
			});
			
			//수정 select sync 체크
			$("select[name='syncUpper']").on("change", function(){				
				fnOnSync(this, "upperSeq");	
			});
			
			//수정 button sync 체크
			$("button[name='syncUpper']").on("click", function(){
				if($(this).val() === "Y")	$(this).val("N").text("N");
				else						$(this).val("Y").text("Y");
				
				fnOnSync(this, "upperSeq");
			});
			
			if(initLower){
				data.lowerList = new Array();
				if(clone.lowerList.length > 0){
					
					for(let i=0; i<clone.lowerList.length; i++){
						if(refUpperSeq === clone.lowerList[i].upperSeq){
							data.lowerList.push(common.clone(clone.lowerList[i]));
						}
					}
					$("button[name='svb']").each(function(i, e){
						if(refUpperSeq === Number($(e).data("upperSeq"))){
							$(e).addClass("btn-selected-gray");
							return;
						}
					});
				}
				fnLowerJsGrid();
				initLower = false;
			}else{
				$("button[name='svb']").each(function(i, e){
					if(refUpperSeq === Number($(e).data("upperSeq"))){
						$(e).addClass("btn-selected-gray");
						return;
					}
				});
			}
		}	
	});	
	
	function fnLowerJsGrid(){		
		$("#lowerMenuList").empty();
		
		for(let i=0; i<data.lowerList.length; i++){
			data.lowerList[i].state = "select";
		}
		
		lowerNoIdx = cfnNoIdx(data.lowerList, "lowerSeq");
		lowerCloneNoIdx = cfnNoIdx(clone.lowerList, "lowerSeq");
		
		$("#lowerMenuList").jsGrid({
			height: "auto",
			width: "48%",
			
			data: data.lowerList,
			
			paging: false,
			pageSize: 10,
			
			fields: [
				{ align:"center", width: "7%",
					headerTemplate : function(){
						return $("<button>").attr("id", "lowerAdd").addClass("btn-gray trs size-sm").text("+").on("click", function(){
							data.lowerList.push({upperSeq: refUpperSeq,
								authSeq:"",
								lowerNm:"",
								lowerOdr: $("#lowerMenuList").jsGrid("option", "data").length+1,
								lowerSeq: new Date().getTime(),
								showYn:"N",
								lowerUrl:"",
								state:"insert"});		
							lowerNoIdx = cfnNoIdx(data.lowerList, "lowerSeq");
							$("#lowerMenuList").jsGrid("refresh");
						});					
					},
	                itemTemplate: function(value, item) {
	                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
	                    .data("lowerSeq", item.lowerSeq).data("lowerOdr", item.lowerOdr).on("change", function() {
	                    	let idx = lowerNoIdx[item.lowerSeq];
	                    	let cIdx = lowerCloneNoIdx[item.lowerSeq];
	                			
	               			if(isEmpty(item.lowerOdr)){
	               	    		$("#lowerMenuList").jsGrid("deleteItem", item);
	               	    		delete lowerNoIdx[item.lowerSeq];               	    		
	               	    	}else{
	               	    		if($(this).is(":checked")) {
	                   	   			$("[name='syncLower']").each(function(i, e){
	                   	   				if(item.lowerSeq  === $(e).data("lowerSeq")){
	                   	   					$(e).addClass("sync-red");
	                   	   					
	                   	   					if(String(clone.lowerList[cIdx][$(e).data("name")]) !== String($(e).val())){
	                   	   						$(e).addClass("sync-blue");
	                   	   					}
	                   	   					data.lowerList[idx].state = "delete";
	                   	   				}
	                   	   			});
	                   	   		}else{
	                   	   			$("[name='syncLower']").each(function(i, e){
	                   	   				if(item.lowerSeq === $(e).data("lowerSeq")){
	                   	   					$(e).removeClass("sync-red");
	                   	   					
	                   	   					if($(e).hasClass("sync-blue") || data.lowerList[idx].state === "update" ){
	                   	   						data.lowerList[idx].state = "update";
	                   	   					}else{
	                   	   						data.lowerList[idx].state = "select";
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
				{ title:"순서",	name:"lowerOdr",	type:"text", align:"center", width: "9%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "lowerOdr", "lowerList", "span");
					}
				},
				{ title:"하위 이름",	name:"lowerNm",		type:"text", align:"center", width: "20%",
					itemTemplate: function(value, item){													
						return fnRefreshedSync(item, "lowerNm", "lowerList", "input");
					}
				},
				{ title:"하위 URL",	name:"lowerUrl",		type:"text", align:"center", width: "37%",
					itemTemplate: function(value, item){													
						return fnRefreshedSync(item, "lowerUrl", "lowerList", "input");
					}
				},
				{ title:"권한",	name:"authSeq", align:"center", width: "20%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "authSeq", "lowerList", "select");
					}
				},				
				{ title:"표시",	name:"showYn",		type:"text", align:"center", width: "7%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "showYn", "lowerList", "button");
					}
				}
			],
			onRefreshed: function() {
				let $gridData = $("#lowerMenuList .jsgrid-grid-body tbody");
				$gridData.sortable({
					update: function(e, ui) {
						let items = $.map($gridData.find("tr"), function(row) {
							return $(row).data("JSGridItem");
						});
						
						lowerNoIdx = cfnNoIdx(data.lowerList, "lowerSeq");
						for(let i=0; i<items.length; i++){
							fnOnSync($("#lowerMenuList .ui-sortable tr span")[i], "lowerSeq", i);
						}
					}
				});
				
				//수정 intpu sync 체크
				$("input[name='syncLower']").on("keyup keydown change", function(){	
					fnOnSync(this, "lowerSeq");
				});
				
				//수정 select sync 체크
				$("select[name='syncLower']").on("change", function(){			
					fnOnSync(this, "lowerSeq");
				});
				
				//수정 button sync 체크
				$("button[name='syncLower']").on("click", function(){			
					if($(this).val() === "Y")	$(this).val("N").text("N");
					else						$(this).val("Y").text("Y");
					
					fnOnSync(this, "lowerSeq");
				});
			}
		});
	}
	
	
	//변경여부 확인후 상태 색상적용
	function fnOnSync(obj, seqNm, sortIdx){
		let listNm = seqNm === "upperSeq" ? "upperList" : "lowerList";
		
		if($(obj).hasClass("sync-green")){			
			if(isEmpty(sortIdx)){
				seqNm === "upperSeq" ? data.upperList[upperNoIdx[$(obj).data(seqNm)]][$(obj).data("name")] = $(obj).val()
						   : data.lowerList[lowerNoIdx[$(obj).data(seqNm)]][$(obj).data("name")] = $(obj).val();
			}else{
				seqNm === "upperSeq" ? data.upperList[upperNoIdx[$(obj).data(seqNm)]][$(obj).data("name")] = sortIdx+1
						   : data.lowerList[lowerNoIdx[$(obj).data(seqNm)]][$(obj).data("name")] = sortIdx+1;
			}			
		}else{
			let name = $(obj).data("name");
			let idx = seqNm === "upperSeq" ? upperNoIdx[$(obj).data(seqNm)]
									     : lowerNoIdx[$(obj).data(seqNm)];
			let cIdx = seqNm === "upperSeq" ? upperCloneNoIdx[$(obj).data(seqNm)]
										  : lowerCloneNoIdx[$(obj).data(seqNm)];
			
			if(isEmpty(sortIdx)){
				data[listNm][idx][name] = $(obj).val();
				
				if(String(clone[listNm][cIdx][name]) === String($(obj).val())){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data[listNm][idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data[listNm][idx].state = "update";
				}
			}else{
				data[listNm][idx][name] = sortIdx+1;
				
				if(idx === sortIdx){
					$(obj).removeClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data[listNm][idx].state = "select";
				}else{
					$(obj).addClass("sync-blue");
					if(!$(obj).hasClass("sync-red")) data[listNm][idx].state = "update";
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
		case "span":
			$el = $("<span>").val(item[name]).text(item[name]);
			break;
		case "select" : 
			$el = $("<select>").addClass("select-gray");
			let $option = null;
			if(item.state === "insert"){
				$el.append($("<option>").text("").val(""));
			}			
			for(let i=0; i<data.authList.length; i++){
				$option = $("<option>").text(data.authList[i].authNm).val(data.authList[i].authSeq);
				if(String(item[name]) === String(data.authList[i].authSeq)){
					$el.append($option.attr("selected","selected"));
				}
				$el.append($option);
			}
			break;			
		case "button" :
			$el = $("<button>").addClass("btn-gray trs size-sm").val(item[name]).text(item[name]);
			break;
		}
		
		if(listName === "upperList"){
			
			$el.attr("name", "syncUpper").data("upperSeq", item.upperSeq).data("name", name);		

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){									
				if(String(clone[listName][upperCloneNoIdx[item.upperSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");				
				if(String(clone[listName][upperCloneNoIdx[item.upperSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}		
		}else if(listName === "lowerList"){
			
			$el.attr("name", "syncLower").data("lowerSeq", item.lowerSeq).data("name", name);		

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){									
				if(String(clone[listName][lowerCloneNoIdx[item.lowerSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");
				if(String(clone[listName][lowerCloneNoIdx[item.lowerSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}		
		}		
		return $el;
	}
	
	//저장(반영)
	$("#btns #upperSave").on("click", function(){		
		//유효성 검사
		let isVali = true;
		$("[name='syncUpper']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: $(e)[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){
			case "upperNm":			
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			case "upperUrl":			
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
		
		let applyList = new Array();
		for(let i=0, j=1; i<data.upperList.length; i++){
			if(data.upperList[i].state !== "select"){
				applyList.push(data.upperList[i]);
			}
		}
		
		if(applyList.length === 0){
			alert("저장할 데이터가 없습니다.");
		}else if(isVali && confirm("저장하시겠습니까?")){		
			
			let param = {};
			param.upperClone = JSON.stringify(clone.upperList);
			param.upperList = JSON.stringify(data.upperList);
			
			cfnCmmAjax("/admin/applyUpperMenuList", param).done(function(res){
				
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");
				}else if(Number(res)===-2){
					alert("삭제하려는 상위메뉴가 하위메뉴에서 사용중 입니다. 반영이 취소됩니다.");
				}else{					
					cfnCmmAjax("/admin/selectUpperMenuList", param).done(function(result){
						initLower = false;
						clone.upperList = common.clone(result);
						data.upperList.splice(0, data.upperList.length);
						
						for(let i=0; i<result.length; i++){
							data.upperList.push(result[i]);
						}
						
						$("#upperMenuList").jsGrid("refresh");
						upperNoIdx = cfnNoIdx(data.upperList, "upperSeq");
						upperCloneNoIdx = cfnNoIdx(clone.upperList, "upperSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//lower 저장(반영)
	$("#btns #lowerSave").on("click", function(){
		//유효성 검사
		let isVali = true;
		$("[name='syncLower']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: $(e)[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){		
			case "lowerNm":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;			
			case "lowerUrl":
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
		
		let applyList = new Array();
		for(let i=0, j=1; i<data.lowerList.length; i++){
			if(data.lowerList[i].state !== "select"){
				applyList.push(data.lowerList[i]);
			}
		}		
		
		if(applyList.length === 0){
			alert("저장할 데이터가 없습니다.");
		}else if(isVali && confirm("저장하시겠습니까?")){
			
			let param = {};			
			param.upperSeq = refUpperSeq;
			let cloneLowerList = new Array();
			
			for(let i=0; i<clone.lowerList.length; i++){
				if(refUpperSeq === clone.lowerList[i].upperSeq){
					cloneLowerList.push(common.clone(clone.lowerList[i]));
				}
			}
			
			param.lowerClone = JSON.stringify(cloneLowerList);
			param.lowerList = JSON.stringify(data.lowerList);
			
			cfnCmmAjax("/admin/applyLowerMenuList", param).done(function(res){
				if(Number(res)===-1){
					alert("수정하려는 데이터가 이미 수정되어 수정할 수 없습니다. 반영이 취소됩니다.");				
				}else{					
					cfnCmmAjax("/admin/selectLowerMenuList").done(function(result){						
						clone.lowerList = common.clone(result);
						data.lowerList.splice(0, data.lowerList.length);						
						for(let i=0; i<clone.lowerList.length; i++){
							if(refUpperSeq === clone.lowerList[i].upperSeq){
								data.lowerList.push(common.clone(clone.lowerList[i]));
							}
						}						
						$("#lowerMenuList").jsGrid("refresh");
						lowerNoIdx = cfnNoIdx(data.lowerList, "lowerSeq");
						lowerCloneNoIdx = cfnNoIdx(clone.lowerList, "lowerSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//취소
	$("#btns #cancel").on("click", function(){		
		initLower = true;
		data.upperList.splice(0, data.upperList.length);
		for(let i=0; i<clone.upperList.length; i++){
			data.upperList.push(common.clone(clone.upperList[i]));
		}
		$("#upperMenuList").jsGrid("refresh");		
	});
}
</script>

<div class="button-bar">
	<div id="btns" class="btn-right">
		<button id="upperSave" class="btn-gray trs">상위메뉴 저장</button>
		<button id="lowerSave" class="btn-gray trs">하위메뉴 저장</button>
		<button id="cancel" class="btn-gray trs">취소</button>
	</div>
</div>

<div>
	<div class="title-icon"></div>
	<label class="title">상위메뉴</label>
	<div class="title-icon" style="margin-left: 46%;"></div>
	<label class="title">하위메뉴</label>
</div>
<div>
	<div id="upperMenuList" class="pull-left"></div>
	<div id="lowerMenuList"  class="pull-right"></div>
</div>