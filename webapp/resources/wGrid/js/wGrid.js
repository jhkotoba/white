/**
 * wGrid 0.0.2
 * @author JeHoon 
 */
class wGrid{
	constructor(targetId, args){
		
		this.id = targetId;
		this.target = document.getElementById(this.id);
		this.header = args.header;
		this.fields = args.fields;		
		this._dataLink = {};	
		
		//item
		this.items = {
			select : {}
		};
		if(this._isNotEmpty(args.items)){
			if(this._isNotEmpty(args.items.select)){
				args.items.select.forEach(item => {					
					this.items.select[item.name] = item;
				});
			}
		}
		
		//option
		if(this._isEmpty(args.option)){
			args.option = {
				//bool 값
				isEmptyFirstData : false,
				isSync : true,
				isAutoSearch : false,				
				isPaging : false,
				isScrollY : false,			
				isScrollX : false,
				
				
				//수치 값
				bodyHeight : ""
			}
		}	
		
		this.option = {
			//첫행 빈값행 생성 여부
			isEmptyFirstData : this._isEmpty(args.option.isEmptyFirstData) ? false : args.option.isEmptyFirstData,
			//변경사항 체크 여부
			isSync : this._isEmpty(args.option.isSync) ? true : args.option.isSync,
			//자동조회 여부
			isAutoSearch : this._isEmpty(args.option.isAutoSearch) ? false : args.option.isAutoSearch,			
			//페이징여부
			isPaging : this._isEmpty(args.option.isPaging) ? false : args.option.isPaging,
			//스크롤 Y(위 아래)
			isScrollY : this._isEmpty(args.option.isScrollY) ? false : args.option.isScrollY,
			//스크롤 X(왼쪽 오른쪽)
			isScrollX : this._isEmpty(args.option.isScrollX) ? false : args.option.isScrollX,		
			//body 높이
			bodyHeight : this._isEmpty(args.option.bodyHeight) ? "" : args.option.bodyHeight,					
		}

		//paging
		this.page = {
				
		}
		
		//message
		if(this._isEmpty(args.message)){
			args.message = {
				nodata : "no data"
			}
		}
		this.message = {
			nodata : args.message.nodata
		}
		
		this.node = {
			//헤더 제목 영역 DIV 태크
			headDiv : null,
			//헤더 제목 영역의 하위영역 TABLE 태그
			headTable : null,
			//헤더 제목 영역 행추가버튼 BUTTON 태그
			headAddButton : null,
			//필드 목록리스트 영역 DIV 태그
			bodyDiv : null,
			//필드 영역의 하위영역 TABLE 태그
			bodyTable : null,
			//필드 영역의 하위영역 데이터 없을시 나타내는 영역 DIV 태그
			bodyNoDataField : null,
			
		}
		
		//컨트롤로 저장
		this.controller = args.controller;			
		this._clone = null;
		
		this._createEvent();		
				
		//빈값일 경우
		if(this._isEmpty(args.data)){
			this._data = null;
			this._dataType = null;
			
			this.createGrid();			
		}else{			
			//사용자임의 데이터 가공 및 주입
			if(this._isNotEmpty(this.controller.dataConverter)){
				args.data = this.controller.dataConverter(this.deepCopy(args.data));
			}						
			this.setData(args.data);
			this.createGrid();
		}
		
		//조회 호출
		if(this.option.isAutoSearch && this._isNotEmpty(this.controller.load)){
			this.search();
		}
		
		//그리드 생성후 최초 1회 콜백함수		
		this.afterInit = args.afterInit;		
		if(this._isNotEmpty(this.afterInit)){
			this.afterInit();
		}
	}
	
	//조회
	search(){
		this.controller.load().then(result => {	
			
			//초기 데이터 가공 및 주입
			let res = this._dataInjection(result);
			let data = res.data;			
			//this.dataCount = res.count;
			
			//사용자임의 데이터 가공 및 주입
			if(this._isNotEmpty(this.controller.dataConverter)){
				data = this.controller.dataConverter(this.deepCopy(data));
			}
			
			//데이터 그리드변수에 적용
			this.setData(data);
			
			//데이터 클론 생성
			this._createClone();
			
			//기존 그리드 존재시 삭제
			while(this.target.hasChildNodes()){
				this.target.removeChild(this.target.firstChild); 
			}			
			
			//그리드 생성전 콜백함수
			if(this._isNotEmpty(this.controller.beforeCreate)){				
				this.controller.beforeCreate(this.deepCopy(this._data));
			}
			
			//그리드 생성
			this.createGrid();
			
			//그리드 생성후 콜백함수
			if(this._isNotEmpty(this.controller.afterCreate)){
				this.controller.afterCreate(this.deepCopy(this._data));
			}
		});
	}
	
