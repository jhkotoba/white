let doc = document;
class Grey{
	constructor(id) {
		this._id = id;
		this._head = "";
		this._column = null;
		this._list = null;
		this._clone = null;		
		this.fnBeforeView = function(){};
		this.fnAfterView = function(){};
		this.fnXhrStart = function(){};
		this.fnXhrEnd = function(){};
		this._option = {
			clone : true,			
			async : {
				url : "",
				async : true,
			},						
			paging : {
				paging : true,
				pageNum : 1,
				pageCnt : 10,
				blockCnt : 10,
				totalCnt : 0
			},
			
		}
	}
	
	/* getter, setter */	
	set id(id){
		this._id = id;
	};
	
	get id(){
		return this._id;
	};
	
	get eId(){
		return doc.getElementById(this._id);
	};
	
	set async(bool){
		if(typeof bool === "boolean"){
			this._option.async.async = bool;
		}else{
			alert("no boolean");
		}
	};
	
	set url(url){
		this._option.async.url = url;
	};
	
	get url(){
		return this._option.async.url;
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
		if(this._option.clone === true){
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
		}		
	};
	
	get list(){
		return this._list;
	};

	
	set isClone(bool){
		this._option.clone = bool;
	};
	
	get clone(){
		return this._clone;
	};
	
	/* 페이징 관련 */
	set isPaging(bool){
		if(typeof bool === "boolean"){
			this._option.paging.paging = bool;
		}else{
			alert("no boolean");
		}
	};
	
	/*get pagingState(){
		return this._option.paging;
	};*/
	
	get totalCnt(){
		return this._option.paging.totalCnt;
	};
	
	set totalCnt(cnt){
		if(!isNaN(cnt)){
			this._option.paging.totalCnt = Number(cnt);
		}else{
			alert("totalCount NaN.");
		}		
	};
	
	get pageNum(){
		return this._option.paging.pageNum;
	};
	
	set pageNum(pageNum){
		if(!isNaN(pageNum)){
			this._option.paging.pageNum = Number(pageNum);
		}else{
			alert("pageNum NaN.");
		}	
	};
	
	get pageCnt(){
		return this._option.paging.pageCnt;
	};
	
	set pageCnt(cnt){
		if(!isNaN(cnt)){
			this._option.paging.pageCnt = Number(cnt);
		}else{
			alert("pageCnt NaN.");
		}
	};
	
	get blockCnt(){
		return this._option.paging.pageCnt;
	};
	
	set blockCnt(cnt){
		if(!isNaN(cnt)){
			this._option.paging.blockCnt = Number(cnt);
		}else{
			alert("blockCnt NaN.");
		}			
	};	
	
	/* 함수  */
	_view(){		
		if(this._list.length === 0){
			return;
		}else{	
			
			//초기화			
			while(this.eId.firstChild !== null) this.eId.removeChild(this.eId.firstChild);
			
			//그리드 그리기전 함수 실행
			this.fnBeforeView(this._id);
			
			//그리그 출력
			let tag = "<table id='tb_"+this._id+"'>";
			tag += this._head;			
			for(let i=0; i<this._list.length; i++){
				tag += "<tr>";
				for(let j=0; j<this._column.length; j++){					
					tag += "<td id='"+i+"'>" + this._list[i][this._column[j]] + "</td>";				
				}
				tag += "</tr>";
			}
			tag += "</table>";
			
			if(this._option.paging === true){
				//페이징바 출력
				tag += "<div id='"+this._id+"_paging'>";				
				for(let i=this._option.paging.pageNum; 
						i<this._option.paging.blockCnt+this._option.paging.pageNum; i++){
					tag += "<a> "+i+" </a>";
				}				
				tag += "</div>";
			}			
			
			this.eId.innerHTML = tag;		
			
			//그리드 그린 후 함수 실행
			this.fnAfterView(this._id);
		}
	};
	
	/* 비동기통신 */
	asyncConn(param){
		
		let xhr = new XMLHttpRequest();
		let obj = this;
		
		
		xhr.open("POST", this._option.async.url, this._option.async.async);
		
		xhr.onreadystatechange = function(){
			if (xhr.readyState == 4) {
				if (xhr.status == 200) {						
					let data = JSON.parse(xhr.responseText);						
					obj.totalCnt = data.totalCnt;
					obj.list = data.list;
					obj._view();
				}else{
					alert("xhr.status:"+xhr.status);
				}
			}
		}
		
		let formData = new FormData();			
		let keys = Object.keys(param);			
		for(let i=0; i<keys.length; i++){				
			formData.append(keys[i], String(param[keys[i]]));
		}			
		xhr.send(formData);
	};
}

