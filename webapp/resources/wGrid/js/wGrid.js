/**
 * wGrid
 * @author JeHoon 
 */
class wGrid{
	constructor(targetId, args){		
		this.id = targetId;
		this.target = document.getElementById(this.id);
		this.header = args.header;
		this.fields = args.fields;		
		this.dataLink = {};
		
		if(isEmpty(args.data)){
			this.data = null;
		}else{
			for(let i=0; i<args.data.length; i++){
				args.data[i].state = "select";
				args.data[i].isRemove = false;
				args.data[i].key = i;
				this.dataLink[i] = i;
			}
			this.data = args.data;
		}		
		
		//xhr관련 변수
		this.xhr = {
			//비동기 url
			url : args.xhr.url,
			//비동기 여부
			async : this.isEmpty(args.xhr.async) ? true : args.xhr.async,
			//get, post 
			type : this.isEmpty(args.xhr.type) ? "POST" : args.xhr.type.toUpperCase(),
			param : args.xhr.param					
		}
		
		//option
		this.option = {
			//그리드 생성시 자동 조회 여부
			isAuto : this.isEmpty(args.option.isAuto) ? true : args.option.isAuto,
			//내부 비동기 조회 여부
			isXhr : this.isEmpty(args.option.isXhr) ? true : args.option.isXhr,	
			//복제여부
			isClone : this.isEmpty(args.option.isClone) ? true : args.option.isClone,
			//페이징여부
			isPaging : this.isEmpty(args.option.isPaging) ? false : args.option.isPaging,
		}
		
		
		
		this.page = {
			totalCount : 0
		}
		
		//message
		this.message = {
			//조회 데이터 없을시 메시지
			nodata : this.isEmpty(args.message.nodata) ? "no data" : args.message.nodata
		}
		
		this.node = {
			headDiv : null,
			headTable : null,
			bodyDiv : null,
			bodyTable : null
		}
		
		//데이터 복제본 생성
		this.clone = null;
		if(args.option.isClone) this.createClone();
		
		this.controller = args.controller;
		this.controller();
	}
	
	//데이터 넣기
	setData(data){
		this.dataLink = {};
		for(let i=0; i<data.length; i++){
			data[i].state = "select";
			data[i].isRemove = false;
			data[i].key = i;			
			this.dataLink[i] = i;
		}
		this.data = data;
	}
	
	//데이터 가져오기
	getData(){
		return this.data;
	}
	
	
	
	
	
	//행단위 데이터 가져오기
	getRow(){
		
	}
	
	prependRow(row){
		
		//데이터 추가
		row.key = new Date().getTime();
		row.isRemove = false;
		row.state = "insert";		
		this.data.push(row);
		this.dataLink[row.key] = this.data.length-1;		
	
		let newColumn = this.createColumn([row], 0);
		
		//행추가
		this.node.bodyTable.insertBefore(newColumn, this.node.bodyTable.firstChild);		
	}
	
	appendRow(row){
		
	}
	
