<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	//권한리스트 조회
	fnSelectAuth().done(function(data){
		fnJsGrid(data);
	});
});

//권한 grid
function fnJsGrid(data){
	
	let clone = common.clone(data);
	let authList = data;
	
	$("#authList").jsGrid({
		height: "auto",
		width: "100%",		
		
		editing: true,		       
		autoload: true,        
		data: authList,
		
		paging: false,
		pageSize: 10,
		
		fields: [
			{ align:"center", width: "10px",
                headerTemplate: function() {	
                    return $("<input>").attr("type", "checkbox").on("click", function () {
                    	if($(this).is(":checked")) $("input:checkbox[name=check]").prop('checked', true);
                    	else $("input:checkbox[name=check]").prop('checked', false);     
					});
                },
                itemTemplate: function(_, item) {
                    return $("<input>").attr("type", "checkbox").attr("name", "check");
                            /* .prop("checked", $.inArray(item, selectedItems) > -1)
                            .on("change", function () {
                                $(this).is(":checked") ? selectItem(item) : unselectItem(item);
                            }); */
                }	            
			},
			{ title:"권한명",		name:"authNm",	type:"text", align:"center"},
			{ title:"권한 설명",	name:"authCmt",	type:"text", align:"center"}			
		]
	});
	
	//권한추가
	$("#search-bar #add").on("click", function(){
		console.log(authList);
		console.log(clone);
		authList.push({authNm:"", authCmt:""});
		$("#authList").jsGrid("refresh");
	});
	
	//취소
	$("#search-bar #cancel").on("click", function(){
		
		//authList = common.clone(clone);
		authList.splice(0, authList.length);
		for(let i=0; i<clone.length; i++){
			authList.push(clone[i]);
		}
		$("#authList").jsGrid("refresh");
		
		console.log(authList);
		console.log(clone);
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