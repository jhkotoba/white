/**
 * adminLookup.js
 */

$(document).ready(function(){
	$('#paging').on("click button", function(event) {
		
		if(!common.isOnlyNum(event.target.value)) return;
		
		$("#pageNum").val(event.target.value);
		ad.select();	
	});
	
	$("#pageCnt").on("change select", function(event){
		$("#pageNum").val("1");
	});
	
	$('#userList').on("click button", function(event) {
		
		switch(event.target.name){
		
		case "viewBtn" :
			$("#detail").show();
		break;
		}
		
		
		
			
	});
});

let ad = {
	count : 0,
	pageNum : 1,
	pageCnt : 10,
	blockCnt : 10,
	userList : new Array(),
	userClone : new Array(),
	
	init : function(pageCnt, pageNum, count, userList){
		this.pageCnt = Number(pageCnt);
		this.pageNum = Number(pageNum);		
		this.count = Number(count);
		this.userList = userList;
		return this;
	},
	
	select : function(){
		
		let param = {};
		param.srhId = $("#srhId").val();
		param.srhNm = $("#srhNm").val();	
		param.pageNum = $("#pageNum").val();
		param.pageCnt = $("#pageCnt").val();
		this.pageNum = $("#pageNum").val();
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/ajax/selectUserList.do',	
			data: param,
			dataType: 'json',
		    success : function(data) {		    
		    	ad.init(param.pageCnt, param.pageNum, data.count, data.userList).view().paging();			
		    },
		    error : function(request, status, error){
		    	alert("error");
		    }
		});
	},
	
	view : function(){
		
		$("#userList").empty();
		
		let tag = "<table border=1 class='font10'>";
			tag	+= "<tr>";			
			tag	+= "<th>userNo</th>";
			tag	+= "<th>userId</th>";
			tag	+= "<th>userName</th>";			
			tag	+= "<th>btn</th>";			
			tag += "</tr>";		
		
		for(let i=0; i<this.userList.length; i++){			
			tag += "<tr>";			
			tag += "<td>"+this.userList[i].userSeq+"</td>";
			tag += "<td>"+this.userList[i].userId+"</td>";
			tag += "<td>"+this.userList[i].userName+"</td>";		
			tag += "<td><button name='viewBtn' value='"+this.userList[i].userSeq+"'>보기</button></td>";		
			tag += "</tr>";		
		}
		
		tag +="</table>";
		$("#userList").append(tag);
		return this;
	},
	
	paging : function(){
		
		$("#paging").empty();
		
		let tag = "<div class='paging'>";
		let blockNum = Math.floor(this.pageNum/this.blockCnt)*this.blockCnt;
		let blockLen = Math.ceil(this.count / this.pageCnt);
		
		if(blockNum !== 0){
			tag += "<button value='1' style='width: 50px;'>◀◀</button>";
			
			if(this.pageNum <= 10){
				tag += "<button value='1'>◀</button>";
			}else{
				tag += "<button value='"+(blockNum-this.blockCnt)+"'>◀</button>";
			}
		}
		
		for(let i=blockNum; i<blockNum+this.blockCnt; i++){
			if(i === 0) continue;
			
			if(i <= blockLen){
				if(this.pageNum === i){
					tag += "<button value="+i+" style='font-weight:bold;'>"+i+"</button>";
				}else{
					tag += "<button value="+i+">"+i+"</button>";
				}
			}
		}		
		
		if(this.pageNum < blockLen){
			if(this.pageNum <= blockLen-this.blockCnt){
				tag += "<button value='"+(blockNum+this.blockCnt)+"'>▶</button>";
			}else{
				tag += "<button value='"+String(blockLen)+"'>▶</button>";
			}			
			tag += "<button value='"+String(blockLen)+"' style='width: 50px;'>▶▶</button>";
		}		
				
		tag += "</div>";
		$("#paging").append(tag);
		
		return this;
	}
		
}