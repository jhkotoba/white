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
	
	console.log(authList);
	
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
                headerTemplate: function() {	
                    return $("<input>").attr("type", "checkbox").on("change", function () {
                    	if($(this).is(":checked")){                    		
                    		$("input:checkbox[name=check]").each(function(i, e){
                    			if(isEmpty($(e).data("authNmSeq"))){
                    				$("#authList").jsGrid("deleteItem", $(e).parent().parent()); 
                    			}
                    		});                    		                 		
                    		$("input:checkbox[name=check]").prop('checked', true);
                   			$("input[name='sync']").addClass("sync-red");                    		
                    	}else{
                    		$("input:checkbox[name=check]").prop('checked', false);
                    		$("input[name='sync']").removeClass("sync-red");
                    	}
					});
                },
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    	.data("authNmSeq", item.authNmSeq).on("change", function() {
                    		
                    	if(isEmpty(item.authOrder)){
                    		$("#authList").jsGrid("deleteItem", item);
                    		return;
                    	}
                    	
                    	fnSync(this, item, "delete");
                    		
                   		/* if($(this).is(":checked")) {
                   			$("input[name='sync']").each(function(i, e){				
                   				if(item.authNmSeq  === $(e).data("authNmSeq")){
                   					$(e).addClass("sync-red");
               						//authList[authNoIdx[item.authNmSeq]].state = "delete";   
                   				}
                   			});
                   		}else{
                   			$("input[name='sync']").each(function(i, e){				
                   				if(item.authNmSeq === $(e).data("authNmSeq")){
                   					$(e).removeClass("sync-red");
                   					//authList[authNoIdx[item.authNmSeq]].state = "select";
                   				}
                   			});
                    	} */
                	});
                    
                    
                    /* if(authList[authNoIdx[item.authNmSeq]].state === "delete"){
                    	$(chk).addClass("sync-red");
                    }else{
                    	$(chk).removeClass("sync-red");
                    } */
                    
                    return chk;
                    	//.data("authNmSeq", item.authNmSeq);
						//	.prop("checked", $.inArray(item, selectedItems) > -1)
						//	.on("change", function () {
						//		$(this).is(":checked") ? selectItem(item) : unselectItem(item);
						//	});
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
					let ipt =  $("<input>").attr("type", "text").attr("name", "sync")
						.data("authNmSeq", item.authNmSeq).data("name", "authNm")
						.addClass("input-gray wth100p").val(value);
					
					if(isNotEmpty(value)){
						if(clone[authNoIdx[item.authNmSeq]].authNm === value){
							$(ipt).removeClass("sync-blue");
						}else{
							$(ipt).addClass("sync-blue");
						}
					}else{
						ipt.addClass("sync-green");
					}
					return ipt;					
				}
			},
			{ title:"권한 설명",	name:"authCmt",	type:"text", align:"center", width: "50%",
				itemTemplate: function(value, item){
					$(this).removeClass("jsgrid-cell");
					let ipt = $("<input>").attr("type", "text").attr("name", "sync")
						.data("authNmSeq", item.authNmSeq).data("name", "authCmt")
						.addClass("input-gray wth100p").val(value);
					
					if(isNotEmpty(value)){						
						if(clone[authNoIdx[item.authNmSeq]].authCmt === value){
							$(ipt).removeClass("sync-blue");
						}else{
							$(ipt).addClass("sync-blue");
						}
					}else{
						ipt.addClass("sync-green");
					}
					return ipt;
				}
			}
		],			
		/* rowClass: function(item, itemIndex) {
            return "client-" + itemIndex;
        }, */
		onRefreshed: function() {
			let $gridData = $("#authList .jsgrid-grid-body tbody");
			$gridData.sortable();
			/* $gridData.sortable({
                update: function(e, ui) {
                    console.log(e);
                    console.log(ui);
                }
            }); */
            
			//수정 sync 체크
			$("input[name='sync']").on("keyup", function(){
				authList[authNoIdx[$(this).data("authNmSeq")]][$(this).data("name")] = $(this).val();
				if(clone[authNoIdx[$(this).data("authNmSeq")]][$(this).data("name")] === $(this).val()){		
					$(this).removeClass("sync-blue");
				}else{
					$(this).addClass("sync-blue");			
				}
			});	
		}
	});
	
	
	
	
	//권한추가
	$("#search-bar #add").on("click", function(){
		
		//let el = $("#authList .jsgrid-grid-body tbody").children().last().html();
		//$("#authList .jsgrid-grid-body tbody").append(el);
		authList.push({authOrder: "", authNm:"", authCmt:"", state:"insert"});
		$("#authList").jsGrid("refresh"); 
		//$("#authList").jsGrid("insertItem");
		//$("#authList").jsGrid("insertItem", { authOrder: "", authNm: "", authCmt: ""});
		
		
		/* let tag = $("<tr>").addClass("jsgrid-alt-row ui-sortable-handle");
		tag.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[0]+";'").append(			
				$("<input>").attr("type", "checkbox").attr("name", "check").addClass("jsgrid-cell jsgrid-align-center")
				.data("authNmSeq", "")
			)			
		);
		tag.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[1]+";'"));
		tag.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[2]+";'"));
		tag.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[3]+";'")); */
		
		
		/* let tr = $("<tr>").addClass("jsgrid-alt-row ui-sortable-handle");
		tr.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[0]+";'").append(
			$("<input>").attr("type", "checkbox").attr("name", "check").addClass("jsgrid-cell jsgrid-align-center")
		));
		tr.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[1]+";'"));
		tr.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[2]+";'"));
		tr.append($("<td>").addClass("jsgrid-cell jsgrid-align-center style='width: "+cellWth[3]+";'"));
		$("<input>").attr("type", "checkbox").attr("name", "check").addClass("jsgrid-cell jsgrid-align-center");
		$("<input>").attr("type", "text").addClass("input-gray wth100p");
		$("<input>").attr("type", "text").addClass("input-gray wth100p");*/
		
		//<input type="checkbox" name="check"></td><td class="jsgrid-cell jsgrid-align-center" style="width: 5%;">7</td><td class="jsgrid-cell jsgrid-align-center" style="width: 40%;"><input type="text" name="sync" class="input-gray wth100p"></td><td class="jsgrid-cell jsgrid-align-center" style="width: 50%;"><input type="text" name="sync" class="input-gray wth100p"></td></tr>';
		//let tag = '<tr class="jsgrid-row ui-sortable-handle"><td class="jsgrid-cell jsgrid-align-center" style="width: 5%;"><input type="checkbox" name="check"></td><td class="jsgrid-cell jsgrid-align-center"></td><td class="jsgrid-cell jsgrid-align-center" style="width: 40%;"><input type="text" name="sync" class="input-gray wth100p"></td><td class="jsgrid-cell jsgrid-align-center" style="width: 50%;"><input type="text" name="sync" class="input-gray wth100p"></td></tr>';
		//$("#authList .jsgrid-grid-body tbody").append(tag); 
		
	});
	
	//취소
	$("#search-bar #cancel").on("click", function(){		
		authList.splice(0, authList.length);
		for(let i=0; i<clone.length; i++){
			authList.push(clone[i]);
		}
		$("#authList").jsGrid("refresh");		
	});
	
	//리스트 수
	$("#search-bar #pageSize").on("change", function(){
		let pageSize = String(this.value);
		if(pageSize === "all"){
			$("#authList").jsGrid("option", "paging", false);
		}else{
			$("#authList").jsGrid("option", "paging", true);
			$("#authList").jsGrid("option", "pageSize", Number(pageSize));
		}
	});
	
	//저장(반영)
	$("#search-bar #save").on("click", function(){		
		
		
	});
	
	//authList jsGrid Data 동기화
	function fnSync(el, item, action){
		
		let idx = authNoIdx[item.authNmSeq];
		
		//삭제 체크박스
		if($(el).is(":checked")) {
   			$("input[name='sync']").each(function(i, e){				
   				if(item.authNmSeq  === $(e).data("authNmSeq")){
   					$(e).addClass("sync-red");
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
		console.log(authList);
	}
}
</script>

<div id="search-bar" class="search-bar">
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
<!-- <div id="jsGrid"></div> -->
<!-- onRefreshed: function() {
            var $gridData = $("#jsGrid .jsgrid-grid-body tbody");
 
            $gridData.sortable({
                update: function(e, ui) {
                    // array of indexes
                    var clientIndexRegExp = /\s*client-(\d+)\s*/;
                    var indexes = $.map($gridData.sortable("toArray", { attribute: "class" }), function(classes) {
                        return clientIndexRegExp.exec(classes)[1];
                    });
                    alert("Reordered indexes: " + indexes.join(", "));
 
                    // arrays of items
                    var items = $.map($gridData.find("tr"), function(row) {
                        return $(row).data("JSGridItem");
                    });
                    console && console.log("Reordered items", items);
                }
            }); -->