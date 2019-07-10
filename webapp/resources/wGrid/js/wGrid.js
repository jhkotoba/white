/**
 * wGrid
 * @author JeHoon 
 */
class wGrid{
	constructor(args){
		this.id = args.id;
		this.target = document.getElementById(this.id);
		this.header = args.header;
		this.fields = args.fields;
		this.data = args.data;		
		
		//xhr관련 변수
		this.xhr = {
			//비동기 url
			url : args.xhr.url,
			//비동기 여부
			async : isEmpty(args.xhr.async) ? true : args.xhr.async,
			//get, post 
			type : isEmpty(args.xhr.type) ? "POST" : args.xhr.type.toUpperCase()
		}
		
		//option
		this.option = {
			//그리드 생성시 자동 조회 여부
			auto : args.option.auto,
			//내부 비동기 조회 여부
			xhr : args.option.xhr,
			//edit 모드
			edit : args.option.edit
		}
		
		//message
		this.message = {
			//조회 데이터 없을시 메시지
			nodata : this.isEmpty(args.message.nodata) ? "no data" : args.message.nodata
		}
		
		//데이터 복제본 생성
		this.clone = null;
		if(args.is.clone) this.createClone();
	}
	
	//데이터 넣기
	setData(data){
		this.data = data;
	}
	
	//데이터 가져오기
	getData(){
		return this.data;
	}
	
	
	
	
	
	//행단위 데이터 가져오기
	getRow(){
		
	}
	
	
	
	//그리드 생성
	createGrid(){
		let list = this.data;
		
		//헤더생성
		let header = document.createElement("div");		
		let table = document.createElement("table");
		table.classList.add("wgrid-table-header");
		
		let tr = document.createElement("tr"); 
		let th, td = null;
		
		//header 없을시 fields title로 헤더 생성
		if(this.isEmpty(this.header)){
			for(let i=0; i<this.fields.length; i++){
				th = document.createElement("th"); 
				th.style.width = this.fields[i].width;				
				th.textContent = this.fields[i].title;
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
		if(this.option.auto){
			
			//생성시 데이터 존재하지 않을 경우
			if(this.isEmpty(this.data)){
				
				//내부 비동기 조회인 경우 xhr : true
				if(this.option.xhr){
					
					//비동기 통신
					this.xhttp(null, result => {
						this.data = result;
						this.createField();
						
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
		
		let tr, td, input = null;
		
		//필드 create
		for(let i=0; i<list.length; i++){
			tr = document.createElement("tr");
			
			for(let j=0; j<this.fields.length; j++){
				td = document.createElement("td");
				
				if(this.isNotEmpty(this.fields[j].width)){
					td.style.width = this.fields[j].width;
				}
				
				//itemTemplate
				if(this.isNotEmpty(this.fields[j].itemTemplate)){
					let result = this.fields[j].itemTemplate(list[i][this.fields[j].name], list[i], i);
					if(typeof result === "object"){
						td.appendChild(result);
					}else{
						td.insertAdjacentHTML("afterbegin", result);
					}
				
				}else{
					
					switch(this.fields[j].type){
					default :
					case "text" : 
						td.textContent = list[i][this.fields[j].name];
						break;
					case "input" :
						input = document.createElement("input");
						input.value = list[i][this.fields[j].name];						
						input.classList.add("wgrid-input");
						input.addEventListener("keyup", event => {							
							list[i][this.fields[j].name] = event.target.value;
						}, false);
						td.appendChild(input);
						break;
					case "select" :
						
						break;
					}
				}
				tr.appendChild(td);				
			}			
			table.appendChild(tr);
		}
		
		//필드 등록
		field.appendChild(table);
		this.target.appendChild(field);		
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
			let keys = Object.keys(this.sParam);			
			for(let i=0; i<keys.length; i++){				
				formData.append(keys[i], String(this.sParam[keys[i]]));
			}			
			xhr.send(formData);	
		}
	}
}