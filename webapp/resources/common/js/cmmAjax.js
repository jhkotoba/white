/**
 * ajax관련 공통
 */

//ajax 셋업
$.ajaxSetup({
	type: "post",
	dataType: "json",
	async : true,
	error : function(request, status, error){
		if(request.status === 488){
			alert("세션이 만료되었습니다. 로그인 해주세요.");
			location.href = getContextPath()+"/main";
		}else{			
			alert("통신에 실패하였습니다.");
			let deferred = $.Deferred();
			deferred.reject({"request":request, "status":status, "error":status});			
		}
    }
});

//ajax 시작할때 실행되는 영역
$(document).ajaxSend(function() {
	 $(".blind").show(100);
});

//ajax 성공하면 실행되는 영역
$(document).ajaxComplete(function() {
	$(".blind").hide(400);
});

//ajax 코드 조회
function cfnSelectCode(codePrt, targetId){
	if(isEmpty(targetId)){
		return cfnCmmAjax("/white/selectCodeList", {"codePrt" : codePrt});
	}else{
		cfnCmmAjax("/white/selectCodeList", {"codePrt" : codePrt}).done(function(cdList){
			let select = document.getElementById(targetId);
			let option = null;	
			for(let i=0; i<cdList.length; i++){
				option = document.createElement("option");
				option.value = cdList[i].code;
				option.textContent = cdList[i].codeNm;
				select.appendChild(option);		
			}
		});
	}		
}

//ajax 권한 리스트 조회 - no(유저번호) 없으면 전체 조회
function cfnSelectAuth(no, async){
	if(isEmpty(no)){
		return cfnCmmAjax("/admin/selectAuthList");	
	}else{
		return cfnCmmAjax("/admin/selectUserAuth", {"no" : no});	
	}
}

//ajax 공통
function cfnCmmAjax(url, param, isGrid){
	let deferred = $.Deferred();
	$.ajax({
		url: getContextPath()+url+".ajax",
		data : isEmpty(param) === true ? null : param,
	    success : function(data) {
	    	if(isGrid === true) deferred.resolve({data: data.list, itemsCount: data.itemsCount});
	    	else deferred.resolve(data);
	    }	    
	});		
	return deferred.promise();
}

//동기 ajax
function cfnCmmSyncAjax(url, param){
	let result = null;
	$.ajax({
		url: getContextPath()+url+".ajax",
		async : false,
		data : isEmpty(param) === true ? null : param,
	    success : function(data) {
	    	result = data;
	    }
	});
	return result;
}