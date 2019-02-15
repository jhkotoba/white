/**
 * @author JeHoon
 * @version 1.1.0
 */

let cAdjust = {
		
	adjust : function(type, data){
		let adjustData;
		
		type = type.replace(/^\s+|\s+$/g,"").toLowerCase();
		console.log(type);
		
		switch(type){		
		case "javascript":	
		case "jquery":	
		case "jsgrid":
			adjustData = this._javascript(this.restore(data), false);
			break;
		case "xml":
		case "mybatis":
			adjustData = this._xml(this.restore(data), false);
			console.log(adjustData);
			break;
		default:
			adjustData = "<div><pre class='cAdjust-textarea'>"+data+"</pre></div>";
			break;		
		}
		return adjustData;
	},
	
	conversion : function(text){
		return text.replace(/</gi, "&lt;").replace(/>/gi, "&gt;");
	},
	
	restore : function(text){
		return text.replace(/&lt;/gi, "<").replace(/&gt;/gi, ">");
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
	
	_xmlCmd : {		
		"<!--" : "xml-annotation"
		
	},
	_xml : function(data, part){
		console.log("XML");
		let state = "none";		
		let annotationIdx = 0;
		let tagOpen = false;
		let tagClose = false;
		let tagName = false;
		let tagAttr = false;
		let tagText = false;
		
		let line = 1;
		let str = "";
		
		//data = this.restore(data);
		
		//data = this.conversion()
		
		
		let ch = data.split("");
		console.log(ch);
		
		//커맨드값 추출
		//let xmlKeyList = Object.keys(this._xmlCmd);
		//let fstChList = {};
		//let fstCmd = "";
		
		//커맨드값 가공
		/*for(let i=0; i<xmlKeyList.length; i++){
			fstCmd = xmlKeyList[i].substr(0, 1);			
			if(fstChList[fstCmd] === undefined){
				fstChList[fstCmd] = new Array();
				fstChList[fstCmd].push(xmlKeyList[i]);
			}else{
				fstChList[fstCmd].push(xmlKeyList[i]);
			}
		}
		*/
		
		
		
		for(let i=0; i<ch.length; i++){
			
			//태그문자 변환
			//if(ch[i] === "<") ch[i] = "&lt;";
			//<![CDATA[      ]]>
			//라인 수
			if(ch[i] === '\n') line++;
			
			if(state === "none"){
				console.log(ch[i]);
				if(tagName){
					str += "<span class='xml-tagName'>";
					state = "tagName";
					tagName = false;
				}else if(tagAttr){
					str += "<span class='xml-tagAttr'>";
					state = "tagAttr";
					tagAttr = false;				
				}else{
					switch(ch[i]){				
					case "<":					
						if(this._compare(ch, i, "<!--", false)){						
							str += "<span class='xml-annotation'>";
							state = "<!--";
						}else{
							str += "<span class='xml-tag'>";
							tagOpen = true;
						}
					
					
					
					
						break;
					case ">":
						str += "<span class='xml-tag'>";
						tagClose = true;
						break;
						
					case "='":
						str += "<span class='xml-equal'>";
						state = "equal-quotation";
						break;
					case '="':
						str += "<span class='xml-equal'>";
						state = "equal-dQuotation";
						break;
					}
				
				
					
				}
				
				
				
							
			}else{
				switch(state){
				case "<!--":
					if(this._compare(ch, i, "-->", true)){
						str += "</span>";
						state = "none";
					}
					break;
				case "tagName" :				
					if(this._compare(ch, i, " ", false)){
						str += "</span>";
						state = "none";
						tagAttr = true;
					}
					break;
				case "tagAttr" : 
					if(this._compare(ch, i, ">", false)){
						str += "</span>";
						state = "none";
					}
					break;
				case "equal-quotation":
					if(this._compare(ch, i, '" ', false)){
						str += "</span>";
						state = "none";
					}
					break;
				case "equal-dQuotation":
					if(this._compare(ch, i, "' ", false)){
						str += "</span>";
						state = "none";
					}
					break;
				}
			}
			
			str += ch[i] === "<" ? "&lt;" : ch[i];
			//if(tagOpen)	str += "</span>";
			if(tagOpen){
				str += "</span>";
				tagOpen = false;
				tagName = true;
			}else if(tagClose){
				str += "</span>";
				tagClose = false;
			}
			
			/*if(tagOpen){
				str += "</span>";
				tagOpen = false;
				tagName = true;
			}else if(tagName){
				
			}else{
				
			}*/
				
			
			
			
		}		
		
		//console.log(str);
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
	
	_compare : function(char, idx, word, isPrefix, _cnt){
		if(char === null || char === undefined || idx === null || idx === undefined ||
		   word === null || word === undefined || isPrefix === null || isPrefix ===	undefined) return false;		
		if(_cnt === undefined || _cnt === null){
			if(isPrefix){
				if(idx - word.length < 0) return false;
				idx = idx - word.length;
			}
			_cnt = 0;
		}
		if(char.length > (idx+word.length) && char[idx+_cnt] === word[_cnt]){			
			_cnt = _cnt+1;
			if(word.length === _cnt) return true;
			else return this._compare(char, idx, word, isPrefix, _cnt);
		}else return false;
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