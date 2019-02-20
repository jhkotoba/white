/**
 * @author JeHoon
 * @version 1.2.0
 */

let cAdjust = {
		
	adjust : function(type, data){
		let adjustData;
		
		type = type.replace(/^\s+|\s+$/g,"").toLowerCase();
		
		
		switch(type){
		case "java":
			adjustData = this._java(this.restore(data), false);
			break;		
		case "javascript":
		case "jquery":
		case "jsgrid":
			adjustData = this._javascript(this.restore(data), false);
			break;
		case "xml":
		case "mybatis":
			adjustData = this._xml(this.restore(data), false);
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
	
	
	_javaCmd : {
		
	},
	
	_java : function(data, part){
		
		let line = 1;		
		let ch = data.split("");
		let str = "";
		
		for(let i=0; i<ch.length; i++){
			
			//라인 수
			if(ch[i] === '\n') line++;
			
			
			str += ch[i];
		}
		
		
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
	
	_jsp : function(){
		
	},
	
	_javascriptCmd : {
		//추가불가
		"rowannotation" : "js-annotation",
		"domainannotation" : "js-annotation",
		'doublequotation' : "js-text",
		"quotation" : "js-text",
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
				case "domainannotation":
					if(ann2Idx == i) {
						str += "</span>";
						state = "none";
						ann2Idx = 0;
					}
					break;
				case "rowannotation":
					if(ch[i] == '\r' || ch[i] == '\n') {
						for(let j=0; j<annCnt; j++) {
							str += "</span>";
						}
						state = "none";
						annCnt = 0;
					}
					break;
				case 'doublequotation':
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
				case "quotation":
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
					if(ch.length-1 > i+1 && this._isSpecial(ch[i]) && ch[i-1] == state.substr(state.length - 1)){
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
							str += "<span class='"+this._javascriptCmd["domainannotation"]+"'>";
							state = "domainannotation";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1]==='/') {
						if("/*" !== state) {
							str += "<span class='"+this._javascriptCmd["rowannotation"]+"'>";
							state = "rowannotation";
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
							str += "<span class='"+this._javascriptCmd['doublequotation']+"'>";
							state = 'doublequotation';
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
							str += "<span class='"+this._javascriptCmd["quotation"]+"'>";
							state = "quotation";
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
								if(chList[j] === temp && this._isSpecial(ch[i+chList[j].length])){
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
	_xml : function(data, part){
		
		let state = "none";
		let opentag = false;
		let quotation = false;
		let line = 1;
		let str = "";
		let ch = data.split("");
		
		for(let i=0; i<ch.length; i++){
			
			//라인 수
			if(ch[i] === '\n') line++;
			
			if(state === "none"){
				switch(ch[i]){
				case "<":
					if(this._compare(ch, i, "<![CDATA[", false)){
						str += "<span class='xml-tagArea'>";
						state = "cdata";
					}else if(this._compare(ch, i, "<!--", false)){
						str += "<span class='xml-annotation'>";
						state = "annotation";
					}else if(this._compare(ch, i, "</", false)){
						str += "<span class='xml-tag'>";
						state = "openslashtag";
					}else{
						str += "<span class='xml-tag'>";
						state = "opentag";
					}	
					break;
				case ">":
					str += "<span class='xml-tag'>";
					state = "endtag";
					break;
				case "=":
					if(opentag){
						str += "<span class='xml-equal'>";
						state = "equal";
					}
					break;
				case "'":
					if(opentag){
						str += "<span class='xml-quotation'>";
						state = "quotation";
					}
					break;
				case '"':
					if(opentag){
						str += "<span class='xml-quotation'>";
						state = "doublequotation";
					}
					break;
				default:
					if(opentag && state !== "tagarea"){
						str += "<span class='xml-tagArea'>";
						state = "tagarea";
					}
					break;
				}		
			}else{
				switch(state){
				
				case "cdata":
					if(this._compare(ch, i, "<![CDATA[", true)){
						str += "</span><span class='xml-cdataText'>";
						state = "cdatatext";
					}else if(this._compare(ch, i, "]]>", true)){
						str += "</span>";
						state = "none";
					}
					break;
				case "cdatatext":
					if(this._compare(ch, i, "]]>", false)){
						str += "</span><span class='xml-tagArea'>";
						state = "cdata";
					}
					break;
				case "annotation":
					if(this._compare(ch, i, "-->", true)){
						str += "</span>";
						state = "none";
					}
					break;
				case "opentag":
					str += "</span>";
					if(ch.length > (i+1) && this._isSpecial(ch[i+1])){
						state = "none";
					}else{
						str += "<span class='xml-tagName'>";
						state = "tagname";
					}
					break;
				case "openslashtag":
					if(this._compare(ch, i, "</", true)){
						str += "</span>";
						if(ch.length > (i+1) && this._isSpecial(ch[i+1])){
							state = "none";
						}else{
							str += "<span class='xml-tagName'>";
							state = "tagname";
						}
					}
					break;
				case "tagname" :
					if(this._compare(ch, i, " ", false)){
						str += "</span>";
						state = "none";
						opentag = true;
					}else if(this._compare(ch, i, ">", false)){
						str += "</span><span class='xml-tag'>";
						state = "endtag";
						opentag = false;
					}
					break;
				case "endtag":
					str += "</span>";
					state = "none";
					opentag = false;
					break;
				case "tagarea":
					if(this._compare(ch, i, ">", false)){
						str += "</span><span class='xml-tag'>";
						state = "endtag";
						opentag = false;
					}else if(this._compare(ch, i, "=", false)){
						str += "</span><span class='xml-equal'>";
						state = "equal";
					}else if(this._compare(ch, i, "'", false)){
						str += "</span><span class='xml-quotation'>";
						state = "quotation";
					}else if(this._compare(ch, i, '"', false)){
						str += "</span><span class='xml-quotation'>";
						state = "doublequotation";
					}
					break;
					
				case "equal":
					str += "</span>";
					if(this._compare(ch, i, "'", false)){
						str += "<span class='xml-quotation'>";
						state = "quotation";
						quotation = true;
					}else if(this._compare(ch, i, '"', false)){
						str += "<span class='xml-quotation'>";
						state = "doublequotation";
						quotation = true;
					}else{
						state = "none";
					}
					break;
				case "quotation":
					if(this._compare(ch, i, "'", false)){
						state = "quotationendready";
					}
					break;
				case "doublequotation":
					if(this._compare(ch, i, '"', false)){
						state = "quotationendready";
					}
					break;
				case "quotationendready":
					if(this._compare(ch, i, ">", false)){
						str += "</span><span class='xml-tag'>";
						state = "endtag";
						quotation = false;
					}else{
						str += "</span>";
						state = "none";
						quotation = false;
					}
					break;
				}
			}
			str += ch[i] === "<" ? "&lt;" : ch[i];
		}
		
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
	
	//char: 글자배열, idx: 현재글자 위치, word:비교할 단어, isPrefix:현자글자 위치로부터 지나간 방향(true), 현자글자 위치로부터 지나갈 방향(false), _cnt:내부 재귀체크 카운트
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
		if(char.length >= (idx+word.length) && char[idx+_cnt] === word[_cnt]){
			_cnt = _cnt+1;
			if(word.length === _cnt) return true;
			else return this._compare(char, idx, word, isPrefix, _cnt);
		}else return false;
	},	
	
	_isSpecial : function(ch){
		switch(ch) {
		case ' ': case '\t': case '(':case ')': case '\n': case '@': case '#': case '%': case '^': case '&': case '*': case '{': case '}':
		case '-': case '+': case '=': case '/': case '`': case '~': case '<': case '>': case '?': case ',':	case '.': case ':': case ';':
			return true;
		default:
			return false;
		}
	}
}