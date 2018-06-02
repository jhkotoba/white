let doc = document;
class Grey{
	constructor(id) {
		this._id = id;
		this._head = "";
		this._column = null;
		this._list = null;
		this._clone = null;
		this.beforeView = function(){};
		this.afterView = function(){};
		this._option = {
			clone : true,
			paging : true,			
			pagingInfo : {
				pageNum : 1,
				pageCnt : 10,
				blockCnt : 10,
				totalCnt : 0
			}
		}
	}
	
	/* 데이터 관련 */	
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
			this._option.paging = bool;
		}
	};
	
	get pagingState(){
		return {paging:this._option.paging, pagingInfo:this._option.pagingInfo};
	};
	
	get totalCnt(){
		return this._option.pagingInfo.totalCnt;
	};
	
	set totalCnt(cnt){
		if(!isNaN(cnt)){
			this._option.pagingInfo.totalCnt = Number(cnt);
		}else{
			alert("totalCount NaN.");
		}		
	};
	
	get pageNum(){
		return this._option.pagingInfo.pageNum;
	};
	
	set pageNum(pageNum){
		if(!isNaN(pageNum)){
			this._option.pagingInfo.pageNum = Number(pageNum);
		}else{
			alert("pageNum NaN.");
		}	
	};
	
	get pageCnt(){
		return this._option.pagingInfo.pageCnt;
	};
	
	set pageCnt(cnt){
		if(!isNaN(cnt)){
			this._option.pagingInfo.pageCnt = Number(cnt);
		}else{
			alert("pageCnt NaN.");
		}
	};
	
	get blockCnt(){
		return this._option.pagingInfo.pageCnt;
	};
	
	set blockCnt(cnt){
		if(!isNaN(cnt)){
			this._option.pagingInfo.blockCnt = Number(cnt);
		}else{
			alert("blockCnt NaN.");
		}			
	};
	
	/* 함수  */
	view(){		
		if(this._list.length === 0){
			return;
		}else{	
			
			//초기화			
			while(this.eId.firstChild !== null) this.eId.removeChild(this.eId.firstChild);
			
			//그리드 그리기전 함수 실행
			this.beforeView(this._id);
			
			//그리그 출력
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
			
			if(this._option.paging === true){
				//페이징바 출력
				tag += "<div id='"+this._id+"_paging'>";				
				for(let i=0; i<this._option.pagingInfo.blockCnt; i++){
					tag += "<a> "+i+" </a>";
				}				
				tag += "</div>";
			}			
			
			this.eId.innerHTML = tag;		
			
			//그리드 그린 후 함수 실행
			this.afterView(this._id);
		}
	};
}

