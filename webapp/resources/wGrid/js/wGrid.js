class wGrid{
	constructor(option){
		this.id = option.id;
		this.target = document.getElementById(this.id);
		this.header = option.header;
		this.fields = option.fields;
		this.data = option.data;
		this.clone = null;
		//this.length = 0;
		
		if(option.is.clone) this.createClone();
	}
	
	//행 가져오기
	getRows(){
		
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
	
	//그리드 생성
	createGrid(){
		let list = this.data;
		
		//헤더생성
		let header = document.createElement("div");
		let table = document.createElement("table");
		let tr = document.createElement("tr"); 
		let th = null;
		
		if(this.isEmpty(this.header)){
			for(let i=0; i<this.fields.length; i++){
				th = document.createElement("td"); 
				th.textContent = this.fields[i].title;
				tr.appendChild(th);
			}
			table.appendChild(tr);
			header.appendChild(table);					
		}else{
			if(typeof this.header === "string"){
				header.innerHTML = this.header;
			}else{
				for(let i=0; i<this.header.length; i++){
					th = document.createElement("td"); 
					th.textContent = this.header[i].title;
					tr.appendChild(th);
				}
				table.appendChild(tr);
				header.appendChild(table);
			}
		}
		this.target.appendChild(header);
		
		//필드생성
	}
	
	
	isEmpty(_str){
		return !this.isNotEmpty(_str);
	}
	isNotEmpty(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	}
}