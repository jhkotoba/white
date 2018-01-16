/**
 * ledgerMain.js
 */

let ledgerMemo = {
	list : new Array(),
	view : function(){			
		$("#ledgerMemoTb").empty();
		//console.log(this.list.length);
		let tag = "";	
		for(let i=0; i<this.list.length; i++){			
			if(emptyCheck.isNotEmpty(this.list[i]["memo_content"])){
				tag += "<tr><td id='memo_content_"+i+"'><input type='text' value='"+this.list[i]["memo_content"]+"'>";
			}else{
				tag += "<tr><td id='memo_content_"+i+"'><input type='text' value=''>";
			}			
			tag += "<button id='memoDel_"+i+"'>삭제</button></td></tr>";
		}			
		$("#ledgerMemoTb").append(tag);
	}
}
