/**
 * adminLookup.js
 */

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
		this.userClone = common.clone(this.userList);
		return this;
	},
	
	view : function(){
		
		
		return this;
	},
	
	paging : function(){
		
		$("#paging").empty();
		
		let tag = "<div class='paging'>";
		let blockNum = Math.floor(this.pageNum/this.blockCnt)*10;		
		for(let i=blockNum; i<blockNum+this.blockCnt; i++){
			if(i === 0) continue;
						
			if(this.pageNum === i){
				tag += "<button style='font-weight:bold;'>"+i+"</button>";
			}else{
				tag += "<button>"+i+"</button>";
			}			
		}
		tag += "</div>";
		$("#paging").append(tag);
		
		return this;
	}
		
}