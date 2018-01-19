/**
 * ledgerMain.js
 */

let ledgerMemo = {
	list : new Array(),
	view : function(){			
		$("#ledgerMemoTb").empty();
		
		let tag = "";	
		for(let i=0; i<this.list.length; i++){
			
			//삭제선 체크
			let cancleText = "";
			let tagIsDel = "";
			if(ledgerMemo.list[i].state === "delete"){
				cancleText = "cancleText";
				tagIsDel = "<button class='btn_azure02' onclick='ledgerMemo.delCan("+i+")'>취소</button></td></tr>";
			}else{
				cancleText = "";
				tagIsDel = "<button class='btn_azure02' onclick='ledgerMemo.del("+i+")'>삭제</button></td></tr>";
			}
			
			if(emptyCheck.isNotEmpty(this.list[i].memoContent)){
				tag += "<tr><td><input id='memoContent_"+i+"' class='"+cancleText+"' type='text' onkeyup='ledgerMemo.edit("+i+")' value='"+this.list[i].memoContent+"'>";
			}else{
				tag += "<tr><td><input id='memoContent_"+i+"' class='"+cancleText+"' type='text' onkeyup='ledgerMemo.edit("+i+")' value=''>";
			}			
			tag += tagIsDel;
		}			
		$("#ledgerMemoTb").append(tag);	
		
	},
	
	//메모 삭제
	del : function(idx){
		//새로운 메모 삭제
		switch(ledgerMemo.list[idx].state){
		
		case "insert" :
			ledgerMemo.list.splice(idx,1);		
			break;
		case "update" :		
		case "select" :
			ledgerMemo.list[idx].state = "delete";
			break;
		}	
		this.view();
	},
	
	//메모 삭제 취소
	delCan : function(idx){
		
		this.list[idx].state = memoList[idx].state;
		this.list[idx].memoContent = memoList[idx].memoContent;		
		
		this.view();
	},
	
	//메모수정
	edit : function(idx){	
		this.list[idx].memoContent = $("#memoContent_"+idx).val();
		if(this.list[idx].state === "select"){
			this.list[idx].state = "update";	
		}
		
	}
	
}