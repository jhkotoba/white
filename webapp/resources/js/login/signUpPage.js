/**
 * signUpPage.js
 */

$(document).ready(function(){	
	
	
	//userIdState
	$("#userId").keyup(function(e){
		
		//한글막기
		if (!(e.keyCode >=37 && e.keyCode<=40)) {
			var v = $(this).val();
			$(this).val(v.replace(/[^a-z0-9]/gi,''));			
		}
	
		$("#userIdCheck").val("N");
		$("#checkState").text("");
	});
	
	//passwdCheck
	$("#passwd").keyup(function(){		
		$("#passwdCheck").val("N");
		$("#passwdState").text("");
		$("#rePasswd").val("");
	});	
	$("#rePasswd").keyup(function(){
		var passwd = $("#passwd").val();
		var rePasswd = $("#rePasswd").val();
		if(passwd === rePasswd){
			$("#passwdCheck").val("Y");
			$("#passwdState").text("일치");			
		}else{
			$("#passwdCheck").val("N");
			$("#passwdState").text("불일치");	
		}
		
	});	
	
	//submit
	$("#submitBtn").click(function(){	
		if($("#userIdCheck").val()==="N"){
			alert("유저ID 체크필요 합니다.");
			return;
		}else if($("#passwdCheck").val()==="N"){
			alert("비밀번호가 동일하지 않습니다.");
			return;
		}else{		
			console.log("YYY");
			//submit 로직			
			$("#signUpForm").attr("method", "post");
			$("#signUpForm").attr("action", "/white/newSignUp.do").submit();
		}
	});	
});

//유저 중복체크
function userIdCheck(){
	
	var userId = str.trimAll($("#userId").val());	
	if(userId === ""){
		alert("ID를 입력하세요.");
		return;
	}
	$("#userId").val(userId);
		
	$.ajax({		
		type: 'POST',
		url: common.path()+'/ajax/userIdCheck.do',
		data: {
			userId : userId
		},
		dataType: 'json',
	    success : function(data, stat, xhr) {	
	    	if(data > 0){
	    		$("#userIdCheck").val("N");
	    		$("#checkState").text("존재하는 아이디 입니다.");
	    	}else{
	    		$("#userIdCheck").val("Y");
	    		$("#checkState").text("사용가능한 아이디 입니다.");
	    	}
	    },
	    error : function(xhr, stat, err) {
	    	console.log(xhr);
	    	console.log(stat);
	    	console.log(err);
	    }
	});
}