	setRowData(key, data){
		
	}
	
	//데이터 삽입 cell
	setCellData(key, columnName, data){
		if(this._isNotEmpty(this._dataLink[key])){
			if(this._isNotEmpty(this._data[this._dataLink[key]][columnName])){
				this._data[this._dataLink[key]][columnName] = data;
			}
		}
	}
	
	//데이터 넣기
	setData(data){
		this._dataLink = {};
		this._dataType = {};
		for(let i=0; i<data.length; i++){
			data[i]._state = "select";
			data[i]._isRemove = false;
			data[i]._key = i;			
			data[i]._type = [];			
			this._dataLink[i] = i;			
			
			for(let j=0; j<this.fields.length; j++){
				
				//type 리스트에 주입
				if(this._isEmpty(this.fields[j].name)){
					continue;
				}else if(this._isEmpty(this.fields[j].type)){
					this._dataType[this.fields[j].name] = "text";					
				}else{
					this._dataType[this.fields[j].name] = this.fields[j].type;					
					
					//타입별 데이터 가공
					switch(this.fields[j].type){					
					case "currency" :						
						data[i][this.fields[j].name] = this._setComma(data[i][this.fields[j].name]);						
						break;
					}					
				}
				//조회시 fields없는값 ""값으로 설정
				if(this._isNotEmpty(this.fields[j].name) && this._isEmpty(data[i][this.fields[j].name])){
					data[i][this.fields[j].name] = "";
				}
			}
		}
		this._data = data;
	}
	
	//데이터 가져오기
	getData(key){
		if(this._isEmpty(key)){
			return this._outputDataProcess(this._data);
		}else{
			return this._outputDataProcess(this._data[this._dataLink[key]]);
		}		
	}
		
	//새로 추가된 행 가져오기
	getNewData(){
		return this._outputDataProcess(this._data.filter(item => {
			return item._state === "insert";
		}));		
	}
	
	//기존데이터 수정된 행 가져오기
	getModifyData(){
		return this._outputDataProcess(this._data.filter(item => {
			return item._state === "update";
		}));
	}
	
	//기존데이터 삭제할 행 가져오기
	getRemoveData(){
		return this._outputDataProcess(this._data.filter(item => {
			return item._isRemove === true;
		}));
	}
	