	//그리드 생성
	createGrid(){
		let list = this.data;
		
		//헤더생성
		let header = document.createElement("div");
		let table = document.createElement("table");
		table.classList.add("wgrid-table-header");
		
		this.node.headDiv = header;
		this.node.headTable = table;
		
		let tr = document.createElement("tr"); 
		let th, td = null;
		
		//header 없을시 fields title로 헤더 생성
		if(this.isEmpty(this.header)){
			for(let i=0; i<this.fields.length; i++){
				th = document.createElement("th"); 
				th.style.width = this.fields[i].width;
				
				if(this.isNotEmpty(this.fields[i].headTemplate)){
					
					let result = this.fields[i].headTemplate(this.fields[i], i, this);
					if(typeof result === "object"){
						if(result.length === 1){							
							th.appendChild(result[0]);
						}else{
							th.appendChild(result);
						}						
					}else{
						th.insertAdjacentHTML("afterbegin", result);
					}
					
				
				}else if(this.fields[i].isHeadAddButton){					
					let button = document.createElement("button");
					button.classList.add("wgrid-btn");
					button.textContent = "+";
					button.addEventListener("click", event => {
						let row = {};
						for(let j=0; j<this.fields.length; j++){
							if(this.isNotEmpty(this.fields[j].name)){
								row[this.fields[j].name] = "";
							}
						}						
						this.prependRow(row);
					});
					th.appendChild(button);					
				}else{
					th.textContent = this.fields[i].title;
				}
				
				tr.appendChild(th);
			}
			table.appendChild(tr);
			header.appendChild(table);
		//header 있을시 생성	
		}else{
			
			//header가 문자열인경우 innerHTML
			if(typeof this.header === "string"){
				header.innerHTML = this.header;				
			}else{
				for(let i=0; i<this.header.length; i++){
					th = document.createElement("th"); 
					th.textContent = this.header[i].title;
					tr.appendChild(th);
				}
				table.appendChild(tr);
				header.appendChild(table);
			}
		}
		//해더 등록
		this.target.appendChild(header);
				
		//자동조회 true
		if(this.option.isAuto){
			
			//생성시 데이터 존재하지 않을 경우
			if(this.isEmpty(this.data)){
				
				//내부 비동기 조회인 경우 xhr : true
				if(this.option.isXhr){
					
					//비동기 통신
					this.xhttp(this.xhr.param, result => {						
						
						//단일 리스드 (list)
						if(typeof result === "object" && typeof result.length === "number"){
							this.dataLink = {};
							for(let i=0; i<result.length; i++){
								result[i].state = "select";
								result[i].isRemove = false;
								result[i].key = i;
								this.dataLink[i] = i;
							}
							this.data = result;
							if(this.option.isClone) this.createClone();
							this.createField();
						
						//복합
						}else if(typeof result === "object" && typeof result.length === "undefined"){							
							let list = null;
							let keys = Object.keys(result);
														
							switch(keys.length){
							//카운트, 리스트(count, list)
							case 2:
								for(let i=0; i<keys.length; i++){									
									if(typeof result[keys[i]] === "number"){
										this.page.totalCount = result[keys[i]];
									}else if(typeof result[keys[i]] === "object" && typeof result[keys[i]].length === "number"){										
										this.dataLink = {};
										list = result[keys[i]];
										for(let j=0; j<list.length; j++){
											list[j].state = "select";
											list[j].isRemove = false;
											list[j].key = j;
											this.dataLink[j] = j;
										}
										this.data = list;
										if(this.option.isClone) this.createClone();
										this.createField();
									}
								}								
								break;
							//카운트, 리스트, 맵(count, list, map)
							case 3:
								break;
							}							
						}
					});
				//비동기 통신이 아니고 데이터가 없는 경우	
				}else{
					this.createNoDataField();
				}
			//생성시 데이터 존재할 경우
			}else{
				this.createField();
			}
		//자동조회 false
		}else{ 
			this.createNoDataField();
		}	
	}
	
	//빈 데이터 field 생성
	createNoDataField(){
		let field = document.createElement("div");
		let table = document.createElement("table");
		table.classList.add("wgrid-table-body");
		
		this.node.bodyDiv = field;
		this.node.bodyTable = table;
		
		let tr = document.createElement("tr"); 
		let td = document.createElement("td");		
		td.textContent = this.message.nodata;
		
		//필드 등록
		tr.appendChild(td);
		table.appendChild(tr);
		field.appendChild(table);		
		this.target.appendChild(field);
	}
	
	//필드 생성
	createField(){
		let list = this.data;
		
		//엘리멘트 생성
		let field = document.createElement("div");
		let table = document.createElement("table");
		table.classList.add("wgrid-table-body");
		
		this.node.bodyDiv = field;
		this.node.bodyTable = table;
		
		let tr = null;
		
		//필드 create
		for(let i=0; i<list.length; i++){
			tr = this.createColumn(list, i);						
			table.appendChild(tr);
		}
		
		//필드 등록
		field.appendChild(table);
		this.target.appendChild(field);		
	}
	
	//필드 컬럼 생성
	createColumn(list, i){
		
		let td, input, select, option = null;
		
		let tr = document.createElement("tr");
		tr.dataset.key = list[i].key;
		
		//신규행 배경색 변경
		if(list[i].state === "insert"){
			tr.classList.add("wgrid-insert-tr");
		}
		
		for(let j=0; j<this.fields.length; j++){
			td = document.createElement("td");
			
			if(this.isNotEmpty(this.fields[j].width)){
				td.style.width = this.fields[j].width;
			}
			
			//사용자정의 템플릿
			if(this.isNotEmpty(this.fields[j].itemTemplate)){
				let result = this.fields[j].itemTemplate(list[i][this.fields[j].name], tr.dataset.key, this);
				if(typeof result === "object"){
					if(result.length === 1){
						//jquery $("<tag>")로 올 경우
						td.appendChild(result[0]);
					}else{
						td.appendChild(result);
					}						
				}else{
					td.insertAdjacentHTML("afterbegin", result);
				}
			//행 삭제버튼 추가 
			}else if(this.fields[j].isRemoveButton){					
				let button = document.createElement("button");
				button.classList.add("wgrid-btn");
				button.textContent = "-";
				button.addEventListener("click", event => {
					
					//신규행은 바로 삭제
					if(list[i].state === "insert"){
						//데이터 삭제 (index 유지)
						delete this.data[this.dataLink[this.getTrNode(event.target).dataset.key]];
						//태그 삭제
						this.getTrNode(event.target).remove();
				    //그외 삭제 background 적용
					}else{
						let node = this.getTrNode(event.target);
						
						let idx = this.dataLink[node.dataset.key];
						this.data[idx].isRemove = !this.data[idx].isRemove;
						//변경사항 style 적용
						this.applyStyle(!this.data[idx].isRemove, "delete", node);						
					}
				});
				td.appendChild(button);					
			//타입별 정의 (text, input, select)
			}else{
				
				switch(this.fields[j].type){
				default :
				case "text" :						
					td.textContent = list[i][this.fields[j].name];
					break;
				case "input" :
					
					//input박스 생성
					input = document.createElement("input");
					input.value = list[i][this.fields[j].name];						
					input.classList.add("wgrid-input");
					
					//신규행 배경색 변경
					if(list[i].state === "insert"){
						input.classList.add("wgrid-insert-tag");
					//신규는 이벤트 필요없음
					}else{
						//값 동기화 이벤트 등록 
						input.addEventListener("keyup", event => {
							list[i][this.fields[j].name] = event.target.value;							
							if(this.option.isClone){								
								let node = this.getTrNode(event.target);
								//변경사항 style 적용
								this.applyStyle(this.checkRow(list[i].key), "update", node);								
							}
							
						}, false);
					}					
					td.appendChild(input);
					break;
				case "select" :
					
					break;
				}
			}
			tr.appendChild(td);				
		}
		return tr;
	}

