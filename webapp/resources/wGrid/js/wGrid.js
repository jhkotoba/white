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
				args.data[i]._key = i;
				this.dataLink[i] = i;
			}
			this.data = args.data;
		}
		
		//option
		this.option = {
			isAuto : this.isEmpty(args.option.isAuto) ? false : args.option.isAuto,
			//복제여부
			isClone : this.isEmpty(args.option.isClone) ? true : args.option.isClone,
			//페이징여부
			isPaging : this.isEmpty(args.option.isPaging) ? false : args.option.isPaging,
		}

		//paging
		this.page = {
				
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
		if(this.option.isAuto){
			this.search();
		}
	}
	
	//조회
	search(){
		this.controller.load().then(result => {			
			this.dataInjection(result);
			this.target
			while(this.target.hasChildNodes()){
				this.target.removeChild( this.target.firstChild ); 
			}
			
			//생성전 콜백함수
			if(this.isNotEmpty(this.controller.createStart)){
				this.controller.createStart(this.data);
			}
			
			this.createGrid();
			
			//생성후 콜백함수
			if(this.isNotEmpty(this.controller.createEnd)){
				this.controller.createEnd(this.data);
			}
			
		});
	}
	
	//데이터 가공 및 주입
	dataInjection(result){		
		//단일 리스드 (list)
		if(typeof result === "object" && typeof result.length === "number"){
			this.dataLink = {};
			for(let i=0; i<result.length; i++){
				result[i].state = "select";
				result[i].isRemove = false;
				result[i]._key = i;
				this.dataLink[i] = i;
			}
			this.data = result;
			if(this.option.isClone) this.createClone();
		//복합
		}else if(typeof result === "object" && typeof result.length === "undefined"){							
			let list = null;
			let keys = Object.keys(result);
										
			switch(keys.length){
			//카운트, 리스트(count, list)
			case 2:
				for(let i=0; i<keys.length; i++){									
					if(typeof result[keys[i]] === "number"){
						//this.page.totalCount = result[keys[i]];
					}else if(typeof result[keys[i]] === "object" && typeof result[keys[i]].length === "number"){										
						this.dataLink = {};
						list = result[keys[i]];
						for(let j=0; j<list.length; j++){
							list[j].state = "select";
							list[j].isRemove = false;
							list[j]._key = j;
							this.dataLink[j] = j;
						}
						this.data = list;
						if(this.option.isClone) this.createClone();
					}
				}								
				break;
			//카운트, 리스트, 맵(count, list, map)
			case 3:
				break;
			}							
		}
	}
	
	//데이터 넣기
	setData(data){
		this.dataLink = {};
		for(let i=0; i<data.length; i++){
			data[i].state = "select";
			data[i].isRemove = false;
			data[i]._key = i;			
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
		row._key = new Date().getTime();
		row.isRemove = false;
		row.state = "insert";		
		this.data.push(row);
		this.dataLink[row._key] = this.data.length-1;		
	
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
				//헤드부분 추가 버튼
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
				//헤드부분 셀렉트박스(선택에 따라서 필드(행)값 변경)
				}else if(this.fields[i].isHeadSelect){
					let select = document.createElement("select");
					select.classList.add("wgrid-haed-select");
					
					let option = null;					
					for(let j=0; j<this.fields[i].headSelectList.length; j++){
						option = document.createElement("option");					
						option.value = this.fields[i].headSelectList[j].value;
						option.textContent = this.fields[i].headSelectList[j].text;
						select.appendChild(option);	
					}
					
					let previous = null;
					select.addEventListener("focus", event => {					
						previous = event.target.value;
					});
					select.addEventListener("change", event => {
						let names, prevs = null;						
						prevs = document.getElementsByName(previous);						
						names = document.getElementsByName(event.target.value);
						previous = event.target.value;
						for(let j=0; j<names.length; j++){
							prevs[j].style.display = "none";
							names[j].style.display = "block";
						}
					});
					th.appendChild(select);									
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
		
		//생성시 데이터 존재하지 않을 경우
		if(this.isEmpty(this.data)){
			this.createNoDataField();
		//생성시 데이터 존재할 경우
		}else{
			this.createField();
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
		tr.dataset.key = list[i]._key;
		
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
				if(this.fields[j].isHeadSelect){				
					let div = null;
					for(let k=0; k<this.fields[j].headSelectList.length; k++){
						div = document.createElement("div");
						if(k !== 0)	div.style.display = "none";					
						div.setAttribute("name", this.fields[j].headSelectList[k].value);						
						let result = this.fields[j].itemTemplate(list[i][this.fields[j].headSelectList[k].value], this.data[this.dataLink[tr.dataset.key]], tr.dataset.key);
						if(typeof result === "object"){
							if(result.length === 1){
								//jquery $("<tag>")로 올 경우
								div.appendChild(result[0]);
							}else{
								div.appendChild(result);
							}						
						}else{
							div.insertAdjacentHTML("afterbegin", result);
						}				
						td.appendChild(div);										
					}
				}else{
					
					//순수 사용자정의 템플릿 로직
					let result = this.fields[j].itemTemplate(list[i][this.fields[j].name], this.data[this.dataLink[tr.dataset.key]], tr.dataset.key);
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
				}
			//헤더 셀렉트 필드값 적용
			}else if(this.fields[j].isHeadSelect){
				let div = null;
				for(let k=0; k<this.fields[j].headSelectList.length; k++){
					div = document.createElement("div");
					if(k !== 0)	div.style.display = "none";					
					div.setAttribute("name", this.fields[j].headSelectList[k].value);					
					div.textContent = list[i][this.fields[j].headSelectList[k].value];				
					td.appendChild(div);										
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
}