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
		//this.pageNum = Number(pageNum);
		this.pageNum = 11;//test
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
		
		let pagingCnt = Math.ceil(this.count/this.pageCnt);
		let blockNum = Math.ceil(pagingCnt/this.blockCnt);
		let tag = "<div class='paging'>";
		for(let i=0; i<pagingCnt; i++){
			
			
			
				if(this.pageNum===(i+1)){
					tag += "<button style='font-weight:bold;'>"+(i+1)+"</button>";
				}else{
					tag += "<button>"+(i+1)+"</button>";
				}
			
			
		}		
		$("#paging").append(tag);
		tag += "</div>";
		return this;
	}
		
}