	getTrNode(node){
		while(true){
			if(node.tagName === "TR"){											
				break;						
			}else if(node.tagName === "TABLE" || node.tagName === "BODY" || node.tagName === "HTML"){
				return false;						
			}else{
				node = node.parentNode;
			}
		}
		return node;
	}
	
	//원본 행과 비교
	checkRow(key){
		if(this.option.isClone){
			
			let idx = this.dataLink[key];
			
			if(this.data[idx].state === "insert"){
				return true;
			}else{				
				let isEqual = true; 
				
				let keys = Object.keys(this.data[idx]);				
				for(let i=0; i<keys.length; i++){
					if(this.data[idx][keys[i]] !== this.clone[idx][keys[i]]){
						isEqual = false;
						break;
					}
				}		
				return isEqual;				
			}			
		}else{
			return true;
		}
	}
	
	//행삭제
	removeRow(key){
		
	}
	
	//스타일 적용, 취소
	applyStyle(isApply, state, tr){
		state = state.toLowerCase();
		if(isApply){				
			//class 해제 로직
			tr.classList.remove("wgrid-" + state + "-tr");											
			let trList = tr.childNodes;
			trList.forEach(element => {
				let tagName = element.childNodes[0].tagName;
				if(tagName === "INPUT" || tagName === "SELECT"){
					element.childNodes[0].classList.remove("wgrid-" + state +"-tag");
				}
			});											
		}else{				
			//class 적용 로직
			tr.classList.add("wgrid-" + state + "-tr");											
			let trList = tr.childNodes;
			trList.forEach(element => {
				let tagName = element.childNodes[0].tagName;
				if(tagName === "INPUT" || tagName === "SELECT"){
					element.childNodes[0].classList.add("wgrid-" + state +"-tag");
				}												
			});	
		}
	}	
		
	//빈값 체크
	isEmpty(_str){
		return !this.isNotEmpty(_str);
	}
	//!빈값 체크
	isNotEmpty(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	}
	//복제본 생성
	createClone(){
		if(this.isEmpty(this.data)) return;
		
		function deepObjCopy(dupeObj){
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
		}		
		this.clone = deepObjCopy(this.data);
	}
	//비동기 통신
	xhttp(sParam, callback){
		
		//XMLHttpRequest 선언
		let xhr = new XMLHttpRequest();
		
		//url값
	    let offset = location.href.indexOf(location.host)+location.host.length;
	    let url = location.href.substring(offset,location.href.indexOf('/',offset+1)) + this.xhr.url;
	    
	    //XMLHttpRequest open
		xhr.open(this.xhr.type, url, this.xhr.async);	
		
		//readyState 호출함수 정의
		xhr.onreadystatechange = () => {
			if (xhr.readyState == 4) {
				if (xhr.status == 200) {					
					if(xhr.responseText !== null && xhr.responseText !== undefined && xhr.responseText !== ""){					
						callback(JSON.parse(xhr.responseText));
					}					
				}else{
					console.log("xhr.status:"+xhr.status);
				}
			}		
		}
		
		//전송할 데이터 가공
		if(sParam === null || sParam === undefined || this.data === ""){
			xhr.send();	
		}else{
			let formData = new FormData();			
			let keys = Object.keys(sParam);			
			for(let i=0; i<keys.length; i++){				
				formData.append(keys[i], String(sParam[keys[i]]));
			}			
			xhr.send(formData);	
		}
	}
}