<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/admin/selectMenuList").done(fnJsGrid);
	cfnCmmAjax("/admin/selectMenuList").done(fnSideJsGrid);//모양만
	
});

function fnJsGrid(data){
	
	
	
	for(let i=0; i<data.length; i++){
		data[i].state = "select";
	}
	
	console.log(data);
	let clone = common.clone(data);
	let navMenuList = data;
	let navNoIdx = cfnNoIdx(data.navList, "navSeq");
	console.log(navNoIdx);
	
	$("#navMenuList").jsGrid({
		height: "auto",
		width: "51%",		
		
		autoload: true,     
		data: data.navList,
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		rowClick: function(args) {
			
			
		},
		
		fields: [
			{ align:"center", width: "5%",
                itemTemplate: function(value, item) {
                    let chk = $("<input>").attr("type", "checkbox").attr("name", "check")
                    .data("navSeq", item.navSeq).data("navOrder", item.navOrder).on("change", function() {
                    	let idx = navNoIdx[item.navSeq];
                			
               			if(isEmpty(item.navOrder)){
               	    		$("#navMenuList").jsGrid("deleteItem", item);
               	    		delete navNoIdx[item.navSeq];               	    		
               	    	}else{
               	    		if($(this).is(":checked")) {
                   	   			$("[name='sync']").each(function(i, e){				
                   	   				if(item.navSeq  === $(e).data("navSeq")){
                   	   					$(e).addClass("sync-red");
                   	   					
                   	   					if(String(clone.navList[idx][$(e).data("name")]) !== String($(e).val())){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   	   					data.navList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("[name='sync']").each(function(i, e){				
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
					return fnRefreshedNavSync(item, "navNm", "navList", "input");
				}
			},
			{ title:"상위 URL",	name:"navUrl",		type:"text", align:"center", width: "34%",
				itemTemplate: function(value, item){													
					return fnRefreshedNavSync(item, "navUrl", "navList", "input");
				}
			},
			{ title:"권한",	name:"navAuthNmSeq", align:"center", width: "20%",
				itemTemplate: function(value, item){
					//return fnRefreshedNavSync(item, "navAuthNmSeq", "navList", "select");
					
					$select = $("<select>").attr("name", "sync")
					.data("navSeq", item.navSeq).data("name", "navAuthNmSeq");
					
					let $option = null;
					for(let i=0; i<data.authList.length; i++){
						$option = $("<option>").text(data.authList[i].authNm).val(data.authList[i].authNmSeq);
						if(value === data.authList[i].authNmSeq){
							$select.append($option.attr("selected","selected"));
						}
						$select.append($option);
					}
					return $select; 
				}
			},
			{ title:"표시",	name:"navShowYn",		type:"text", align:"center", width: "6%",
				itemTemplate: function(value, item){
					//return fnRefreshedNavSync(item, "navShowYn", "navList", "button");
					return $("<button>").attr("name", "sync").addClass("btn-gray sm")
						.data("navSeq", item.navSeq).data("name", "navShowYn").val(value).text(value);
				}
			},
			{ title:"보기", align:"center", width: "6%",
				itemTemplate: function(value, item){					
					return $("<button>").addClass("btn-gray sm").text(">");
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
			$("input[name='sync']").on("keyup keydown change", function(){				
				fnOnNavSync(this);	
			});
			
			//수정 select sync 체크
			$("select[name='sync']").on("change", function(){				
				fnOnNavSync(this);
			});
			
			//수정 button sync 체크
			$("button[name='sync']").on("click", function(){				
				if($(this).val() === "Y")	$(this).val("N").text("N");
				else						$(this).val("Y").text("Y");
				
				fnOnNavSync(this);
			});
		}
	});
	
	function fnOnNavSync(obj){
		
		if($(obj).hasClass("sync-green")){
			data.navList[navNoIdx[$(obj).data("navSeq")]].navShowYn = $(obj).val();
		}else{
			let name = $(obj).data("name");
			let idx = navNoIdx[$(obj).data("navSeq")];
			
			data.navList[idx][name] = $(obj).val();			
			
			if(String(clone.navList[idx][name]) === String($(obj).val())){
				$(obj).removeClass("sync-blue");
				if(!$(obj).hasClass("sync-red")) data.navList[idx].state = "select";
			}else{
				$(obj).addClass("sync-blue");
				if(!$(obj).hasClass("sync-red")) data.navList[idx].state = "update";
			}
		}
	}
	
	//새로고침 sync			
	function fnRefreshedNavSync(item, name, listName, tag){
		
		let $el = null;
		switch(tag){
		case "input" :
		default :
			$el = $("<input>").attr("type", "text").addClass("input-gray wth100p").val(item[name]);
			break;
		case "select" : 
			
			/* $select = $("<select>").attr("type", "text").attr("name", "sync")
			.data("navSeq", item.navSeq).data("name", "navAuthNmSeq");
			
			let $option = null;
			for(let i=0; i<data.authList.length; i++){
				$option = $("<option>").text(data.authList[i].authNm).val(data.authList[i].authNmSeq);
				if(value === data.authList[i].authNmSeq){
					$select.append($option.attr("selected","selected"));
				}
				$select.append($option);
			}
			return $select; */
			
			$el = $("<select>").addClass("select-gray");
			let $option = null;
			for(let i=0; i<data.authList.length; i++){
				$option = $("<option>").text(data.authList[i].authNm).val(data.authList[i].authNmSeq);
				if(item[name] === data.authList[i].authNmSeq){
					$el.append($option.attr("selected","selected"));
				}
				$el.append($option);
			}
			break;			
		case "button" :			
			$el = $("<button>").addClass("btn-gray sm").val(item[name]);
			break;
		}
		$el.attr("name", "sync").data("navSeq", item.navSeq).data("name", name);
		

		if(item.state === "insert") $el.addClass("sync-green");	
		else if(item.state === "update"){									
			if(clone[listName][navNoIdx[item.navSeq]][name] === item[name]){
				$el.removeClass("sync-blue");
			}else{
				$el.addClass("sync-blue");
			}			
		}else if(item.state === "delete"){
			$el.addClass("sync-red");
			if(clone[listName][navNoIdx[item.navSeq]][name] !== $el.val()){
				$el.addClass("sync-blue");
			}
		}		
		return $el;
	}
	
	//저장(반영)
	$("#searchBar #save").on("click", function(){
		console.log(data.navList);
	});
	
}
function fnSideJsGrid(data){
	
	console.log(data);
	
	$("#sideMenuList").jsGrid({
		height: "auto",
		width: "48%",
		
		data: data.sideList,
		
		paging: false,
		pageSize: 10,
		
		fields: [			
			{ title:"순서",	name:"sideOrder",	type:"text", align:"center", width: "10%"},
			{ title:"하위 이름",	name:"sideNm",		type:"text", align:"center", width: "24%"},
			{ title:"하위 URL",	name:"sideUrl",		type:"text", align:"center", width: "37%"},
			{ title:"권한",	align:"center", width: "22%"},
			{ title:"표시",	name:"sideShowYn",		type:"text", align:"center", width: "7%",
				itemTemplate: function(value, item){
					return $("<button>").addClass("btn-gray sm").text(value);
				}
			}
		]
	});
	
	
	
	
}
</script>

<div id="searchBar" class="search-bar">
	<button id="navAdd" class="btn-gray">상위메뉴 추가</button>
	<button id="sideAdd" class="btn-gray">하위메뉴 추가</button>
	<div class="pull-right">	
		<button id="save" class="btn-gray">저장</button>
		<button id="cancel" class="btn-gray">취소</button>
	</div>
</div>

<div>
	<div id="navMenuList" class="pull-left"></div>
	<div id="sideMenuList"  class="pull-right"></div>
</div>



