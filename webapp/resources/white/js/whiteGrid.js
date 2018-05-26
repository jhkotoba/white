/**
 * whiteGrid.js
 * ver 0.0001
 */

class WhiteGrid{
	constructor(id) {
		this.id = id;
		this.head = new Array();
		this.list = new Array();
		this.listCopy = new Array();
	};
	
	setListClear(){
		this.head = new Array();
		this.list = new Array();
		this.listCopy = new Array();
	};
	
	setHead(head){
		this.head = head;
	};
	
	setList(list){
		this.list = list;
		this.listCopy = this._clone(list);
	};
	
	addCls(name, cls){
		
	};
	
	removeCls(name, cls){
		
	};
	
	sync(){
		
	};
	
	view(){
		
	};
	
	
	
	
	
	
	

	_clone (dupeObj) {
		let list = new Array();				
		for (let objInd in dupeObj) {	
			if (typeof(dupeObj[objInd]) == 'object') {
				list[objInd] = deepObjCopy(dupeObj[objInd]);
			} else if (typeof(dupeObj[objInd]) == 'string') {
				list[objInd] = dupeObj[objInd];
			} else if (typeof(dupeObj[objInd]) == 'number') {
				list[objInd] = dupeObj[objInd];
			} else if (typeof(dupeObj[objInd]) == 'boolean') {
				((dupeObj[objInd] == true) ? list[objInd] = true : list[objInd] = false);
			}
		}		
		return list;
	};
}

