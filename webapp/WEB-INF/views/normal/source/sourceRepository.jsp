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
       
        autoload: true,        
        controller: {
            loadData: function(filter) {
            	let deferred = $.Deferred();
               
                $.ajax({
                	type: 'POST',
                	data : {
                		pageNum : 1,
                		pageCnt : 10,
                		blockCnt : 10
                	},
                    url: common.path()+'/source/selectSourceCodeList.ajax',
                    dataType: 'json',
                    success: function(data){
                        deferred.resolve({
    						data: data.list,    						
    						itemsCount: data.totalCnt
    					});
                    }
                });                
                return deferred.promise();
            }
        }, 		
 
        fields: [
            { title: "번호",		name: "sourceSeq", 	type: "text"},
            { title: "종류", 		name: "codeNm", 	type: "text"},
            { title: "글제목", 	name: "title",		type: "text"},
            { title: "작성자",	name: "userId",		type: "text"},
            { title: "날짜",		name: "regDate",	type: "text"}
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