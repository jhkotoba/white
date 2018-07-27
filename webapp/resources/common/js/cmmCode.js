//공통코드
let cmmCode = {		
	select : function(codePrt){	
		let deferred = $.Deferred();		
		$.ajax({		
			type: 'POST',
			url: getContextPath()+'/white/selectCodeList.ajax',
			data : {
				codePrt : codePrt.toUpperCase()
			},
			dataType: 'json',
			async : true,
		    success : function(data) {
		    	deferred.resolve(data);
		    },
		    error : function(request, status, error){
		    	deferred.reject(error);
		    }
		});		
		return deferred.promise();
	}	
}

function getContextPath(){
    let offset = location.href.indexOf(location.host)+location.host.length;
    let ctxPath = location.href.substring(offset,location.href.indexOf('/',offset+1));
    return ctxPath;
}