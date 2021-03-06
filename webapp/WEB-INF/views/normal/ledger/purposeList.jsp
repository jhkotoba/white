<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){
	cfnCmmAjax("/ledger/selectAllPurList", {codePrt:"LED"}).done(fnPurGrid);
});

function fnPurGrid(data){
	
	for(let i=0; i<data.purList.length; i++){
		data.purList[i].state = "select";
	}
	
	let clone = common.clone(data);
	data.purDtlList = null;
	
	let purNoIdx = cfnNoIdx(data.purList, "purposeSeq");
	let purCloneNoIdx = cfnNoIdx(clone.purList, "purposeSeq");
	let purDtlNoIdx = null;
	let purDtlCloneNoIdx = null;
	let initPurDtl = true;
	let refPurSeq;
	
	if(clone.purList.length === 0){
		refPurSeq = 0;
	}else if(isEmpty("${prevParam}")){
		refPurSeq = clone.purList[0].purposeSeq;
	}else{
		refPurSeq = Number("${prevParam}");
	}	
	
	$("#purList").jsGrid({
		height: "auto",
		width: "51%",
		
		autoload: true,
		data: data.purList,
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		fields: [
			{ align:"center", width: "5%",
				headerTemplate : function(){
					return $("<button>").attr("id", "purAdd").addClass("btn-gray trs size-sm").text("+").on("click", function(){
						data.purList.push({purposeNm: "", 
							purposeOdr: $("#purList").jsGrid("option", "data").length+1,
							purposeSeq: new Date().getTime(), 
							state:"insert"
							});
						purNoIdx = cfnNoIdx(data.purList, "purposeSeq");
						$("#purList").jsGrid("refresh");
					});
				},
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("purposeSeq", item.purposeSeq).data("purposeOdr", item.purposeOdr).on("change", function() {
                    	let idx = purNoIdx[item.purposeSeq];
                    	let cIdx = purCloneNoIdx[item.purposeSeq];
                
               			if(isEmpty(item.purposeOdr)){
               	    		$("#purList").jsGrid("deleteItem", item);
               	    		delete purNoIdx[item.purposeSeq];
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='syncPur']").each(function(i, e){
                   	   				if(item.purposeSeq  === $(e).data("purposeSeq")){
                   	   					$(e).addClass("sync-red");
                   	   					
                   	   					if(String(clone.purList[cIdx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   	   					data.purList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='syncPur']").each(function(i, e){
                   	   				if(item.purposeSeq === $(e).data("purposeSeq")){
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
			{ title:"순서",	name:"purposeOdr",	type:"text", align:"center", width: "10%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "purposeOdr", "purList", "span");
				}
			},
			{ title:"목적",	name:"purposeNm",		type:"text", align:"center", width: "53%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "purposeNm", "purList", "input");
				}
			},
			{ title:"목적 종류",	name:"purposeTpCd",		type:"text", align:"center", width: "16%",
				itemTemplate: function(value, item){
					return fnRefreshedSync(item, "purposeTpCd", "purList", "select");
				}
			},
			{ title:"보기", align:"center", width: "8%",
				itemTemplate: function(value, item){
					if(item.state === "insert"){
						return "";
					}else{
						return $("<button>").addClass("btn-gray size-sm").text(">").data("purposeSeq", item.purposeSeq)
							.attr("name", "svb").on("click", function(){
							
							$("button[name='svb']").each(function(i, e){
								$(e).removeClass("btn-selected-gray");
							});
							$(this).addClass("btn-selected-gray");
							
							refPurSeq = item.purposeSeq;
							data.purDtlList = new Array();
							for(let i=0; i<clone.purDtlList.length; i++){
								if(item.purposeSeq === clone.purDtlList[i].purposeSeq){
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
					
					purNoIdx = cfnNoIdx(data.purList, "purposeSeq");
					for(let i=0; i<items.length; i++){
						fnOnSync($("#purList .ui-sortable tr span")[i], "purposeSeq", i);
					}
				}
			});
			
			//수정 intpu sync 체크	
			$("input[name='syncPur']").on("keyup keydown change", function(){
				fnOnSync(this, "purposeSeq");
			});
			
			//수정 select sync 체크
			$("select[name='syncPur']").on("change", function(){
				fnOnSync(this, "purposeSeq");
			});
			
			if(initPurDtl){
				data.purDtlList = new Array();
				if(clone.purDtlList.length > 0){
					
					for(let i=0; i<clone.purDtlList.length; i++){
						if(refPurSeq === clone.purDtlList[i].purposeSeq){
							data.purDtlList.push(common.clone(clone.purDtlList[i]));
						}
					}
					$("button[name='svb']").each(function(i, e){
						if(refPurSeq === Number($(e).data("purposeSeq"))){
							$(e).addClass("btn-selected-gray");
							return;
						}
					});
				}
				fnPurDtlJsGrid();
				initPurDtl = false;
			}else{
				$("button[name='svb']").each(function(i, e){
					if(refPurSeq === Number($(e).data("purposeSeq"))){
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
		
		purDtlNoIdx = cfnNoIdx(data.purDtlList, "purposeDtlSeq");
		purDtlCloneNoIdx = cfnNoIdx(clone.purDtlList, "purposeDtlSeq");
		
		$("#purDtlList").jsGrid({
			height: "auto",
			width: "48%",
			
			data: data.purDtlList,
			
			paging: false,
			pageSize: 10,
			
			fields: [
				{ align:"center", width: "5%",
					headerTemplate : function(){
						return $("<button>").attr("id", "purDtlAdd").addClass("btn-gray trs size-sm").text("+").on("click", function(){
							data.purDtlList.push({purposeSeq: refPurSeq,
								purposeDtlNm:"",
								purposeDtlOdr: $("#purDtlList").jsGrid("option", "data").length+1,
								purposeDtlSeq: new Date().getTime(), state:"insert"
								});
							purDtlNoIdx = cfnNoIdx(data.purDtlList, "purposeDtlSeq");
							$("#purDtlList").jsGrid("refresh");
						});
					},
	                itemTemplate: function(value, item) {
	                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
	                    .data("purposeDtlSeq", item.purposeDtlSeq).data("purposeDtlOdr", item.purposeDtlOdr).on("change", function() {
	                    	let idx = purDtlNoIdx[item.purposeDtlSeq];
	                    	let cIdx = purDtlCloneNoIdx[item.purposeDtlSeq];
	                	
	               			if(isEmpty(item.purposeDtlOdr)){
	               	    		$("#purDtlList").jsGrid("deleteItem", item);
	               	    		delete purDtlNoIdx[item.purposeDtlSeq];
	               	    	}else{
	               	    		if($(this).is(":checked")) {
	                   	   			$("[name='syncPurDtl']").each(function(i, e){
	                   	   				if(item.purposeDtlSeq  === $(e).data("purposeDtlSeq")){
	                   	   					$(e).addClass("sync-red");
	                   	   					
	                   	   					if(String(clone.purDtlList[cIdx][$(e).data("name")]) !== String($(e).val())){
	                   	   						$(e).addClass("sync-blue");
	                   	   					}
	                   	   					data.purDtlList[idx].state = "delete";
	                   	   				}
	                   	   			});
	                   	   		}else{
	                   	   			$("[name='syncPurDtl']").each(function(i, e){
	                   	   				if(item.purposeDtlSeq === $(e).data("purposeDtlSeq")){
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
				{ title:"순서",	name:"purposeDtlOdr",	type:"text", align:"center", width: "12%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "purposeDtlOdr", "purDtlList", "span");
					}
				},
				{ title:"상세목적",	name:"purposeDtlNm",		type:"text", align:"center", width: "75%",
					itemTemplate: function(value, item){
						return fnRefreshedSync(item, "purposeDtlNm", "purDtlList", "input");
					}
				}
			],
			onRefreshed: function() {
				let $gridData = $("#purDtlList .jsgrid-grid-body tbody");
				$gridData.sortable({
					update: function(e, ui) {
						let items = $.map($gridData.find("tr"), function(row) {
							return $(row).data("JSGridItem");
						});
						
						purDtlNoIdx = cfnNoIdx(data.purDtlList, "purposeDtlSeq");
						for(let i=0; i<items.length; i++){
							fnOnSync($("#purDtlList .ui-sortable tr span")[i], "purposeDtlSeq", i);
						}
					}
				});
				
				//수정 intpu sync 체크
				$("input[name='syncPurDtl']").off().on("keyup keydown change", function(){	
					fnOnSync(this, "purposeDtlSeq");
				});
				
				//수정 button sync 체크
				$("button[name='syncPurDtl']").off().on("click", function(){
					if($(this).val() === "Y")	$(this).val("N").text("N");
					else						$(this).val("Y").text("Y");
					fnOnSync(this, "purposeDtlSeq");
				});
			}
		});
	}	
	
	//변경여부 확인후 상태 색상적용
	function fnOnSync(obj, seqNm, sortIdx){
		let listNm = seqNm === "purposeSeq" ? "purList" : "purDtlList";
		
		if($(obj).hasClass("sync-green")){
			seqNm === "purposeSeq" ? data.purList[purNoIdx[$(obj).data(seqNm)]][$(obj).data("name")] = $(obj).val()
							   : data.purDtlList[purDtlNoIdx[$(obj).data(seqNm)]][$(obj).data("name")] = $(obj).val();
		}else{
			let name = $(obj).data("name");
			let idx = seqNm === "purposeSeq" ? purNoIdx[$(obj).data(seqNm)]
									     : purDtlNoIdx[$(obj).data(seqNm)];
			let cIdx = seqNm === "purposeSeq" ? purCloneNoIdx[$(obj).data(seqNm)]
										  : purDtlCloneNoIdx[$(obj).data(seqNm)];
			
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
	function fnRefreshedSync(item, name, listNm, tag){
		
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
			for(let i=0; i<data.purTpList.codePrt.length; i++){
				$option = $("<option>").text(data.purTpList.codePrt[i].codeNm).val(data.purTpList.codePrt[i].code);				
				if(String(item[name]) === String(data.purTpList.codePrt[i].code)){
					$el.append($option.attr("selected","selected"));
				}
				$el.append($option);
			}
			break;
		case "button":
			$el = $("<button>").addClass("btn-gray trs size-sm").val(item[name]).text(item[name]);
			break;
		}
		
		switch(listNm){
		case "purList":
			$el.attr("name", "syncPur").data("purposeSeq", item.purposeSeq).data("name", name);

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){
				if(String(clone[listNm][purCloneNoIdx[item.purposeSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}			
			}else if(item.state === "delete"){
				$el.addClass("sync-red");
				if(String(clone[listNm][purCloneNoIdx[item.purposeSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}
			break;
		case "purDtlList":
			$el.attr("name", "syncPurDtl").data("purposeDtlSeq", item.purposeDtlSeq).data("name", name);

			if(item.state === "insert") $el.addClass("sync-green");	
			else if(item.state === "update"){
				if(String(clone[listNm][purDtlCloneNoIdx[item.purposeDtlSeq]][name]) === String(item[name])){
					$el.removeClass("sync-blue");
				}else{
					$el.addClass("sync-blue");
				}
			}else if(item.state === "delete"){
				$el.addClass("sync-red");
				if(String(clone[listNm][purDtlCloneNoIdx[item.purposeDtlSeq]][name]) !== String($el.val())){
					$el.addClass("sync-blue");
				}
			}
			break;
		}
		return $el;
	}
	
	//목적 저장(반영)
	$("#btns #purSave").on("click", function(){
		//유효성 검사
		let isVali = true;
		$("[name='syncPur']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: $(e)[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){
			case "purposeNm":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			}
		});
		
		let applyList = new Array();
		for(let i=0, j=1; i<data.purList.length; i++){
			if(data.purList[i].state !== "select"){
				applyList.push(data.purList[i]);
			}
		}
		
		if(applyList.length === 0){
			alert("저장할 데이터가 없습니다.");
		}else if(isVali && confirm("저장하시겠습니까?")){
			
			let param = {};
			param.purList = JSON.stringify(applyList);
			
			cfnCmmAjax("/ledger/applyPurList", param).done(function(res){
				
				if(Number(res)===-1){
					alert("데이터가 정상적이지 않아 반영이 취소됩니다.");
				}else if(Number(res)===-2){
					alert("삭제하려는 목적이 상세목적에서 사용중 입니다. 반영이 취소됩니다.");
				}else if(Number(res)===-3){
					alert("삭제하려는 목적이 거래내역에서 사용중 입니다. 반영이 취소됩니다.");
				}else{
					cfnCmmAjax("/ledger/selectPurList", param).done(function(result){
						initPurDtl = false;
						clone.purList = common.clone(result);
						data.purList.splice(0, data.purList.length);
						
						for(let i=0; i<result.length; i++){
							data.purList.push(result[i]);
						}
						
						$("#purList").jsGrid("refresh");
						purNoIdx = cfnNoIdx(data.purList, "purposeSeq");
						purCloneNoIdx = cfnNoIdx(clone.purList, "purposeSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//상세목적 저장(반영)
	$("#btns #purDtlSave").on("click", function(){
		//유효성 검사
		let isVali = true;
		$("[name='syncPurDtl']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: "값을 입력해 주세요."}); return false;
			}
			switch($(e).data("name")){
			case "purposeDtlNm":
				if(!isOnlyHanAlphaNum($(e).val())){
					isVali = false;
					wVali.alert({element : $(e), msg: "한글, 영문자, 숫자를 입력해 주세요."}); return false;
				}else if($(e).val().length > 20){
					isVali = false;
					wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
				}
				break;
			}
		});
		
		let applyList = new Array();
		for(let i=0, j=1; i<data.purDtlList.length; i++){
			if(data.purDtlList[i].state !== "select"){
				applyList.push(data.purDtlList[i]);
			}
		}
		
		if(applyList.length === 0){
			alert("저장할 데이터가 없습니다.");
		}else if(isVali && confirm("저장하시겠습니까?")){
			
			let param = {};
			param.purposeSeq = refPurSeq;
			param.purDtlList = JSON.stringify(applyList);
			
			cfnCmmAjax("/ledger/applyPurDtlList", param).done(function(res){
				if(Number(res)===-1){
					alert("데이터가 정상적이지 않아 반영이 취소됩니다.");
				}else if(Number(res)===-2){
					alert("삭제하려는 상세목적이 거래내역에서 사용중 입니다. 반영이 취소됩니다.");
				}else{
					cfnCmmAjax("/ledger/selectPurDtlList").done(function(result){
						clone.purDtlList = common.clone(result);
						data.purDtlList.splice(0, data.purDtlList.length);
						for(let i=0; i<clone.purDtlList.length; i++){
							if(refPurSeq === clone.purDtlList[i].purposeSeq){
								data.purDtlList.push(common.clone(clone.purDtlList[i]));
							}
						}
						$("#purDtlList").jsGrid("refresh");
						purDtlNoIdx = cfnNoIdx(data.purDtlList, "purposeDtlSeq");
						purDtlCloneNoIdx = cfnNoIdx(clone.purDtlList, "purposeDtlSeq");
					});
					alert("반영되었습니다.");
				}
			});
		}
	});
	
	//취소
	$("#btns #cancel").on("click", function(){
		initPurDtl = true;
		data.purList.splice(0, data.purList.length);
		for(let i=0; i<clone.purList.length; i++){
			data.purList.push(common.clone(clone.purList[i]));
		}
		$("#purList").jsGrid("refresh");
	});
}
</script>

<div class="button-bar">
	<div id="btns" class="btn-right">
		<button id="purSave" class="btn-gray trs ">목적 저장</button>
		<button id="purDtlSave" class="btn-gray trs ">상세목적 저장</button>
		<button id="cancel" class="btn-gray trs">취소</button>
	</div>
</div>

<div>
	<div class="title-icon"></div>
	<label class="title">목적 목록</label>
	<div class="title-icon" style="margin-left: 46%;"></div>
	<label class="title">상세목적 목록</label>
</div>
<div>
	<div id="purList" class="pull-left"></div>
	<div id="purDtlList"  class="pull-right"></div>
</div>