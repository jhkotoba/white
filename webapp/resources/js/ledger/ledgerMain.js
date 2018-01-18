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
			let cancleLine = "";
			if(ledgerMemo.list[i].state === "delete"){
				cancleLine = "cancleLine";
			}else{
				cancleLine = "";
			}
			
			if(emptyCheck.isNotEmpty(this.list[i].memoContent)){
				tag += "<tr><td><input id='memoContent_"+i+"' class='"+cancleLine+"' type='text' onkeyup='memoEdit("+i+")' value='"+this.list[i].memoContent+"'>";
			}else{
				tag += "<tr><td><input id='memoContent_"+i+"' class='"+cancleLine+"' type='text' onkeyup='memoEdit("+i+")' value=''>";
			}			
			tag += "<button onclick='memoDel("+i+")'>삭제</button></td></tr>";
		}			
		$("#ledgerMemoTb").append(tag);	
		
	}
}
