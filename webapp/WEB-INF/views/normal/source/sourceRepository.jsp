<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>

<script type="text/javascript">
$(document).ready(function(){
	
    $("#sourceList").jsGrid({
        height: "auto",
        width: "100%",
        
        paging: true,
        pageLoading: true,
        pageSize : 10,
        pageButtonCount : 10,
       
        autoload: true,        
        controller: {
            loadData: function(filter) {
            	let deferred = $.Deferred();
            	
            	let param = {};
            	if(filter !== "" || filter !==undefined || filter !== null){
            		param.pageIndex = filter.pageIndex;
                	param.pageSize = filter.pageSize;                	
            	}else{
            		param.pageIndex = this.pageIndex;
                	param.pageSize = this.pageSize;
            	}            	
               
                $.ajax({
                	type: 'POST',
                	data : param,
                    url: common.path()+'/source/selectSourceList.ajax',
                    dataType: 'json',
                    success: function(data){
                        deferred.resolve({
    						data: data.list,    						
    						itemsCount: data.itemsCount
    					});
                    }
                });                
                return deferred.promise();
            }
        }, 		
 
        fields: [
            { title:"번호",		name:"sourceSeq", 	type:"text", width:"4%"},
            { title:"종류", 		name:"codeNm", 		type:"text", width:"8%"},
            { title:"글제목", 	name:"title",		type:"text", width:"70%"},
            { title:"작성자",		name:"userId",		type:"text", width:"8%"},
            { title:"날짜",		name:"regDate",		type:"text", width:"10%"}
        ]
    });
	
});
</script>

<div class="article">
	<div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
		<h1 class="h2 nsrb">소스 저장소</h1>
	</div>	
</div>

<div id="sourceList"></div>