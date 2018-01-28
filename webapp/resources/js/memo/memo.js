/**
 *  memo.js
 */

let memo = {	
	list : new Array(),
	clone : new Array(),
	type : "",
	
	init : function(list, type){		
		this.list = JSON.parse(list);
		this.clone = common.clone(this.list);
		this.type = type;
		return this;		
	},
	destroy : function(){
		this.list = new Array();
		this.clone = new Array();
		this.type = "";
		$("#memoTb").empty();
	},
	//메모출력
	view : function(){			
		$("#memoTb").empty();
		
		let tag = "";	
		for(let i=0; i<this.list.length; i++){
			
			//삭제선 체크
			let cancelText = "";
			let tagIsDel = "";
			if(memo.list[i].state === "delete"){
				cancelText = "cancelText";
				tagIsDel = "<button class='btn_azure02' onclick='memo.delCan("+i+")'>취소</button></td></tr>";
			}else{
				cancelText = "";
				tagIsDel = "<button class='btn_azure02' onclick='memo.del("+i+")'>삭제</button></td></tr>";
			}
			
			if(emptyCheck.isNotEmpty(this.list[i].memoContent)){
				tag += "<tr><td><input id='memoContent_"+i+"' class='"+cancelText+"' type='text' onkeyup='memo.edit("+i+")' value='"+this.list[i].memoContent+"'>";
			}else{
				tag += "<tr><td><input id='memoContent_"+i+"' class='"+cancelText+"' type='text' onkeyup='memo.edit("+i+")' value=''>";
			}			
			tag += tagIsDel;
		}			
		$("#memoTb").append(tag);	
		
	},
	
	
	//메모 추가
	add : function(){
		this.list.push({memoContent: "", memoSeq:0, state: "insert", memoType: this.type});
		this.view();
	},
	
	//전제 취소
	cancel : function(){
		this.list = common.clone(this.clone);	
		this.view();
	},
	
	//메모 삭제
	del : function(idx){
		//새로운 메모 삭제
		switch(memo.list[idx].state){
		
		case "insert" :
			memo.list.splice(idx,1);		
			break;
		case "update" :		
		case "select" :
			memo.list[idx].state = "delete";
			break;
		}	
		this.view();
	},
	
	//메모 삭제 취소
	delCan : function(idx){
		
		this.list[idx].state = this.clone[idx].state;
		this.list[idx].memoContent = this.clone[idx].memoContent;		
		
		this.view();
	},
	
	//메모수정
	edit : function(idx){	
		this.list[idx].memoContent = $("#memoContent_"+idx).val();
		if(this.list[idx].state === "select"){
			this.list[idx].state = "update";	
		}		
	},
	
	//메모저장
	insert : function(){
		$.ajax({		
			type: 'POST',
			url: common.path()+'/ajax/memoSave.do',
			data: {
				jsonStr : JSON.stringify(this.list),
				memoType : this.type
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {  
		    	memo.clone = data;
		    	memo.list = common.clone(memo.clone);
		    	memo.view();
		    },
		    error : function(xhr, stat, err) {			    	
		    	alert("memoSave error");
		    }
		});
	}
	
}