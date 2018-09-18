<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<style>
.jsgrid-cell {padding: 0 0 0 0;}
/* .jsgrid-alt-row > .jsgrid-cell {background: #5A5A5A;} */
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
	
	let clone = common.clone(data);
	let authList = data;
	let authNoIdx = cfnNoIdx(authList, "authNmSeq");
	
	console.log(authList);
	
	$("#authList").jsGrid({
		height: "auto",
		width: "100%",		
		
		//editing: true,		       
		autoload: true,        
		data: authList,
		
		
		paging: false,
		pageSize: 10,
		
		fields: [
			{ align:"center", width: "5%",
                headerTemplate: function() {	
                    return $("<input>").attr("type", "checkbox").on("click", function () {
                    	if($(this).is(":checked")) $("input:checkbox[name=check]").prop('checked', true);
                    	else $("input:checkbox[name=check]").prop('checked', false);
					});
                },
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox").attr("name", "check")
                    	.data("authNmSeq", item.authNmSeq);
						//	.prop("checked", $.inArray(item, selectedItems) > -1)
						//	.on("change", function () {
						//		$(this).is(":checked") ? selectItem(item) : unselectItem(item);
						//	});
                }	            
			},
			{ title:"순서",	name:"authOrder",	type:"text", align:"center", width: "5%"},
			{ title:"권한명",	name:"authNm",		type:"text", align:"center", width: "40%", 
				itemTemplate: function(value, item){
					$(this).removeClass("jsgrid-cell");
					return $("<input>").attr("type", "text").attr("name", "sync")
						.data("authNmSeq", item.authNmSeq).data("name", "authNm")
						.addClass("input-gray wth100p").val(value);		
				}				
			},
			{ title:"권한 설명",	name:"authCmt",	type:"text", align:"center", width: "50%", 
				itemTemplate: function(value, item){					
					$(this).removeClass("jsgrid-cell");
					return $("<input>").attr("type", "text").attr("name", "sync")
						.data("authNmSeq", item.authNmSeq).data("name", "authCmt")
						.addClass("input-gray wth100p").val(value);
				}
			}		
		],			
		rowClass: function(item, itemIndex) {
            return "client-" + itemIndex;
        },
		onRefreshed: function() {
			let $gridData = $("#authList .jsgrid-grid-body tbody");

			$gridData.sortable({
                update: function(e, ui) {
                    // array of indexes
                    var clientIndexRegExp = /\s*client-(\d+)\s*/;
                    var indexes = $.map($gridData.sortable("toArray", { attribute: "class" }), function(classes) {
                        return clientIndexRegExp.exec(classes)[1];
                    });
                    console.log("Reordered indexes: " + indexes.join(", "));
 
                    // arrays of items
                    var items = $.map($gridData.find("tr"), function(row) {
                        return $(row).data("JSGridItem");
                    });
                    console && console.log("Reordered items", items);
                }
            });
		}
	});
	
	//수정 sync 체크
	$("input[name='sync']").on("keyup", function(){		
		if(clone[authNoIdx[$(this).data("authNmSeq")]][$(this).data("name")] === $(this).val()){			
			$(this).removeClass("sync-blue");
		}else{
			$(this).addClass("sync-blue");			
		}
	});
	
	//삭제 sync 체크
	$("input[name='check']").on("click", function(){		
		//$(this).addClass("sync-red");
	});
	
	//권한추가
	$("#search-bar #add").on("click", function(){		
		/* authList.push({authNm:"", authCmt:""});
		$("#authList").jsGrid("refresh"); */		
		$("#authList").jsGrid("insertItem", { authNm: "", authCmt: ""});
		
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