	//신규, 수정된, 삭제할 행 가져오기 
	getApplyData(){
		return this._outputDataProcess(this._data.filter(item => {
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
		return this._outputDataProcess(this._clone);
	}
	
	//오리지널 복사값으로 초기화
	originalToReset(isBefore, isAfter){	
		this._bodyRemove();
		this.setData(this.deepCopy(this._clone));		
		
		if(this._isEmpty(isBefore)){
			isBefore = false;
		}
		if(this._isEmpty(isAfter)){
			isAfter = false;
		}
		
		//생성전 콜백함수
		if(isBefore && this._isNotEmpty(this.controller.beforeCreate)){
			this.controller.dataConverter(this._data);
			this.controller.beforeCreate(this.deepCopy(this._data));
		}
		
		this._createField();
		this._createNoDataField();
		
		//생성후 콜백함수
		if(isAfter && this._isNotEmpty(this.controller.afterCreate)){
			this.controller.afterCreate(this.deepCopy(this._data));
		}
	}
	
	//빈값으로 초기화
	reset(){		
		this._bodyRemove();
		this._createField();
		this._createNoDataField();
		this._noDataField();		
	}	
	
	//key값으로 applyStyle적용
	applySync(key){
		let node = null;
		let item = this._data[this._dataLink[key]];		
		Array.from(this.node.bodyTable.childNodes).some(item => {
			if(item.dataset.key == key){
				node = item;
				return true;
			}else{
				return false;
			}
		});		
		this._applyStyle(!item.isRemove, "delete", node);						
		this._applyStyle(this._checkRow(key), "update", node);
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
	
	//행추카(위)
	prependRow(row){
		
		//데이터 추가
		row._key = new Date().getTime();
		row._isRemove = false;
		row._state = "insert";
		
		if(this._data == null){
			this._data = [];		
		}
		this._data.push(row);
		this._dataLink[row._key] = this._data.length-1;		
	
		let newColumn = this._createColumn([row], 0);
		
		//행추가
		this.node.bodyTable.insertBefore(newColumn, this.node.bodyTable.firstChild);		
		this._noDataField();
	}
	
	//행추카(아래)
	appendRow(row){
		
	}
	
	//행삭제
	removeRow(key){
		
	}
	
	//그리드 생성
	createGrid(){		
		let list = this._data;
		
		//헤더생성
		let header = document.createElement("div");
		let table = document.createElement("table");
		table.classList.add("wgrid-table-header");
		
		this.node.headDiv = header;
		this.node.headTable = table;
		
		let tr = document.createElement("tr"); 
		let th, td, div = null;
		
		//header 없을시 fields title로 헤더 생성
		if(this._isEmpty(this.header)){
			for(let i=0; i<this.fields.length; i++){
				th = document.createElement("th"); 
				th.style.width = this.fields[i].width;
				
				if(this._isNotEmpty(this.fields[i].headTemplate)){
					
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
							if(this._isNotEmpty(this.fields[j].name)){
								row[this.fields[j].name] = "";
							}
						}
						this.prependRow(row);
					});
					th.appendChild(button);
					
					//추가버튼 타켓 저장
					this.node.headAddButtonElement = button;
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
				
		this._createField();
		this._createNoDataField();		
		this._noDataField();
	}
	
	//빈 데이터 field 생성
	_createNoDataField(){
		let field = document.createElement("div");
		field.style.display = "none";
		
		let table = document.createElement("table");
		table.classList.add("wgrid-table-body");
		
		this.node.bodyNoDataField = field;
		
		let tr = document.createElement("tr");
		let td = document.createElement("td");
		td.textContent = this.message.nodata;
		
		//필드 등록
		tr.appendChild(td);
		table.appendChild(tr);
		field.appendChild(table);
		this.target.appendChild(field);		
	}
	
	_noDataField(){
		//data여부 따라서 화면표시, 미표시
		
		
		
		if(this._data == null){
			this.node.bodyNoDataField.style.display = "block";
		}else{
			let isEmpty = true;			
			for(let i=0; i<this._data.length; i++){
				if(this._isNotEmpty(this._data[i])){
					isEmpty = false;
					break;
				}
			}
			if(isEmpty){
				this.node.bodyNoDataField.style.display = "block";
			}else{
				this.node.bodyNoDataField.style.display = "none";
			}
		}
	}	
	
	//필드 생성
	_createField(){	
		
		//엘리멘트 생성
		let field = document.createElement("div");
		let table = document.createElement("table");
		table.classList.add("wgrid-table-body");
		
		this.node.bodyDiv = field;
		this.node.bodyTable = table;
		
		//필드 등록
		field.appendChild(table);		
		this.target.appendChild(field);		
		
		if(this._data == null){
			return;
		}else{
			
			let list = this._data;
			let tr = null;
			
			//필드 create		
			for(let i=0; i<list.length; i++){			
				tr = this._createColumn(list, i);			
				table.appendChild(tr);
			}
			//option - 스크롤 Y 설정
			if(this.option.isScrollY){
				field.classList.add("wgrid-overflow-y");
				field.style.height = this.option.bodyHeight;
			}			
		}		
	}
	
	//필드 컬럼 생성
	_createColumn(list, i){		
		
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
			if(this._isNotEmpty(this.fields[j].name)){
				td.dataset.columnName = this.fields[j].name;
			}
			
			//넓이 설정
			if(this._isNotEmpty(this.fields[j].width)){
				td.style.width = this.fields[j].width;
			}
			
			//사용자정의 템플릿
			if(this._isNotEmpty(this.fields[j].itemTemplate)){
				
				if(this.fields[j].isHeadSelect){				
					let div = null;
					for(let k=0; k<this.fields[j].headSelectList.length; k++){
						div = document.createElement("div");
						if(k !== 0)	div.style.display = "none";					
						div.setAttribute("name", this.fields[j].headSelectList[k].value);						
						let result = this.fields[j].itemTemplate(list[i][this.fields[j].headSelectList[k].value], this._data[this._dataLink[tr.dataset.key]], tr.dataset.key);
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
					let result = this.fields[j].itemTemplate(list[i][this.fields[j].name], this.deepCopy(this._data[this._dataLink[tr.dataset.key]]), tr.dataset.key);
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
						delete this._data[this._dataLink[node.dataset.key]];
						//태그 삭제
						node.remove();
						this._noDataField();
				    //그외 삭제 background 적용
					}else{
						
						let node = this._getTrNode(event.target);
						let idx = this._dataLink[node.dataset.key];
						this._data[idx]._isRemove = !this._data[idx]._isRemove;
						
						//변경사항 style 적용						
						this._applyStyle(!this._data[idx]._isRemove, "delete", node);						
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
				
				//yn버튼 이벤트용 클래스
				button.classList.add("wgrid-ynbtn-clkev");
				
				td.appendChild(button);
			//타입별 정의 (text, input, select)
			}else{
				
				switch(this.fields[j].tag){
				default :
				case "text" :						
					td.textContent = list[i][this.fields[j].name];
					
					//align 설정
					if(this._isNotEmpty(this.fields[j].align)){
						td.style.textAlign = this.fields[j].align;
					}
					break;
				case "input" :
					
					//input박스 생성
					input = document.createElement("input");
					input.value = list[i][this.fields[j].name];
					input.classList.add("wgrid-input");
					
					//align 설정
					if(this._isNotEmpty(this.fields[j].align)){
						input.style.textAlign = this.fields[j].align;
					}
					
					//이벤트 의존 클래스 등록
					switch(this.fields[j].type){
					case "currency":
						//통화 이벤트용 클래스
						input.classList.add("wgrid-currency-kuev");
						break;
					}
					//신규행 배경색 변경
					if(list[i]._state === "insert"){
						//신규행 배경색 class
						input.classList.add("wgrid-insert-tag");						
						//신규행 값 동기화 이벤트용 클래스 
						input.classList.add("wgrid-sync-insert-kuev");
				
					//신규가 아닌 행
					}else{						
						//값 동기화 이벤트용 클래스
						input.classList.add("wgrid-sync-kuev");							
					}									
					td.appendChild(input);
					break;
				case "select" :
					
					//select박스 생성
					select = document.createElement("select");					
					select.classList.add("wgrid-select");
					
					let seItem = this.items.select[this.fields[j].name];					
					let fOpList = seItem.opList;
					
					//부모 필터가 적용되는 셀렉트박스
					if(this._isNotEmpty(seItem.parentValueName)){
						fOpList = seItem.opList.filter(fOpItem => {
							return list[i][seItem.parentValueName] == fOpItem[seItem.filterValueName];
						});
					}
					
					//자신 셀렉트박스 변경시 자식 셀렉트박스가 변경되는 부분
					if(this._isNotEmpty(seItem.childValueName) && this._isNotEmpty(seItem.childColumnName)){
						//자식 변경 이벤트 클래스 적용
						select.classList.add("wgrid-parent-chgev");
					}
					
					//셀렉트박스 option 등록
					fOpList.forEach(opItem => {						
						
						option = document.createElement("option");
						option.value = opItem[seItem.value];						
						
						//selected 설정						
						if(option.value == list[i][seItem.name]){
							option.selected = true;
						}						
					
						//text[]일 경우 구분자(seItem.textJoin) 구분하여 합침
						if(typeof seItem.text === "object" && typeof seItem.text.length === "number"){							
							let txt = "";
							let join = this._isEmpty(seItem.textJoin) ? " " : seItem.textJoin;
							
							seItem.text.forEach(txList => {							
								if(this._isNotEmpty(opItem[txList])){
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
						if(this._isNotEmpty(seItem.dataValue)){							
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
					
					//신규행 배경색 변경
					if(list[i]._state === "insert"){
						//신규행 배경색 class
						select.classList.add("wgrid-insert-tag");
					}
					
					//값 동기화 이벤트 클래스 추가
					select.classList.add("wgrid-sync-chgev");
					td.appendChild(select);
					break;
				}
			}
			
			tr.appendChild(td);				
		}	
		return tr;
	}
	
	//통신 후 list, count, map 구분 
	_dataInjection(result){
		//단일 리스드 (list)
		if(typeof result === "object" && typeof result.length === "number"){			
			return {data:result, count:0};			
		//복합
		}else if(typeof result === "object" && typeof result.length === "undefined"){							
			let list = null;
			let keys = Object.keys(result);
										
			switch(keys.length){
			//카운트, 리스트(count, list)
			case 2:
				let count = 0;
				for(let i=0; i<keys.length; i++){					
					if(typeof result[keys[i]] === "number"){
						count = result[keys[i]];
					}else if(typeof result[keys[i]] === "object" && typeof result[keys[i]].length === "number"){
						list = result[keys[i]];
					}
				}
				return {data:list, count:count};	
				break;
			//카운트, 리스트, 맵(count, list, map)
			case 3:
				break;
			}							
		}
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
	
	//데이터 타입에 따른 데이터 가공
	_outputDataProcess(dataList){
		
		let list = this.deepCopy(dataList);
		let keys = null;
		
		list.forEach(item => {			
			keys = Object.keys(item);			
			for(let i=0; i<keys.length; i++){					
				switch(this._dataType[keys[i]]){				
				//통화
				case "currency":
					item[keys[i]] = this._removeComma(item[keys[i]]);
					break;
				}
			}
		});
		
		return list;		
	}
	
	//원본 행과 비교
	_checkRow(key){
			
		let idx = this._dataLink[key];
		if(this._data[idx]._state === "insert"){
			return true;
		}else{				
			let isEqual = true; 
			
			let keys = Object.keys(this._data[idx]);
			for(let i=0; i<keys.length; i++){
				
				if(keys[i].substring(0,1) === "_"){
					continue;
				}else{
					//타입에따른 비교(텍스트)
					if(this._dataType[keys[i]] === "text"){
						if(this._data[idx][keys[i]] != this._clone[idx][keys[i]]){
							isEqual = false;
							break;
						}
					//타입에따른 비교(통화)
					}else if(this._dataType[keys[i]] === "currency"){														
						if(this._removeComma(this._data[idx][keys[i]]) != this._removeComma(this._clone[idx][keys[i]])){
							isEqual = false;
							break;
						}
					}
				}
				
			}		
			return isEqual;				
		}
	}
	
	//복제본 생성
	_createClone(){
		if(this._isEmpty(this._data)) return;
		this._clone = this.deepCopy(this._data);
	}
	
	//스타일 적용, 취소 (내부용)
	_applyStyle(isApply, _state, tr){
		_state = _state.toLowerCase();
		if(isApply){
			//class 해제 로직
			tr.classList.remove("wgrid-" + _state + "-tr");											
			let trList = tr.childNodes;
			trList.forEach(element => {
				if(element.childNodes.length > 0){					
					for(let i=0; i<element.childNodes.length; i++){						
						if(element.childNodes[i].tagName === "INPUT" || element.childNodes[i].tagName === "SELECT"){
							element.childNodes[i].classList.remove("wgrid-" + _state +"-tag");
						}
					}					
				}
			});											
		}else{				
			//class 적용 로직
			tr.classList.add("wgrid-" + _state + "-tr");											
			let trList = tr.childNodes;			
			trList.forEach(element => {
				if(element.childNodes.length > 0){					
					for(let i=0; i<element.childNodes.length; i++){	
						if(element.childNodes[i].tagName === "INPUT" || element.childNodes[i].tagName === "SELECT"){
							element.childNodes[i].classList.add("wgrid-" + _state +"-tag");
						}
					}					
				}												
			});	
		}
	}
	
	//필드값 삭제
	_bodyRemove(){
		this.node.bodyTable = null;
		this.node.bodyDiv.remove();
		this.node.bodyDiv = null;
	}
	
	//의존 이벤트 등록
	_createEvent(){
		
		//click 이벤트
		this.target.addEventListener("click", event => {
			let item = this._getColumnNmAndKey(event.target);
			
			event.target.classList.forEach(className => {
				switch(className){
				case "wgrid-ynbtn-clkev":
					
					if("Y" === this._data[this._dataLink[item.key]][item.columnName]){
						this._data[this._dataLink[item.key]][item.columnName] = "N";
					}else{
						this._data[this._dataLink[item.key]][item.columnName] = "Y";
					}
					event.target.textContent = this._data[this._dataLink[item.key]][item.columnName];
					
					//변경사항 style 적용 (insert 제외)
					if(this._data[this._dataLink[item.key]]._state !== "insert"){
						this._applyStyle(this._checkRow(item.key), "update", this._getTrNode(event.target));
					}
					
					break;
				}
			});
		}, false);
		
		//change 이벤트
		this.target.addEventListener("change", event => {
			let item = this._getColumnNmAndKey(event.target);
			
			event.target.classList.forEach(className => {
				switch(className){
				//동기화 이벤트
				case "wgrid-sync-chgev":
					//값 동기화
					this._data[this._dataLink[item.key]][item.columnName] = event.target.value;
					//변경사항 style 적용										
					this._applyStyle(this._checkRow(item.key), "update", this._getTrNode(event.target));
					if(this._checkRow(item.key)){
						this._data[this._dataLink[item.key]]._state = "select";
					}else{
						this._data[this._dataLink[item.key]]._state = "update";
					}
					break;
				//필터 적용 셀렉트박스 - 부모(자신) 변경시 자식 변경 이벤트
				case "wgrid-parent-chgev":					
					
					//부모 변경시 자식변경 이벤트에 필요한 변수 체크
					if(this._isNotEmpty(this.items) && this._isNotEmpty(this.items.select) && this._isNotEmpty(this.items.select)
							&& this._isNotEmpty(this.items.select[item.columnName].childValueName) 
							&& this._isNotEmpty(this.items.select[item.columnName].childColumnName)){						
						
						let childValueName = this.items.select[item.columnName].childValueName; 		
						let childColumnName = this.items.select[item.columnName].childColumnName;				
						let childItem = this.items.select[childColumnName];									
						
						let childElement = this._getColumnElement(item.key, childColumnName);
						
						while(childElement.hasChildNodes()){
							childElement.removeChild(childElement.firstChild); 
						}
						
						let option = null;
						let select = document.createElement("select");
						
						childItem.opList.filter(opItem => {							
							return opItem[item.columnName] == event.target.value;
						}).forEach(opItem => {
							option = document.createElement("option");
							option.value = opItem[childValueName];
							option.textContent = opItem[childItem.text];
							select.appendChild(option);
						});
						
						select.classList.add("wgrid-select");						
						select.classList.add("wgrid-sync-chgev");												
						childElement.appendChild(select);
						
						//자식 셀렉트 박스 값 동기화
						this._data[this._dataLink[item.key]][childColumnName] = select.value;	
					}
					break;
				}
			});
		}, false);
		
		//keyup 이벤트
		this.target.addEventListener("keyup", event => {			
			let item = this._getColumnNmAndKey(event.target);			
			
			event.target.classList.forEach(className => {				
				switch(className){
				//값 동기화 이벤트
				case "wgrid-sync-kuev" :					
					//값 동기화
					this._data[this._dataLink[item.key]][item.columnName] = event.target.value;				
					
					//변경사항 style 적용										
					this._applyStyle(this._checkRow(item.key), "update", this._getTrNode(event.target));
					if(this._checkRow(item.key)){
						this._data[this._dataLink[item.key]]._state = "select";
					}else{
						this._data[this._dataLink[item.key]]._state = "update";
					}					
					break;
				//신규행 값 동기화 이벤트
				case "wgrid-sync-insert-kuev" :
					//값 동기화
					this._data[this._dataLink[item.key]][item.columnName] = event.target.value;
					break;		
				//금액 입력란 설정
				case "wgrid-currency-kuev" :
					let value = [];
					value[0] = event.target.value;
					value[1] = value[0].replace(/\D/g,"");			
					value[2] = String(value[1]);
					while (/(\d+)(\d{3})/.test(value[2])) {
						value[2] = value[2].replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
						value[2] = value[2].replace(/(^0+)/, "");
					}
					event.target.value = value[2];
					value = null;
					break;
				}
			});
		}, false);
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
	
	//Element으로 key와 컬럼명 찾기
	_getColumnNmAndKey(element){
		let result = {};
		result.columnName = null;
		result.key = -1;		
		
		//columnName과 key값 가져오기
		while(true){
			if(element.parentNode.tagName === "BODY" || element.parentNode.tagName === "HTML"){
				return null;
			}else if(element.parentNode.tagName === "TR"){
				result.key = element.parentNode.dataset.key;					
				break;
			}else if(element.parentNode.tagName === "TD"){
				result.columnName = element.parentNode.dataset.columnName;
				element = element.parentNode;
			}else{
				element = element.parentNode;
			}
		}		
		return result;
	}
	
	
	//########## 유틸 함수 ############
	
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
	
	//빈값 체크
	_isEmpty(_str){
		return !this._isNotEmpty(_str);
	}
	//!빈값 체크
	_isNotEmpty(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	}
	
	//콤마추카
	_setComma(str){
		str = String(str);
		if(this._isEmpty(str)){
			return str;
		}else{
			return str.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		}
	}
	//콤마 삭제
	_removeComma(str){
		return String(str).replace(/,/g,"");
	}
}