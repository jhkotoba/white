/**
 * ledgerData.js
 */
$(document).ready(function(){
	
});

let file = {		
		backup : function(){
			
			if(confirm("데이터를 백업하시겠습니까?")){				
				$("#fileDownload").attr("action", common.path()+"/ledgerDataBackup.do").submit();
			}
			
		},
		init : function(){
			
			if(confirm("데이터를 초기화 하시겠습니까?")){
				if(confirm("기존데이터를 삭제됩니다 기존데이터를 백업&다운로드 하시겠습니까?")){					
					$("#fileDownload").attr("action", common.path()+"/ledgerDataBackup.do").submit();
				}else{
					if(confirm("업로드한 데이터로 초기화 하시겠습니까? 기존데이터는 삭제됩니다.")){
						let formData = new FormData();
						formData.append("file", $("input[name=dataFile]")[0].files[0]);						
						$.ajax({
						    url: common.path()+'/ajax/ledgerDataInit.do',
						    data:  formData, 
						    processData: false,
						    contentType: false,
						    type: 'POST',
						    success: function(data){
						    },
						    error : function(request,status,error){			    	
						    	alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
						    }
						});
					}					
				}
			}
			
			
			
			
		}
		
}





