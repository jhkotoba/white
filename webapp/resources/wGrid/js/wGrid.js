/**
 * wGrid 0.0.1
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
				args.data[i]._state = "select";
				args.data[i]._isRemove = false;
				args.data[i]._key = i;
				this.dataLink[i] = i;
			}
			this.data = args.data;
		}		
		
		//item
		this.items = {
			select : {}
		};
		if(this.isNotEmpty(args.items)){
			if(this.isNotEmpty(args.items.select)){
				args.items.select.forEach(item => {					
					this.items.select[item.name] = item;
				});
			}
		}
		
		//option
		if(this.isEmpty(args.option)){
			args.option = {
				//bool 값
				isAutoSearch : false,
				isClone : false,
				isPaging : false,
				isScrollY : false,			
				isScrollX : false,
				
				
				//수치 값
				bodyHeight : ""
			}
		}
		this.option = {
			//자동조회 여부
			isAutoSearch : this.isEmpty(args.option.isAutoSearch) ? false : args.option.isAutoSearch,
			//복제여부
			isClone : this.isEmpty(args.option.isClone) ? false : args.option.isClone,
			//페이징여부
			isPaging : this.isEmpty(args.option.isPaging) ? false : args.option.isPaging,
			//스크롤 Y(위 아래)
			isScrollY : this.isEmpty(args.option.isScrollY) ? false : args.option.isScrollY,
			//스크롤 X(왼쪽 오른쪽)
			isScrollX : this.isEmpty(args.option.isScrollX) ? false : args.option.isScrollX,		
			//body 높이
			bodyHeight : this.isEmpty(args.option.bodyHeight) ? "" : args.option.bodyHeight,
		
					
					
		}

		//paging
		this.page = {
				
		}
		
		//message
		if(this.isEmpty(args.message)){
			args.message = {
				nodata : "no data"
			}
		}
		this.message = {
			nodata : args.message.nodata
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
		if(this.option.isAutoSearch){
			this.search();
		}
	}
	
	//조회
	search(){
		this.controller.load().then(result => {
			this._dataInjection(result);
			while(this.target.hasChildNodes()){
				this.target.removeChild( this.target.firstChild ); 
			}
			
			//생성전 콜백함수
			if(this.isNotEmpty(this.controller.beforeCreate)){
				this.controller.dataConverter(this.data);
				this.controller.beforeCreate(this.deepCopy(this.data));
			}
			
			this.createGrid();
			
			//생성후 콜백함수
			if(this.isNotEmpty(this.controller.afterCreate)){
				this.controller.afterCreate(this.deepCopy(this.data));
			}
		});
	}
	
	//데이터 가공 및 주입
	_dataInjection(result){		
		//단일 리스드 (list)
		if(typeof result === "object" && typeof result.length === "number"){			
			
			//데이터 넣기
			this.setData(result);
			
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
						
						list = result[keys[i]];						
						//데이터 넣기
						this.setData(list);
						
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
	
	setRowData(key, data){
		
	}
	
	//데이터 삽입 cell
	setCellData(key, columnName, data){
		if(this.isNotEmpty(this.dataLink[key])){
			if(this.isNotEmpty(this.data[this.dataLink[key]][columnName])){
				this.data[this.dataLink[key]][columnName] = data;
			}
		}
	}
	
	//데이터 넣기
	setData(data){
		this.dataLink = {};
		for(let i=0; i<data.length; i++){
			data[i]._state = "select";
			data[i]._isRemove = false;
			data[i]._key = i;			
			this.dataLink[i] = i;
			
			//조회시 fields없는값 ""값으로 설정
			for(let j=0; j<this.fields.length; j++){
				if(this.isNotEmpty(this.fields[j].name) && this.isEmpty(data[i][this.fields[j].name])){
					data[i][this.fields[j].name] = "";
				}
			}
		}
		this.data = data;
	}
	
	//데이터 가져오기
	getData(key){
		if(this.isEmpty(key)){
			return this.deepCopy(this.data);
		}else{
			return this.deepCopy(this.data[this.dataLink[key]]);
		}		
	}
		
	//새로 추가된 행 가져오기
	getNewData(){
		return this.deepCopy(this.data.filter(item => {
			return item._state === "insert";
		}));		
	}
	
	//기존데이터 수정된 행 가져오기
	getModifyData(){
		return this.deepCopy(this.data.filter(item => {
			return item._state === "update";
		}));
	}
	
	//기존데이터 삭제할 행 가져오기
	getRemoveData(){
		return this.deepCopy(this.data.filter(item => {
			return item._isRemove === true;
		}));
	}
	
	//신규, 수정된, 삭제할 행 가져오기 
	getApplyData(){
		return this.deepCopy(this.data.filter(item => {
			return item._isRemove === true || item._state === "insert" || item._state === "update";
		})).map(item => {
			if(item._isRemove){
				item._state = "delete";
				return item;
			}else{
				return item;
			}
		});
	}
	
	//최초 조회시 값 가져오기
	getOriginalData(){
		return this.deepCopy(this.clone);
	}
	
	//오리지널 복사값으로 초기화
	originalToReset(isBefore, isAfter){	
		this._bodyRemove();
		this.data = this.deepCopy(this.clone);
		
		if(this.isEmpty(isBefore)){
			isBefore = false;
		}
		if(this.isEmpty(isAfter)){
			isAfter = false;
		}
		
		//생성전 콜백함수
		if(isBefore && this.isNotEmpty(this.controller.beforeCreate)){
			this.controller.dataConverter(this.data);
			this.controller.beforeCreate(this.deepCopy(this.data));
		}
		
		this.createField();
		
		//생성후 콜백함수
		if(isAfter && this.isNotEmpty(this.controller.afterCreate)){
			this.controller.afterCreate(this.deepCopy(this.data));
		}
	}
	
	//빈값으로 초기화
	reset(){		
		this._bodyRemove();
		this.createNoDataField();
	}
	
	//key와 컬럼명으로 Element 찾기
	_getColumnElement(key, columnName){
		let dataKey, element, columnElement = null;
		
		for(let i=0; i<this.node.bodyTable.childElementCount; i++){
			element = this.node.bodyTable.childNodes[i];
			dataKey = element.getAttribute("data-key");
			
			if(key == dataKey){	
				for(let j=0; j<element.childElementCount; j++){
					columnElement = element.childNodes[j];
					if(columnName == columnElement.getAttribute("data-column-name")){
						return columnElement;
					}
				}			
			}
		}
	}	
	
	//input태그 툴팁메세지 띄우기
	inputMessage(key, columnName, message, offset, zIndex){
		
		let element = this._getColumnElement(key, columnName).querySelector(".wgrid-input");
		if(element != null){
			
			let div = document.createElement("div");
			
			element.classList.add("wgrid-tooltip-input-border");
			element.focus();
			
			div.classList.add("wgrid-tooltip");
			div.textContent = message;
			document.body.appendChild(div);
			
			let top = window.pageYOffset + element.getBoundingClientRect().top;
			let left = window.pageYOffset + element.getBoundingClientRect().left;
			div.style.top = top-42;		
			div.style.left = left;	
			
			element.addEventListener("focusout", function(event){			
				element.classList.remove("wgrid-tooltip-input-border");
				element.removeEventListener("focusout", this, false);
				div.remove();			
			}, false);
		}	
	}

	
	//필드값 삭제
	_bodyRemove(){
		this.node.bodyTable = null;
		this.node.bodyDiv.remove();
		this.node.bodyDiv = null;
	}
	
	prependRow(row){
		
		//데이터 추가
		row._key = new Date().getTime();
		row._isRemove = false;
		row._state = "insert";		
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
		let th, td, div = null;
		
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
		
		//option - 스크롤 Y 설정
		if(this.option.isScrollY){
			field.classList.add("wgrid-overflow-y");
			field.style.height = this.option.bodyHeight;
		}
		
		this.target.appendChild(field);
	}
	
	//필드 컬럼 생성
	createColumn(list, i){		
		
		let td, input, select, option, div = null;
		
		let tr = document.createElement("tr");
		tr.dataset.key = list[i]._key;
		
		//신규행 배경색 변경
		if(list[i]._state === "insert"){
			tr.classList.add("wgrid-insert-tr");
		}
		
		for(let j=0; j<this.fields.length; j++){
			td = document.createElement("td");
			
			//data속성
			if(this.isNotEmpty(this.fields[j].name)){
				td.dataset.columnName = this.fields[j].name;
			}
			
			//넓이 설정
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
					let result = this.fields[j].itemTemplate(list[i][this.fields[j].name], this.deepCopy(this.data[this.dataLink[tr.dataset.key]]), tr.dataset.key);
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
					if(list[i]._state === "insert"){						
						let node = this._getTrNode(event.target);
						//데이터 삭제 (index 유지)
						delete this.data[this.dataLink[node.dataset.key]];
						//태그 삭제
						node.remove();
				    //그외 삭제 background 적용
					}else{
						
						let node = this._getTrNode(event.target);
						let idx = this.dataLink[node.dataset.key];
						this.data[idx]._isRemove = !this.data[idx]._isRemove;
						
						//변경사항 style 적용						
						this._applyStyle(!this.data[idx]._isRemove, "delete", node);						
						this._applyStyle(this._checkRow(list[i]._key), "update", node);
					}
				});
				td.appendChild(button);
			//yn 버튼 
			}else if(this.fields[j].isUseYnButton){
				let button = document.createElement("button");
				button.classList.add("wgrid-btn");
				
				if(list[i]._state === "insert"){
					button.textContent = "Y";
					list[i][this.fields[j].name] = "Y";
				}else{
					button.textContent = list[i][this.fields[j].name];
				}
				
				button.addEventListener("click", event => {
					if("Y" === list[i][this.fields[j].name]){
						list[i][this.fields[j].name] = "N";
					}else{
						list[i][this.fields[j].name] = "Y";
					}
					button.textContent = list[i][this.fields[j].name];
					
					//변경사항 style 적용 (insert 제외)
					if(list[i]._state !== "insert"){
						this._applyStyle(this._checkRow(list[i]._key), "update", this._getTrNode(event.target));
					}
					
				});
				td.appendChild(button);
			//타입별 정의 (text, input, select)
			}else{
				
				switch(this.fields[j].tag){
				default :
				case "text" :						
					td.textContent = list[i][this.fields[j].name];
					
					//align 설정
					if(this.isNotEmpty(this.fields[j].align)){
						td.style.textAlign = this.fields[j].align;
					}
					break;
				case "input" :
					
					//input박스 생성
					input = document.createElement("input");
					input.value = list[i][this.fields[j].name];
					input.classList.add("wgrid-input");
					
					//align 설정
					if(this.isNotEmpty(this.fields[j].align)){
						input.style.textAlign = this.fields[j].align;
					}
					
					//신규행 배경색 변경
					if(list[i]._state === "insert"){
						input.classList.add("wgrid-insert-tag");
						
						//값 동기화 이벤트 등록 
						input.addEventListener("keyup", event => {
							list[i][this.fields[j].name] = event.target.value;
						}, false);						
						
					//신규가 아닌 행
					}else{
						
						//값 동기화 이벤트 등록 
						input.addEventListener("keyup", event => {
							list[i][this.fields[j].name] = event.target.value;							
							if(this.option.isClone){																
								//변경사항 style 적용								
								this._applyStyle(this._checkRow(list[i]._key), "update", this._getTrNode(event.target));								
							}
							if(this._checkRow(list[i]._key)){
								list[i]._state = "select";
							}else{
								list[i]._state = "update";
							}
						}, false);
						
					}					
					td.appendChild(input);
					break;
				case "select" :
					
					//select박스 생성
					select = document.createElement("select");					
					select.classList.add("wgrid-select");
					
					let seItem = this.items.select[this.fields[j].name];
					
					//셀렉트박스 option 등록
					seItem.opList.forEach(opItem => {						
						option = document.createElement("option");
						option.value = opItem[seItem.value];
						
						//selected 설정
						if(option.value == list[i][seItem.value]){
							option.selected = true;
						}						
					
						//text[]일 경우 구분자(seItem.textJoin) 구분하여 합침
						if(typeof seItem.text === "object" && typeof seItem.text.length === "number"){							
							let txt = "";
							let join = this.isEmpty(seItem.textJoin) ? " " : seItem.textJoin;
							
							seItem.text.forEach(txList => {							
								if(this.isNotEmpty(opItem[txList])){
									txt += opItem[txList] + join;
								}
							});
							option.textContent = txt;
							txt = "";
						//Text인 경우
						}else{
							option.textContent = opItem[seItem.text];
						}
						
						//data-value 설정
						if(this.isNotEmpty(seItem.dataValue)){							
							//여러개일 경우
							if(typeof seItem.dataValue === "object" && typeof seItem.dataValue.length === "number"){														
								seItem.dataValue.forEach(daVal => {						
									option.dataset[daVal] = opItem[daVal];
								});								
							//한개인 경우
							}else{
								option.dataset[seItem.dataValue] = opItem[seItem.dataValue]; 
							}
						}
						select.appendChild(option);
					});					
					
					//값 동기화 이벤트 등록 
					select.addEventListener("change", event => {
						list[i][seItem.name] = event.target.value;
						if(this.option.isClone){																
							//변경사항 style 적용								
							this._applyStyle(this._checkRow(list[i]._key), "update", this._getTrNode(event.target));								
						}
						if(this._checkRow(list[i]._key)){
							list[i]._state = "select";
						}else{
							list[i]._state = "update";
						}
					}, false);
					
					td.appendChild(select);
					break;
				}
			}
			
			tr.appendChild(td);				
		}	
		return tr;
	}

	_getTrNode(node){
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
	_checkRow(key){		
		if(this.option.isClone){
			let idx = this.dataLink[key];			
			if(this.data[idx]._state === "insert"){
				return true;
			}else{				
				let isEqual = true; 
				
				let keys = Object.keys(this.data[idx]);				
				for(let i=0; i<keys.length; i++){					
					
					if(keys[i].substring(0,1) === "_"){
						continue;
					}else if(this.data[idx][keys[i]] != this.clone[idx][keys[i]]){
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
	
	//key값으로 applyStyle적용
	applySync(key){
		let node = null;
		let item = this.data[this.dataLink[key]];
		console.log(item);
		Array.from(this.node.bodyTable.childNodes).some(item => {
			if(item.dataset.key == key){
				node = item;
				return true;
			}else{
				return false;
			}
		});
		console.log(node);
		this._applyStyle(!item.isRemove, "delete", node);						
		this._applyStyle(this._checkRow(key), "update", node);
	}
	
	//스타일 적용, 취소
	_applyStyle(isApply, _state, tr){
		console.log("isApply:"+isApply);
		console.log("_state:"+_state);
		console.log(tr);
		_state = _state.toLowerCase();
		if(isApply){
			//class 해제 로직
			tr.classList.remove("wgrid-" + _state + "-tr");											
			let trList = tr.childNodes;
			trList.forEach(element => {
				if(element.childNodes.length > 0){
					let tagName = element.childNodes[0].tagName;
					if(tagName === "INPUT" || tagName === "SELECT"){
						element.childNodes[0].classList.remove("wgrid-" + _state +"-tag");
					}
				}
			});											
		}else{				
			//class 적용 로직
			tr.classList.add("wgrid-" + _state + "-tr");											
			let trList = tr.childNodes;			
			trList.forEach(element => {
				if(element.childNodes.length > 0){
					let tagName = element.childNodes[0].tagName;
					if(tagName === "INPUT" || tagName === "SELECT"){
						element.childNodes[0].classList.add("wgrid-" + _state +"-tag");
					}
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
		this.clone = this.deepCopy(this.data);
	}
	
	//깊은복사
	deepCopy(data){
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
		return deepObjCopy(data);
	}
}