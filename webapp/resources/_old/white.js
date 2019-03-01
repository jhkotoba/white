/**
 * 
 */
let doc = document;
let _wh = {};
class White{
	constructor(id) {		
		eval("_wh."+id+"=this;");
		this._id = id;		
		this._list = null;
		this._clone = null;
		this._head = "";
		this._hWidth = null;
		this._column = null;		
		this._param = {};		
		
		/* 페이징 */
		this._pageNum = 1,
		this._pageCnt = 10,
		this._blockCnt = 10,
		this._totalCnt = 0,
		
		/* true/false 옵션 */
		this._isClone = false,
		this._isPaging = false,
		this._isEdit = false,
		
		/* class 설정 (default)*/
		this._tbCls = "table";
		this._pgBtnCls = "pg-btn";
		
		/* 등록 함수 */		
		this.fnOnClickEvent = function(item, idx){};
		this.fnAjax = function(){};			
	};	
	
	/* data */
	get id(){return this._id;}
	set id(id){this._id = id;}		
	get eId(){return doc.getElementById(this._id);}	
	
	get list(){return this._list;}
	set list(list){	
		this._list = list;
		if(this._isClone === true){
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
	}
	
	set head(head){
		if(typeof head !== "object"){
			console.log("head not object or array");
		}else{
			this._head = head;
		}
	}	
	set hWidth(hWidth){this._hWidth = hWidth;}	
	set column(column){this._column = column;}	
		
	get pagingData(){
		return {
			pageNum : this._pageNum,
			pageCnt : this._pageCnt,
			blockCnt : this._blockCnt
		}
	};	
	
	/* option */
	get isClone(){return this._isClone;}
	set isClone(bool){this._isClone = bool;}
	get isPaging(){return this._isPaging;}
	set isPaging(bool){this._isPaging = bool;}	
	
	/* paging */
	get pageNum(){return this._pageNum;}
	set pageNum(pageNum){this._pageNum = Number(pageNum);}
	get pageCnt(){return this._pageCnt;}
	set pageCnt(pageCnt){this._pageCnt = Number(pageCnt);}	
	get blockCnt(){return this._blockCnt;}
	set blockCnt(blockCnt){this.blockCnt = Number(blockCnt);}
	get totalCnt(){return this._totalCnt;}
	set totalCnt(totalCnt){this._totalCnt = Number(totalCnt);}
	
	/* class */	
	get tbCls(){return this._tbCls;};
	set tbCls(tableClass){this._tbCls = tableClass;};
	get pgBtnCls(){return this._pgBtnCls;};
	set pgBtnCls(pagingButtonClass){this._pgBtnCls = pagingButtonClass;};	
	
	/* function */
	delParam(paramNm){
		delete this.param[paramNm];		
	}
	
	draw(){		
		//초기화		
		while(this.eId.firstChild !== null) this.eId.removeChild(this.eId.firstChild);
		
		//그리그 출력
		let tag = "<table id='whtb' class='"+this._tbCls+"'>";	
		
		//헤더 그리기
		if(this._hWidth === null || this._hWidth === undefined || this._hWidth === ""){
			for(let i=0; i<this._head.length; i++){
				tag += 	"<th>"+this._head[i]+"</th>";	
			}
		}else{
			for(let i=0; i<this._head.length; i++){
				tag += 	"<th style='width:"+this._hWidth[i]+"'>"+this._head[i]+"</th>";	
			}
		}		
		
		//본몬 그리기
		let event = "";
		for(let i=0; i<this._list.length; i++){
			tag += "<tr>";
						
			for(let j=0; j<this._column.length; j++){				
				event = "";
				
				//이벤트 설정
				switch(this._column[j].event){
				case "onClick" :					
					event = "onClick=_wh."+this._id+".fnOnClickEvent(_wh."+this._id+","+i+")";
					break;
				}
				
				//타입 설정
				switch(this._column[j].type){
				case "text" :
					if(this._column[j].event === "onClick"){
						tag += "<td "+event+">" + this._list[i][this._column[j].name] + "</td>";
					}else{
						tag += "<td>" + this._list[i][this._column[j].name] + "</td>";
					}					
					break;
				case "a" : 
					tag += "<td><a "+event+">" + this._list[i][this._column[j].name] + "</a></td>";
					break;
				}	
				
			}
			tag += "</tr>";				
		}
		tag += "</table>";		
		
		//페이징바 출력
		if(this._isPaging === true){
			
			tag += "<div id='"+this._id+"_paging' class='"+this._pgBtnCls+"'>";
			
			let blockNum = Math.floor(this._pageNum / this._blockCnt) * this._blockCnt;
			let blockLen = Math.ceil(this._totalCnt / this._pageCnt);			
			
			if(blockNum !== 0){							
				if(this._pageNum <= 10){
					tag += "<a onclick='_wh."+this._id+"._pg(1);'><</a>";
				}else{
					let pgNm = blockNum-this._blockCnt;
					tag += "<a onclick='_wh."+this._id+"._pg("+(pgNm===0?1:pgNm)+");'><</a>";
				}
			}	
			for(let i=blockNum; i<blockNum+this.blockCnt; i++){
				if(i === 0){
					continue;				
				}else if(blockLen >= i){
					if(this._pageNum === i){
						tag += "<a style='border: 1px solid #BDBDBD;'>"+i+"</a>";
					}else{
						tag += "<a onclick='_wh."+this._id+"._pg("+i+");'>"+i+"</a>";
					}											
				}							
			}
			if(this._pageNum < blockLen){				
				if(this._pageNum <= blockLen-this._blockCnt){
					tag += "<a onclick='_wh."+this._id+"._pg("+(blockNum+this.blockCnt)+");'>></a>";
				}else{
					tag += "<a onclick='_wh."+this._id+"._pg("+blockLen+");'>></a>";
				}		
			}
			tag += "</div>";
		}			
		
		this.eId.innerHTML = tag;		
	}
	
	_pg(pageNum){
		this._pageNum = Number(pageNum);
		this.param.pageNum = this._pageNum;
		this.param.pageCnt = this._pageCnt;
		this.fnAjax();	
	}
	
}