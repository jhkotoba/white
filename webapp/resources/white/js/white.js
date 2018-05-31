/**
 * white.js
 * ver 0.01
 */

class White{
	constructor(id) {
		this._id = id;
		this._head = "";
		this._list = new Array();
		this._clone = new Array();
	}
	
	set id(id){
		this._id = id;
	};
	
	get id(){
		return this._id;
	};
	
	get eId(){
		return document.getElementById(this._id);
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
		
	};
}

