/**
 * @author JeHoon
 * @version 1.1.0
 */

let cAdjust = {
	
	adjust : function(type, data){
		let adjustData;
		
		type = type.replace(/^\s+|\s+$/g,"").toLowerCase();
		
		switch(type){		
		case "javascript":	
		case "jquery":	
		case "jsgrid":
			adjustData = this._javascript(data, false);
			break;
		default:
			adjustData = "<div><pre class='cAdjust-textarea'>"+data+"</pre></div>";
			break;		
		}
		return adjustData;
	},
	
	_jsp : function(){
		
	},
	_javascriptCmd : {
		//추가불가
		"//" : "js-annotation",
		"/*" : "js-annotation",
		'"' : "js-text",
		"'" : "js-text",
		//추가가능
		"default" : "js-directive",
		"function" : "js-directive",
		"typeof" : "js-directive",			
		"true" : "js-directive",
		"else" : "js-directive",
		"case" : "js-directive",
		"if" : "js-directive",
		"in" : "js-directive",
		"break" : "js-directive",
		"switch" : "js-directive",
		"let" : "js-directive",
		"return" : "js-directive",
		"null" : "js-directive",
		"undefined" : "js-directive",
		"var" : "js-directive",
		"false" : "js-directive",
		"throw" : "js-directive",
		"new" : "js-directive",
		"continue" : "js-directive",
		"finally" : "js-directive",
		"delete" : "js-directive",
		"while" : "js-directive",
		"catch" : "js-directive",
		"try" : "js-directive",
		"for" : "js-directive",
		"this" : "js-directive"
	},	
	_javascript : function(data, part){
		
		//조합 데이터
		let str = "";
		let temp = "";
		let line = 1;
		let chList = null;
				
		//반복 상태값
		let state = "none";		
		//개행문자 오기 전까지 주석 개수
		let annCnt = 0;
		// /*형식의 주석종료 위치
		let ann2Idx = 0;
		// 큰따옴표 종료 위치
		let	dQuotationIdx = 0;
		//작은따옴표 종료 위치
		let quotationIdx = 0;
		
		//커맨드값 추출
		let jsKeyList = Object.keys(this._javascriptCmd);
		let fstChList = {};
		let fstCmd = "";
		
		//커맨드값 가공
		for(let i=0; i<jsKeyList.length; i++){
			fstCmd = jsKeyList[i].substr(0, 1);			
			if(fstChList[fstCmd] === undefined){
				fstChList[fstCmd] = new Array();
				fstChList[fstCmd].push(jsKeyList[i]);
			}else{
				fstChList[fstCmd].push(jsKeyList[i]);
			}
		}
		
		let ch = data.split("");
		for(let i=0; i<ch.length; i++){
			
			//태그문자 변환
			if(ch[i] === "<") ch[i] = "&lt;";
			
			//라인 수
			if(ch[i] === '\n') line++;
			
			//종료처리
			if(state !== "none"){				
				switch(state){
				case "/*":
					if(ann2Idx == i) {
						str += "</span>";
						state = "none";
						ann2Idx = 0;
					}
					break;
				case "//":
					if(ch[i] == '\r' || ch[i] == '\n') {
						for(let j=0; j<annCnt; j++) {
							str += "</span>";
						}
						state = "none";
						annCnt = 0;
					}
					break;
				case '"':
					if(dQuotationIdx == i) {
						str += "</span>";
						state = "none";
						dQuotationIdx = 0;
					}else if(ch[i] == '\r' || ch[i] == '\n') {
						str += "</span>";
						state = "none";
						dQuotationIdx = 0;
					}
					break;
				case "'":
					if(quotationIdx == i) {
						str += "</span>";
						state = "none";
						quotationIdx = 0;
					}else if(ch[i] == '\r' || ch[i] == '\n') {
						str += "</span>";
						state = "none";
						quotationIdx = 0;
					}
					break;
				default :
					if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1] == state.substr(state.length - 1)){
						str += "</span>";
						state = "none";
					}
					break;
				}
			//시작처리 
			}else{ // state === "none"
				switch(ch[i]){
				
				//주석
				case '/':				
					if(ch.length-1 > i+1 && ch[i+1]==='*'){
						let annBool = false;
						for(let j=i+2; j<ch.length; j++) {
							if(ch.length-1 >= j+1 && ch[j]==='*' && ch[j+1]==='/') {
								annBool = true;
								ann2Idx = j+2;
								break;
							}
						}
						if(annBool) {
							str += "<span class='"+this._javascriptCmd["/*"]+"'>";
							state = "/*";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1]==='/') {
						if("/*" !== state) {
							str += "<span class='"+this._javascriptCmd["//"]+"'>";
							state = "//";
							annCnt++;
						}								
					}				
					break;
					
				//큰따옴표
				case '"':						
					if(ch.length-1 >= i+1 && ch[i]=='"'){
						let dQuotation = false;
						for(let j=i+1; j<ch.length; j++) {
							if(ch.length-1 >= j+1 && ch[j]=='"') {
								dQuotation = true;
								dQuotationIdx = j+1;
								break;
							}
						}
						if(dQuotation) {
							str += "<span class='"+this._javascriptCmd['"']+"'>";
							state = '"';
						}
					}
				break;
				
				//작은따옴표
				case "'":						
					if(ch.length-1 >= i+1 && ch[i]=="'"){
						let quotation  = false;
						for(let j=i+1; j<ch.length; j++) {
							if(ch.length-1 >= j+1 && ch[j]=="'") {
								quotation = true;
								quotationIdx = j+1;
								break;
							}
						}
						if(quotation) {
							str += "<span class='"+this._javascriptCmd["'"]+"'>";
							state = "'";
						}
					}
				break;
				
				//명령어
				default :
					if(fstChList[ch[i]] !== undefined){
						chList = fstChList[ch[i]];						
						for(let j=0; j<chList.length; j++){
							//내용 중간
							if(ch.length-1 >= i+chList[j].length){								
								for(let k=0; k<chList[j].length; k++){									
									if(ch[i+k] === chList[j].substr(k, 1)){
										temp += ch[i+k];
									}
								}
								if(chList[j] === temp && this._spCharCheck(ch[i+chList[j].length])){
									str += "<span class='"+this._javascriptCmd[chList[j]]+"'>";
									state = chList[j];
								}
								temp = "";
							//내용 마지막
							}else if(ch.length-1 < i+chList[j].length){
								for(let k=0; k<chList[j].length; k++){									
									if(ch[i+k] === chList[j].substr(k, 1)){
										temp += ch[i+k];
									}
								}
								if(chList[j] === temp){
									str += "<span class='"+this._javascriptCmd[chList[j]]+"'>";
									state = "end";
								}
								temp = "";
							}
						}
						chList = null;
					}
					break;
				}			
			}
			str += ch[i];
		}
		
		if("end" === state) str += "</span>";
		
		if(part === true){
			return {cotent : str, line : line};			
		}else{			
			let result = "<div>";		
			result += "<div class='cAdjust-line'>";
			
			for(let i=0; i<line; i++){
				result += "<div>"+(i+1)+"</div>";
			}	
			result +="</div><pre class='cAdjust-textarea'>"+str+"</pre></div>";
			return result;
		}
	},
	_html : function(){
		
	},
	_xml : function(){
		
	},
	_java : function(){
		
	},
	
	_spCharCheck : function(ch){
		switch(ch) {
		case ' ': case '\t': case '(':case ')': case '\n': case '@': case '#': case '%': case '^': case '&': case '*': case '{': case '}':
		case '-': case '+': case '=': case '/': case '`': case '~': case '<': case '>': case '?': case ',':	case '.': case ':': case ';':
			return true;		
		default:
			return false;
		}
	}
}