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
		width: "49.8%",		
		
		autoload: true,     
		data: data.navList,
		paging: false,
		pageSize: 10,
		
		confirmDeleting : false,
		
		rowClick: function(args) {
			//$(args.event.target).append("<div style='width:100px; height:100px; background: red;' ></div>");
			
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
                   	   			$("input[name='sync']").each(function(i, e){				
                   	   				if(item.navSeq  === $(e).data("navSeq")){
                   	   					$(e).addClass("sync-red");               	   					
                   	   					if(clone[idx][$(e).data("name")] !== $(e).val()){
                   	   						$(e).addClass("sync-blue");
                   	   					}
                   	   					data.navList[idx].state = "delete";   
                   	   				}
                   	   			});
                   	   		}else{
                   	   			$("input[name='sync']").each(function(i, e){				
                   	   				if(item.navSeq === $(e).data("navSeq")){
                   	   					$(e).removeClass("sync-red");               	   					
                   	   					if($(e).hasClass("sync-blue") || data.navList[idx].state === "update"){
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
			{ title:"순서",	name:"navOrder",	type:"text", align:"center", width: "10%"},
			{ title:"상위 이름",	name:"navNm",		type:"text", align:"center", width: "24%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "navNm", "navList");
				}
			},
			{ title:"상위 URL",	name:"navUrl",		type:"text", align:"center", width: "37%",
				itemTemplate: function(value, item){													
					return fnRefreshedSync(item, "navUrl", "navList");
				}
			},
			{ title:"권한",	align:"center", width: "22%",
				itemTemplate: function(value, item){
					$select = $("<select>");
					for(let i=0; i<data.authList.length; i++){
						$select.append($("<option>").text(data.authList[i].authNm));
					}
					return $select;
				}
			},
			{ title:"표시",	name:"navShowYn",		type:"text", align:"center", width: "7%",
				itemTemplate: function(value, item){
					return $("<button>").addClass("btn-gray sm").text(value);
				}
			}
		]
	});
	
	
	
	
	
	
	//새로고침 sync
	function fnRefreshedSync(item, name, listName){	
		let el = $("<input>").attr("type", "text").attr("name", "sync")
			.data("navSeq", item.navSeq).data("name", name)
			.addClass("input-gray wth100p").val(item[name]);

		if(item.state === "insert") $(el).addClass("sync-green");	
		else if(item.state === "update"){									
			if(clone[listName][navNoIdx[item.navSeq]][name] === item[name]){
				$(el).removeClass("sync-blue");
			}else{
				$(el).addClass("sync-blue");
			}			
		}else if(item.state === "delete"){
			$(el).addClass("sync-red");
			if(clone[listName][navNoIdx[item.navSeq]][name] !== $(el).val()){
				$(el).addClass("sync-blue");
			}
		}		
		return el;
	}
	
}
function fnSideJsGrid(data){
	
	console.log(data);
	
	$("#sideMenuList").jsGrid({
		height: "auto",
		width: "49.8%",
		
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



