/**
 * lookup.js
 */

$(document).ready(function(){
	$('#paging').on("click button", function(event) {
		
		if(!common.isOnlyNum(event.target.value)) return;
		
		$("#pageNum").val(event.target.value);
		look.select();	
	});
	
	$("#pageCnt").on("change select", function(event){
		$("#pageNum").val("1");
	});
	
	$('#userList').on("click button", function(event) {	
		let name = event.target.id.split('_')[0];
		let idx = event.target.id.split('_')[1];
		
		switch(name){
		
		case "viewBtn" :			
			
			$("#userNum").text(look.userList[idx].userSeq);
			$("#userNo").val(look.userList[idx].userSeq);
			$("#userId").text(look.userList[idx].userId);
			$("#userNm").text(look.userList[idx].userName);		
			
			$.ajax({		
				type: 'POST',
				url: common.path()+'/admin/selectUserAuth.ajax',
				data: {
					userNo : Number(event.target.value)
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {		    	
			    	
			    	$("#userView").show();			    	
			    
			    	$("input:checkbox[id^='auth_']").prop("checked", false).val('none');			    	
			    	for(let i=0; i<data.length; i++){
			    		$("#auth_"+data[i].authNmSeq).prop("checked", true).val("select_"+data[i].authSeq);
			    	}
			    },
			    error : function(xhr, stat, err) {
			    	alert("error");
			    }
			});			
		break;
		}
	});
});

let look = {
	count : 0,
	pageNum : 1,
	pageCnt : 10,
	blockCnt : 10,
	userList : new Array(),
	
	init : function(pageCnt, pageNum, count, userList){
		this.pageCnt = Number(pageCnt);
		this.pageNum = Number(pageNum);		
		this.count = Number(count);
		this.userList = userList;
		return this;
	},
	
	select : function(){
		
		let param = {};
		param.srhSlt = $("#srhSlt").val();
		param.srhMsg = $("#srhMsg").val();	
		param.pageNum = $("#pageNum").val();
		param.pageCnt = $("#pageCnt").val();
		this.pageNum = $("#pageNum").val();
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/selectUserList.ajax',	
			data: param,
			dataType: 'json',
		    success : function(data) {		    
		    	look.init(param.pageCnt, param.pageNum, data.count, data.userList).view().paging();			
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	},
	
	view : function(){
		
		$("#userList").empty();
		
		let tag = "<table class='table table-sm table-striped table-bordered'>";
			tag	+= "<tr>";			
			tag	+= "<th style='width: 3%;'>번호</th>";
			tag	+= "<th>아이디</th>";
			tag	+= "<th>이름</th>";			
			tag	+= "<th>상세정보</th>";			
			tag += "</tr>";		
		
		for(let i=0; i<this.userList.length; i++){			
			tag += "<tr>";			
			tag += "<td>"+this.userList[i].userSeq+"</td>";
			tag += "<td>"+this.userList[i].userId+"</td>";
			tag += "<td>"+this.userList[i].userName+"</td>";	
			tag += "<td><button id='viewBtn_"+i+"' class='btn btn-outline-secondary btn-sm btn-sm-fs' value='"+this.userList[i].userSeq+"'>보기</button></td>";	
			tag += "</tr>";		
		}
		
		tag +="</table>";
		$("#userList").append(tag);
		return this;
	},
	
	paging : function(){
		
		$("#paging").empty();
		
		let tag = "<div class='btn-toolbar' role='toolbar'>";
		let blockNum = Math.floor(this.pageNum/this.blockCnt)*this.blockCnt;
		let blockLen = Math.ceil(this.count / this.pageCnt);
		
		if(blockNum !== 0){
			tag += "<div class='btn-group btn-group-sm mr-2' role='group'>";
			tag += "<button type='button' class='btn btn-secondary' value='1'><<</button>";
			
			if(this.pageNum <= 10){
				tag += "<button type='button' class='btn btn-secondary' value='1'><</button>";
			}else{
				tag += "<button type='button' class='btn btn-secondary' value='"+(blockNum-this.blockCnt)+"'><</button>";
			}
		}
		tag += "</div>";
		
		
		tag += "<div class='btn-group btn-group-sm mr-2' role='group'>";
		for(let i=blockNum; i<blockNum+this.blockCnt; i++){
			if(i === 0) continue;			
			
			if(i <= blockLen){
				if(this.pageNum === i){
					tag += "<button type='button' class='btn btn-dark' value="+i+">"+i+"</button>";
				}else{
					tag += "<button type='button' class='btn btn-secondary' value="+i+">"+i+"</button>";
				}
			}			
		}
		tag += "</div>";
		
		if(this.pageNum < blockLen){
			
			tag += "<div class='btn-group btn-group-sm mr-2' role='group'>";
			if(this.pageNum <= blockLen-this.blockCnt){
				tag += "<button type='button' class='btn btn-secondary' value='"+(blockNum+this.blockCnt)+"'>></button>";
			}else{
				tag += "<button type='button' class='btn btn-secondary' value='"+String(blockLen)+"'>></button>";
			}			
			tag += "<button type='button' class='btn btn-secondary' value='"+String(blockLen)+"'>>></button>";
			tag += "</div>";
		}		
				
		tag += "</div>";
		$("#paging").append(tag);
		
		return this;
	}
		
}