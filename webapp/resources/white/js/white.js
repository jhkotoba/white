let doc = document;
class White{
	constructor(id) {
		this._id = id;
		this._head = "";
		this._column = null;
		this._list = null;
		this._clone = null;
	}
	
	set id(id){
		this._id = id;
	};
	
	get id(){
		return this._id;
	};
	
	get eId(){
		return doc.getElementById(this._id);
	};
	
	set head(head){
		this._head = createHead(head);		
		function createHead(head){
			let rhead = "";
			if(typeof head === "object" && head.length > 0){
				for(let i=0; i<head.length; i++){				
					rhead += createHead(head[i]);
				}
			}else if(typeof head === "string" || typeof head === "number"){
				rhead += "<th>"+head+"</th>";
			}else if(typeof head === "boolean"){
				rhead += head === true ? "<th>True</th>" : "<th>False</th>";
			}
			return rhead;
		}
	};
	
	set column(column){
		this._column = column;
	};
	
	get head(){
		return this._head;
	};
	
	set list(list){		
		this._list = list;	
		this._clone = deepObjCopy(list);
		
		function deepObjCopy (dupeObj) {					
			let retObj = new Array();
			for (let objInd in dupeObj) {	
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
			return retObj;
		}
	};
	
	get list(){
		return this._list;
	};
	
	get clone(){
		return this._clone;
	}
	
	
	addCls(name, cls){
		
	};
	
	removeCls(name, cls){
		
	};
	
	sync(){
				
	};
	
	view(){		
		if(this._list.length === 0){
			return;
		}else{
			let tag = "<table>";
			tag += this._head;			
			for(let i=0; i<this._list.length; i++){
				tag += "<tr>";
				for(let j=0; j<this._column.length; j++){					
					tag += "<td>" + this._list[i][this._column[j]] + "</td>";				
				}
				tag += "</tr>";
			}
			tag += "</table>";
			this.eId.innerHTML = tag;
		}
	};
}

