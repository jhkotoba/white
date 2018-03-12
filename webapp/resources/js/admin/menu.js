/**
 * adminMenu.js
 */

$(document).ready(function(){
	$('#navList').on("change keyup input", function(event) {
		nav.sync(event.target);
	});
	
	$('#navList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "navUp" :
			nav.change(Number(idx), "up").sync(event.target).view();
			break;
		case "navDown" :
			nav.change(Number(idx), "down").sync(event.target).view();
			break;
		case "navShowYn" :
			nav.sync(event.target);
			break;
		}
	});	
	
	$('#sideList').on("change keyup input", function(event) {
		side.sync(event.target);
	});
	
	$('#sideList').on("click button", function(event) {
		let idx = event.target.id.split('_')[1];
		let name = event.target.id.split('_')[0];
		switch(name){		
		case "sideUp" :
			side.change(Number(idx), "up").sync(event.target).view();
			break;
		case "sideDown" :
			side.change(Number(idx), "down").sync(event.target).view();
			break;
		case "sideShowYn" :
			side.sync(event.target);
			break;
		}
	});
});

let nav = {
	navList : new Array(),
	navClone : new Array(),
	authList : new Array(),
	lastIdx : 0,
	
	init : function(navList, authList){		
    	this.navList = navList;
    	this.authList = authList;
    	this.navClone = common.clone(this.navList);
    	return this;
	},
	
	add : function(){
		if(this.navList.length === 0){
			this.navList.push({navUrl : '', navAuthNmSeq : '', navNm : '', navShow : 'Y', navOrder : 1, state: 'insert'});
		}else{
			this.navList.push({navUrl : '', navAuthNmSeq : '', navNm : '', navShow : 'Y', navOrder : (this.navList[this.navList.length-1].navOrder+1), state: 'insert'});
		}				
		return this;
	},
	
	del : function(idx){		
		this.navList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.navList = common.clone(this.navClone);		
		return this;
	},
	
	view : function(){
		
		$("#navList").empty();
		
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";			
			tag	+= "<th>name</th>";
			tag	+= "<th>navUrl</th>";
			tag	+= "<th>auth</th>";
			tag += "<th>show</th>";
			tag	+= "<th>move</th>";
			tag += "</tr>";
		
		this.lastIdx = 0;
		let addAttr = {chked:"", cls:"", read:""};
		
		if(this.navList.length === 0){
			tag += "<tr><td colspan='6'>no data</td></tr>";
			tag +="</table>";
			$("#navList").append(tag);
		}else{
			for(let i=0; i<this.navList.length; i++){			
				
				if(this.navList[i].state === "insert"){
					addAttr = {chked:"", cls:"add", read:""};			
				}else if(this.navList[i].state === "delete"){				
					addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
				}else if(this.navList[i].state === "update"){
					addAttr = {chked:"", cls:"edit", read:""};
				}else{
					addAttr = {chked:"", cls:"", read:""};
				}
				
				this.navList[i].navShowYn === "Y" ? useCls = "btn_azure01" : useCls = "btn_pink01";
				
				tag += "<tr>";			
				tag += "<td><input id='navDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
				tag += "<td>"+(i+1)+"</td>";
				tag += "<td><input id='navNm_"+i+"' type='text' class='"+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navNm
					+"' onclick='side.cancel().view("+this.navList[i].navSeq+",\""+this.navList[i].navUrl+"\")'></td>";
				tag += "<td><input id='navUrl_"+i+"' type='text' class=' "+addAttr.cls+"' "+addAttr.read+" value='"+this.navList[i].navUrl
					+"' onclick='side.cancel().view("+this.navList[i].navSeq+",\""+this.navList[i].navUrl+"\")'></td>";
				tag += "<td><select id='navAuthNmSeq_"+i+"' class='"+addAttr.cls+"'>";				
				tag += "<option value=''>선택</option>";			
				for(let j=0; j<this.authList.length; j++){
					String(this.navList[i].navAuthNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
					tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
				}
				tag += "<td><input id='navShowYn_"+i+"' type='button' class='"+addAttr.cls+" "+useCls+"' "+addAttr.read+" value='"+this.navList[i].navShowYn+"'></td>";
				tag += "</select></td>";
				if(this.navList[i].state !== "insert"){
					tag += "<td><button id='navUp_"+i+"' class='btn_azure02'>위로</button><button id='navDown_"+i+"' class='btn_azure02'>아래</button></td>";
					this.lastIdx++;
				}else{
					tag += "<td><button id='navUp_"+i+"' class='btn_disabled02' disabled'>위로</button><button id='navDown_"+i+"' class='btn_disabled02' disabled>아래</button></td>";
				}
				
				tag += "</tr>";	
			}			
			tag +="</table>";
			$("#navList").append(tag);
			
			//게시물이 1개일경우 순서버튼 막기
			$("#navList #navUp_0").removeClass().addClass("btn_disabled02").prop("disabled", true);
			if(this.navList.length === 1){				
				$("#navList #navDown_0").removeClass().addClass("btn_disabled02").prop("disabled", true);
			}else{				
				$("#navList #navDown_"+String(this.lastIdx-1)).removeClass().addClass("btn_disabled02").prop("disabled", true);
			}
		}		
		return this;
	},
	
	change : function(idx, isUpDown){
		let temp = null;
		switch(isUpDown){
		case "up" :
			if(idx <= 0){				
				return this;
			}else{								
				temp = this.navList[idx].navOrder;
				this.navList[idx].navOrder = this.navList[idx-1].navOrder;
				this.navList[idx-1].navOrder = temp;
				
				temp = common.clone(this.navList[idx]);				
				this.navList[idx] = common.clone(this.navList[idx-1]);
				this.navList[idx-1] = temp;
			}
			break;
		case "down" :
			if(idx >= (this.navList.length-1)){
				return this;
			}else{
				temp = this.navList[idx].navOrder;
				this.navList[idx].navOrder = this.navList[idx+1].navOrder;
				this.navList[idx+1].navOrder = temp;
				
				temp = this.navList[idx];
				this.navList[idx] = this.navList[idx+1];
				this.navList[idx+1] = temp;
			}
			break;
		}
		return this;
	},
	
	sync : function(target){
		let name = target.id.split('_')[0];
		let idx = Number(target.id.split('_')[1]);
		//alert(name);
		switch(name){
		
		case "navDel":
			if(this.navList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){							
				$("#navNm_"+idx).removeClass().addClass("redLine").prop("readOnly", true);
				$("#navUrl_"+idx).removeClass().addClass("redLine").prop("readOnly", true);
				$("#navAuthNmSeq_"+idx).removeClass().addClass("redLine").prop("disabled", true);
				this.navList[idx].state = "delete";
			}else{				
				$("#navNm_"+idx).removeClass().prop("readOnly", false);
				$("#navUrl_"+idx).removeClass().prop("readOnly", false);
				$("#navAuthNmSeq_"+idx).removeClass().prop("disabled", false);
				if(idx !== "0") $("#navUp_"+idx).removeClass().addClass("btn_azure02").prop("disabled", false);			
				if(idx !== this.lastIdx-1) $("#navDown_"+idx).removeClass().addClass("btn_azure02").prop("disabled", false);
				this.navList[idx].state = "select";
			}
			break;
		case "navShowYn" :
			if(target.value === "Y"){
				this.navList[idx][name] = "N";
				$(target).val("N").removeClass().addClass("btn_pink01");
			}else if(target.value === "N"){
				this.navList[idx][name] = "Y";
				$(target).val("Y").removeClass().addClass("btn_azure01");
			}
			break;			
		case "navUp" :
			syncFunc(this, idx-1);
			break;
		case "navDown" :
			syncFunc(this, idx+1);			
			break;
		default :
			this.navList[idx][name] = String(target.value);
			break;		
		}
		syncFunc(this, idx);
		
		
		function syncFunc(obj, idx){			
			switch(obj.navList[idx].state){
			case "select" :
			case "update" :
				if($(target).is(":checked") === false && obj.equals(idx) === false){
					obj.navList[idx].state = "update";			
					$("#navNm_"+idx).addClass("edit").prop("readOnly", false);
					$("#navUrl_"+idx).addClass("edit").prop("readOnly", false);
					$("#navAuthNmSeq_"+idx).addClass("edit").prop("readOnly", false);
				}else{
					$(target).is(":checked") === true ? obj.navList[idx].state = "delete" : obj.navList[idx].state = "select";					
					$("#navNm_"+idx).removeClass();
					$("#navUrl_"+idx).removeClass();
					$("#navAuthNmSeq_"+idx).removeClass();					
				}
				break;
			}
		}
		return this;
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		for(let i=0; i<this.navList.length; i++){
			
			// 빈값, null 체크
			if(this.navList[i].navNm === '' || this.navList[i].navNm === null){
				check = {check : false, msg : (i+1) + "행의 메뉴이름이 입력되지 않았습니다."};
				break;
			}else if(this.navList[i].navUrl === '' || this.navList[i].navUrl === null){
				check = {check : false, msg : (i+1) + "행의 URL이 입력되지 않았습니다."};
				break;				
			}else if(this.navList[i].navAuthNmSeq === '' || this.navList[i].navAuthNmSeq === null){
				check = {check : false, msg : (i+1) + "행의 권한이 선택되지 않았습니다"};
				break;
			}
			
			if(this.navList[i].state === "select") saveChk++;
		}

		if(this.navList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.navList.length; i++){		
			
			if(this.navList[i].state === "insert"){
				inList.push(this.navList[i]);
			}else if(this.navList[i].state === "update"){
				upList.push(this.navList[i]);
			}else if(this.navList[i].state === "delete"){
				delList.push(this.navList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("추가, 수정, 삭제한 네비URL을 적용하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/ajax/inUpDelNavMenuList.do',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	alert(data.inCnt+" 개의 메뉴가 입력, "+data.upCnt+" 개의 메뉴가 수정, "+ data.delCnt+" 개의 메뉴가 삭제되었습니다");		    	
		    	white.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});
	},
	
	equals : function(idx){
		
		if(this.navList[idx].navNm !== this.navClone[idx].navNm){
			return false;
		}else if(this.navList[idx].navUrl !== this.navClone[idx].navUrl){
			return false;
		}else if(String(this.navList[idx].navAuthNmSeq) !== String(this.navClone[idx].navAuthNmSeq)){
			return false;
		}else if(this.navList[idx].navShowYn !== this.navClone[idx].navShowYn){
			return false;
		}else{
			return true;	
		}
	}
	
}

let side = {
	sideList : new Array(),
	sideClone : new Array(),
	navSeq : "",
	navUrl : "",
	lastIdx : 0,
	
	init : function(sideList, authList){		
    	this.sideList = sideList;
    	this.authList = authList;
    	this.sideClone = common.clone(this.sideList);
    	return this;
	},
	
	add : function(){console.log(this.navSeq);
		if(emptyCheck.isNotEmpty(this.navSeq)){
			if(this.sideList.length === 0){
				this.sideList.push({navSeq : this.navSeq, sideUrl : '', sideAuthNmSeq : '', sideNm : '', sideShowYn : 'Y', sideOrder : 1, state: 'insert'});
			}else{
				this.sideList.push({navSeq : this.navSeq, sideUrl : '', sideAuthNmSeq : '', sideNm : '', sideShowYn : 'Y', sideOrder : (this.sideList[this.sideList.length-1].sideOrder+1), state: 'insert'});	
			}
		}				
		return this;
	},
	
	del : function(idx){		
		this.sideList.splice(idx,1);
		return this;
	},
	
	cancel : function(){
		this.sideList = common.clone(this.sideClone);		
		return this;
	},
	
	view : function(navSeq, navUrl){
		if(emptyCheck.isNotEmpty(navSeq)){
			this.navSeq = navSeq;
			this.navUrl = navUrl;
		}
	
		$("#sideList").empty();
	
		let tag = "<table border=1>";
			tag	+= "<tr>";			
			tag += "<th>Del</th>";
			tag	+= "<th>No</th>";			
			tag	+= "<th>name</th>";
			tag	+= "<th>sideUrl</th>";
			tag	+= "<th>auth</th>";
			tag	+= "<th>show</th>";
			tag	+= "<th>move</th>";
			tag += "</tr>";
		
		this.lastIdx = 0;
		let sideView = {cnt:0, idxList : new Array()};
		let addAttr = {chked:"", cls:"", read:""};
		
		if(this.sideList.length === 0){
			tag += "<tr><td colspan='7'>no data</td></tr>";
			tag +="</table>";
			$("#sideList").append(tag);
		}else{
			for(let i=0; i<this.sideList.length; i++){
				
				//navSeq 일치하는 것만 view하는 조건문
				if(this.sideList[i].navSeq === this.navSeq){ 
				
					if(this.sideList[i].state === "insert"){
						addAttr = {chked:"", cls:"add", read:""};			
					}else if(this.sideList[i].state === "delete"){				
						addAttr = {chked:"checked='checked'", cls:"redLine", read:"readonly='readonly'"};
					}else if(this.sideList[i].state === "update"){
						addAttr = {chked:"", cls:"edit", read:""};
					}else{
						addAttr = {chked:"", cls:"", read:""};
					}
					
					this.sideList[i].sideShowYn === "Y" ? useCls = "btn_azure01" : useCls = "btn_pink01";
					
					tag += "<tr>";			
					tag += "<td><input id='sideDel_"+i+"' type='checkbox' "+addAttr.chked+" title='삭제 체크박스'></td>";
					tag += "<td>"+(i+1)+"</td>";
					tag += "<td><input id='sideNm_"+i+"' type='text' class='"+addAttr.cls+"' "+addAttr.read+" value='"+this.sideList[i].sideNm+"'></td>";					
					tag += "<td>"+this.navUrl+"<input id='sideUrl_"+i+"' type='text' class=' "+addAttr.cls+"' "+addAttr.read+" value='"+this.sideList[i].sideUrl+"'></td>";
					tag += "<td><select id='sideAuthNmSeq_"+i+"' class='"+addAttr.cls+"'>";
					tag += "<option value=''>선택</option>";			
					for(let j=0; j<this.authList.length; j++){
						String(this.sideList[i].sideAuthNmSeq) === String(this.authList[j].authNmSeq) ? selected = "selected='selected'" : selected = "";
						tag += "<option "+selected+" value='"+this.authList[j].authNmSeq+"'>"+this.authList[j].authNm+"</option>";
					}	
					tag += "</select></td>";
					tag += "<td><input id='sideShowYn_"+i+"' type='button' class='"+addAttr.cls+" "+useCls+"' "+addAttr.read+" value='"+this.sideList[i].sideShowYn+"'></td>";
					if(this.sideList[i].state !== "insert"){
						tag += "<td><button id='sideUp_"+i+"' class='btn_azure02'>위로</button><button id='sideDown_"+i+"' class='btn_azure02'>아래</button></td>";
						this.lastIdx++;
					}else{
						tag += "<td><button id='sideUp_"+i+"' class='btn_disabled02' disabled'>위로</button><button id='sideDown_"+i+"' class='btn_disabled02' disabled>아래</button></td>";
					}
					
					tag += "</tr>";	
					sideView.cnt ++;
					sideView.idxList.push(i);
				}
			}
			
			//해당 게시물이 0개일경우 NoData
			if(sideView.cnt === 0){
				tag += "<tr><td colspan='7'>no data</td></tr>";				
			}
			tag +="</table>";
			$("#sideList").append(tag);
			$("#sideList #sideUp_"+sideView.idxList[0]).removeClass().addClass("btn_disabled02").prop("disabled", true);
			$("#sideList #sideDown_"+sideView.idxList[sideView.idxList.length-1]).removeClass().addClass("btn_disabled02").prop("disabled", true);
		}
		return this;
	},
	
	change : function(idx, isUpDown){
		let temp = null;
		let navSeq = this.sideList[idx].navSeq;
		
		switch(isUpDown){
		case "up" :
			if(idx <= 0){				
				return this;
			}else{
				
				let upIdx = 1;				
				while(true){					
					if(navSeq !== this.sideList[idx-upIdx].navSeq){
						upIdx++;
					}else{
						break;
					}
				}
				
				temp = this.sideList[idx].sideOrder;
				this.sideList[idx].sideOrder = this.sideList[idx-upIdx].sideOrder;
				this.sideList[idx-upIdx].sideOrder = temp;
				
				temp = common.clone(this.sideList[idx]);				
				this.sideList[idx] = common.clone(this.sideList[idx-upIdx]);
				this.sideList[idx-upIdx] = temp;
			}
			break;
		case "down" :
			if(idx >= (this.sideList.length-1)){
				return this;
			}else{
				
				let downIdx = 1;				
				while(true){					
					if(navSeq !== this.sideList[idx+downIdx].navSeq){
						downIdx++;
					}else{
						break;
					}
				}
				
				temp = this.sideList[idx].sideOrder;
				this.sideList[idx].sideOrder = this.sideList[idx+downIdx].sideOrder;
				this.sideList[idx+downIdx].sideOrder = temp;
				
				temp = this.sideList[idx];
				this.sideList[idx] = this.sideList[idx+downIdx];
				this.sideList[idx+downIdx] = temp;
			}
			break;
		}
		return this;
	},
	
	sync : function(target){			
		
		let name = target.id.split('_')[0];
		let idx = Number(target.id.split('_')[1]);
		let navSeq = this.sideList[idx].navSeq;
		
		switch(name){
		
		case "sideDel":
			if(this.sideList[idx].state === "insert" && $(target).is(":checked") === true){
				this.del(idx).view();
				return;
			}			
			
			if( $(target).is(":checked") === true ){							
				$("#sideNm_"+idx).removeClass().addClass("redLine").prop("readOnly", true);
				$("#sideNavUrl_"+idx).removeClass().addClass("redLine").prop("readOnly", true);
				$("#sideUrl_"+idx).removeClass().addClass("redLine").prop("readOnly", true);
				$("#sideAuthNmSeq_"+idx).removeClass().addClass("redLine").prop("disabled", true);	
				this.sideList[idx].state = "delete";
			}else{				
				$("#sideNm_"+idx).removeClass().prop("readOnly", false);
				$("#sideNavUrl_"+idx).removeClass().prop("readOnly", false);
				$("#sideUrl_"+idx).removeClass().prop("readOnly", false);
				$("#sideAuthNmSeq_"+idx).removeClass().prop("disabled", false);
				if(idx !== "0") $("#sideUp_"+idx).removeClass().addClass("btn_azure02").prop("disabled", false);				
				if(idx !== this.lastIdx-1) $("#sideDown_"+idx).removeClass().addClass("btn_azure02").prop("disabled", false);
				this.sideList[idx].state = "select";
			}
			break;
		case "sideUp" :			
			let upIdx = 1;				
			while(true){					
				if(navSeq !== this.sideList[idx-upIdx].navSeq){
					upIdx++;
				}else{
					break;
				}
			}			
			syncFunc(this, idx-upIdx);
			break;
		case "sideDown" :
			let downIdx = 1;				
			while(true){					
				if(navSeq !== this.sideList[idx+downIdx].navSeq){
					downIdx++;
				}else{
					break;
				}
			}
			syncFunc(this, idx+downIdx);			
			break;
		case "sideShowYn" :
			if(target.value === "Y"){
				this.sideList[idx][name] = "N";
				$(target).val("N").removeClass().addClass("btn_pink01");
			}else if(target.value === "N"){
				this.sideList[idx][name] = "Y";
				$(target).val("Y").removeClass().addClass("btn_azure01");
			}
			break;	
		default :
			this.sideList[idx][name] = String(target.value);
			break;		
		}
		syncFunc(this, idx);
		
		
		function syncFunc(obj, idx){			
			switch(obj.sideList[idx].state){
			case "select" :
			case "update" :
				if($(target).is(":checked") === false && obj.equals(idx) === false){
					obj.sideList[idx].state = "update";			
					$("#sideNm_"+idx).addClass("edit").prop("readOnly", false);
					$("#sideNavUrl_"+idx).addClass("edit").prop("readOnly", false);
					$("#sideUrl_"+idx).addClass("edit").prop("readOnly", false);
					$("#sideAuthNmSeq_"+idx).addClass("edit").prop("readOnly", false);
				}else{
					$(target).is(":checked") === true ? obj.sideList[idx].state = "delete" : obj.sideList[idx].state = "select";					
					$("#sideNm_"+idx).removeClass();
					$("#sideNavUrl_"+idx).removeClass();
					$("#sideUrl_"+idx).removeClass();
					$("#sideAuthNmSeq_"+idx).removeClass();					
				}
				break;
			}
		}
		return this;
	},
	
	check : function(){
		let check = {check : true, msg : ""};
		let saveChk = 0;
		
		for(let i=0; i<this.sideList.length; i++){
			
			// 빈값, null 체크
			if(this.sideList[i].sideNm === '' || this.sideList[i].sideNm === null){
				check = {check : false, msg : (i+1) + "행의 사이드URL이름이 입력되지 않았습니다."};
				break;
			}else if(this.sideList[i].sideUrl === '' || this.sideList[i].sideUrl === null){
				check = {check : false, msg : (i+1) + "행의 사이드URL이 입력되지 않았습니다."};
				break;
			}else if(String(this.sideList[i].sideAuthNmSeq) === '' || String(this.sideList[i].sideAuthNmSeq) === null){
				check = {check : false, msg : (i+1) + "행의 사이드URL 권한이 선택되지 않았습니다."};
				break;
			}
			
			if(this.sideList[i].state === "select") saveChk++;
			
		}
		
		if(this.sideList.length === saveChk){
			check = {check : false, msg : "추가, 수정, 삭제할 대상이 없습니다."};
		}
		return check;
	},
	
	save : function(){
		let inList = new Array();
		let upList = new Array();
		let delList = new Array();
		
		for(let i=0; i<this.sideList.length; i++){		
			
			if(this.sideList[i].state === "insert"){
				inList.push(this.sideList[i]);
			}else if(this.sideList[i].state === "update"){
				upList.push(this.sideList[i]);
			}else if(this.sideList[i].state === "delete"){
				delList.push(this.sideList[i]);
			}
		}
		
		if(inList.length === 0 && upList.length === 0 && delList.length === 0){
			alert("추가, 수정, 삭제할 대상이 없습니다.");
			return;
		}
		
		if(!confirm("변경한 사이드URL을 적용하시겠습니까?")){
			return;
		}
		
		$.ajax({		
			type: 'POST',
			url: common.path()+'/admin/ajax/inUpDelSideMenuList.do',
			data: {
				inList : JSON.stringify(inList),
				upList : JSON.stringify(upList),
				delList : JSON.stringify(delList)
			},
			dataType: 'json',
		    success : function(data, stat, xhr) {
		    	alert(data.inCnt+" 개의 메뉴가 입력, "+data.upCnt+" 개의 메뉴가 수정, "+ data.delCnt+" 개의 메뉴가 삭제되었습니다");
		    	white.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
		    },
		    error : function(xhr, stat, err) {
		    	alert("insert, update, delete error");
		    }
		});
	},
	
	equals : function(idx){
		
		if(this.sideList[idx].sideNm !== this.sideClone[idx].sideNm){
			return false;
		}else if(this.sideList[idx].sideUrl !== this.sideClone[idx].sideUrl){
			return false;
		}else if(this.sideList[idx].sideAuthNmSeq !== this.sideClone[idx].sideAuthNmSeq){
			return false;
		}else if(this.sideList[idx].sideShowYn !== this.sideClone[idx].sideShowYn){
			return false;
		}else{
			return true;
		}
	}
}