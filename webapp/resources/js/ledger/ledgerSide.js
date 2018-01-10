/**
 * ledgerSide.js
 */
$(document).ready(function(){	
	
	// 상세 설정 show, hide
	$('#ledgerSetup').click(function(){
		if($("#setupList").css("display")=="none"){
			$("#setupList").show();
		}else{
			$("#setupList").hide();
		}
	});
		
});
		
let ledgerSide = {
	pageSubmit : function(page){
		
		$("#sideClick").attr("value", page);	
		$("#sideClickForm").attr("method", "post");
		$("#sideClickForm").attr("action", "ledgerPage.do").submit();
	}		
}