/**
 *  memo.js
 */

let memo = {	
	list : new Array(),
	clone : new Array(),
	type : "",
	
	select : function(memoType){
		
		if(emptyCheck.isNotEmpty(memoType)){		
			$.ajax({		
				type: 'POST',
				url: common.path()+'/memo/selectMemoList.ajax',
				data: {
					memoType : memoType
				},
				dataType: 'json',
			    success : function(data) {
			    	memo.init(data, memoType).view();
			    },
			    error : function(request, status, error){
			    	alert("error");
			    }
			});
		}
		return this;
	},
	
	init : function(list, type){		
		this.list = list;
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
			tag +=	"<div class='input-group mb-3'>";
			if(emptyCheck.isNotEmpty(this.list[i].memoContent)){
				if(this.list[i].state === "delete"){
					tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' aria-describedby='basic-addon2' style='color:red;' onkeyup='memo.edit("+i+")' value='"+this.list[i].memoContent+"'>";
				}else if(this.list[i].state === "update"){
					tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' aria-describedby='basic-addon2' style='color:blue; onkeyup='memo.edit("+i+")' value='"+this.list[i].memoContent+"'>";
				}else{
					tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' aria-describedby='basic-addon2' onkeyup='memo.edit("+i+")' value='"+this.list[i].memoContent+"'>";
				}				
			}else{
				tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' aria-describedby='basic-addon2' style='color:green;' onkeyup='memo.edit("+i+")' value=''>";	
			}
			tag +=		"<div class='input-group-append'>";
			tag +=			"<span class='input-group-text' id='basic-addon2'>";
			tag +=				"<div class='btn-group' role='group' aria-label='Basic example'>";
			tag +=	  				"<button type='button' class='btn btn-secondary' style='font-size:10px;' onclick='memo.del("+i+")'>삭제</button>";
			if(this.list[i].state === "select" || this.list[i].state === "delete" || this.list[i].state === "update"){
				tag += 				"<button type='button' class='btn btn-secondary' style='font-size:10px;' onclick='memo.delCan("+i+")'>취소</button>";	
			}			
			tag +=	"</div></span></div></div>";
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
		
		if(this.list[idx].memoContent === this.clone[idx].memoContent){
			this.list[idx].state = "select";
			$("#memoContent_"+idx).css("color", "black");
		}else{
			this.list[idx].state = "update";
			$("#memoContent_"+idx).css("color", "blue");
		}
	},
	
	//메모저장
	insert : function(){
		if(confirm("메모을 반영 하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/memo/memoSave.ajax',
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
	
}