
let cmmMemo = {	
	_list : new Array(),
	_clone : new Array(),
	_memoType : "",
	_id : "",
	
	create : function(id, memoType){
		
		if(this._id !== ""){
			$("#"+this._id).empty();
		}
		
		this._memoType = memoType;
		this._id = "#"+id;
		
		let tag = "<div class='btn-group btn-group-sm width-full' role='group'>";
		tag += "<button id='memoAddBt' type='button' class='btn btn-secondary btn-fs nsrb' onclick='cmmMemo._add();'>메모 추가</button>";
		tag += "<button id='memoSaveBt' type='button' class='btn btn-secondary btn-fs nsrb' onclick='cmmMemo._insert();'>메모 저장</button>";
		tag += "<button id='memoCancelBt' type='button' class='btn btn-secondary btn-fs nsrb' onclick='cmmMemo._cancel();'>취소</button>";
		tag += "</div><div id='memeList'></div>";
		
		$(this._id).append(tag);		
		this._select();
	},
	
	_select : function(){
		
		if(this._isNotEmpty(this._memoType)){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/memo/selectMemoList.ajax',
				data: {
					memoType : this._memoType
				},
				dataType: 'json',
			    success : function(data) {
			    	cmmMemo._init(data)._view();
			    },
			    error : function(request, status, error){
			    	alert("error");
			    }
			});
		}
		return this;
	},
	
	_init : function(list){		
		this._list = list;
		this._clone = this._objCopy(this._list);
		return this;		
	},

	//메모출력
	_view : function(){		
		$("#memeList").empty();	
		
		let tag = "";				
		
		for(let i=0; i<this._list.length; i++){
			
			tag +=	"<div class='input-group'>";
			if(this._isNotEmpty(this._list[i].memoContent)){
				if(this._list[i].state === "delete"){
					tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' style='color:red;' onkeyup='cmmMemo._edit("+i+")' value='"+this._list[i].memoContent+"'>";
				}else if(this._list[i].state === "update"){
					tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' style='color:blue;' onkeyup='cmmMemo._edit("+i+")' value='"+this._list[i].memoContent+"'>";
				}else{
					tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' onkeyup='cmmMemo._edit("+i+")' value='"+this._list[i].memoContent+"'>";
				}				
			}else{
				tag +=	"<input id='memoContent_"+i+"' type='text' class='form-control' placeholder='메모를 입력하세요' style='color:green;' onkeyup='cmmMemo._edit("+i+")' value=''>";	
			}
			tag +=		"<div class='input-group-append'>";
			tag +=			"<button class='btn btn-secondary btn-fs nsrb' type='button' onclick='cmmMemo._del("+i+")'>삭제</button>";
			tag +=			"<button class='btn btn-secondary btn-fs nsrb' type='button' onclick='cmmMemo._delCan("+i+")'>취소</button>";
			tag +=		"</div></div>";			
		}		
		$("#memeList").append(tag);
	},	
	
	//메모 추가
	_add : function(){
		this._list.push({memoContent: "", memoSeq:0, state: "insert", memoType: this._memoType});
		this._view();
	},
	
	//전제 취소
	_cancel : function(){
		this._list = this._objCopy(this._clone);	
		this._view();
	},
	
	//메모 삭제
	_del : function(idx){
		//새로운 메모 삭제
		switch(cmmMemo._list[idx].state){
		
		case "insert" :
			cmmMemo._list.splice(idx,1);		
			break;
		case "update" :		
		case "select" :
			cmmMemo._list[idx].state = "delete";
			break;
		}	
		this._view();
	},
	
	//메모 삭제 취소
	_delCan : function(idx){
		
		this._list[idx].state = this._clone[idx].state;
		this._list[idx].memoContent = this._clone[idx].memoContent;		
		
		this._view();
	},
	
	//메모수정
	_edit : function(idx){	
		this._list[idx].memoContent = $("#memoContent_"+idx).val();
		
		if(this._list[idx].memoContent === this._clone[idx].memoContent){
			this._list[idx].state = "select";
			$("#memoContent_"+idx).css("color", "black");
		}else{
			this._list[idx].state = "update";
			$("#memoContent_"+idx).css("color", "blue");
		}
	},
	
	//메모저장
	_insert : function(){		
		if(confirm("메모을 반영 하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/memo/memoSave.ajax',
				data: {
					jsonStr : JSON.stringify(this._list),
					memoType : this._memoType
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {  
			    	cmmMemo._clone = data;
			    	cmmMemo._list = cmmMemo._objCopy(cmmMemo._clone);
			    	cmmMemo._view();
			    	alert("저장이 완료되었습니다.");
			    },
			    error : function(xhr, stat, err) {			    	
			    	alert("memoSave error");
			    }
			});
		}
	},
	
	_objCopy : function deepObjCopy (dupeObj) {
		var retObj = new Object();
		if (typeof(dupeObj) == 'object') {
			if (typeof(dupeObj.length) != 'undefined')
				var retObj = new Array();
			for (var objInd in dupeObj) {	
				if (typeof(dupeObj[objInd]) == 'object') {
					retObj[objInd] = deepObjCopy(dupeObj[objInd]);
				} else if (typeof(dupeObj[objInd]) == 'string') {
					retObj[objInd] = dupeObj[objInd];
				} else if (typeof(dupeObj[objInd]) == 'number') {
					retObj[objInd] = dupeObj[objInd];
				} else if (typeof(dupeObj[objInd]) == 'boolean') {
					((dupeObj[objInd] == true) ? retObj[objInd] = true : retObj[objInd] = false);
				}
			}
		}
		return retObj;
	},
	
	_isNotEmpty : function(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	},	
	_isEmpty : function(_str){
		return !this._isNotEmpty(_str);
	}
	
}