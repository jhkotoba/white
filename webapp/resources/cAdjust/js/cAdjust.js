/**
 * 
 */

let cAdjust = {
	
	adjust : function(type, data){
		let adjustData;
		
		type = type.replace(/^\s+|\s+$/g,"").toLowerCase();
		switch(type){		
		case "javascript":
			adjustData = this._javascript(data);
			break;
		default:
			adjustData = data;
			break;		
		}
		return adjustData;
	},
	
	_jsp : function(){
		
	},
	_javascript : function(data){
		
		//조합 데이터
		let str = "";
		let temp = "";
		
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
		
		
		let ch = data.split("");
		for(let i=0; i<ch.length; i++){
			
			//태그문자 변환
			if(ch[i] === "<"){
				ch[i] = "&lt;";
			}
			
			//종료처리
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
			case "default" :
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='t'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "function":					
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='n'){
					str += "</span>";
					state = "none";
				}				
				break;
				
			case "typeof":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='f'){
					str += "</span>";
					state = "none";
				}				
				break;				
			case "true":
			case "else":
			case "case":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='e'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "if":				
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='f'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "in":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='n'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "break":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='k'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "switch":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='h'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "let":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='t'){
					str += "</span>";
					state = "none";
				}				
				break;
				
			case "return":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='n'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "null":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='l'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "undefined":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='d'){
					str += "</span>";
					state = "none";
				}
			case "var":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='r'){
					str += "</span>";
					state = "none";
				}
			case "false":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='e'){
					str += "</span>";
					state = "none";
				}
			
			}
			
			//시작처리
			if(state === "none"){				
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
							str += "<span class='js-comment'>";
							state = "/*";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1]==='/') {
						if("/*" !== state) {
							str += "<span class='js-comment'>";
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
							str += "<span class='js-text'>";
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
							str += "<span class='js-text'>";
							state = "'";
						}
					}
				break;
				//break
				case 'b':						
					if(ch.length-1 < i+5) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("break" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+5 && ch[i+1]=='r' && ch[i+2]=='e' && ch[i+3]=='a' && ch[i+4]=='k' && this._spCharCheck(ch[i+5])) {					
						str += "<span class='js-directive'>";
						state = "break";
					}
					break;
				//case
				case 'c':						
					if(ch.length-1 < i+4) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("case" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+4 && ch[i+1]=='a' && ch[i+2]=='s' && ch[i+3]=='e' && this._spCharCheck(ch[i+4])) {					
						str += "<span class='js-directive'>";
						state = "else";
					}
					break;
				//default
				case 'd':						
					if(ch.length-1 < i+7) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("default" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+7 && ch[i+1]=='e' && ch[i+2]=='f' && ch[i+3]=='a' && ch[i+4]=='u' && ch[i+5]=='l'
							&& ch[i+6]=='t' && this._spCharCheck(ch[i+7])) {					
						str += "<span class='js-directive'>";
						state = "default";
					}
					break;
				//else
				case 'e':						
					if(ch.length-1 < i+4) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("else" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+4 && ch[i+1]=='l' && ch[i+2]=='s' && ch[i+3]=='e' && this._spCharCheck(ch[i+4])) {					
						str += "<span class='js-directive'>";
						state = "else";
					}
					break;
				//function, false
				case 'f':
					//function
					if(ch.length-1 >= i+1 && ch[i+1]=='u'){
						if(ch.length-1 < i+8) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("function" === temp) {
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+8 && ch[i+1]=='u' && ch[i+2]=='n' && ch[i+3]=='c' && 
							ch[i+4]=='t' && ch[i+5]=='i' && ch[i+6]=='o' && ch[i+7]=='n' && this._spCharCheck(ch[i+8])) {					
							str += "<span class='js-directive'>";
							state = "function";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1]=='a'){
						if(ch.length-1 < i+5) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("false" === temp) {
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+8 && ch[i+1]=='a' && ch[i+2]=='l' && ch[i+3]=='s' && 
								ch[i+4]=='e' && this._spCharCheck(ch[i+5])) {					
							str += "<span class='js-directive'>";
							state = "false";
						}
					}						
					break;
				//if
				case 'i':						
					if(ch.length-1 < i+2) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("if" === temp || "in" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp = "";
					}else if(ch.length-1 >= i+2 && ch[i+1]=='f' && this._spCharCheck(ch[i+2])) {					
						str += "<span class='js-directive'>";
						state = "if";
					}else if(ch.length-1 >= i+2 && ch[i+1]=='n' && this._spCharCheck(ch[i+2])) {					
						str += "<span class='js-directive'>";
						state = "in";
					}
					break;
				//let
				case 'l':						
					if(ch.length-1 < i+3) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("let" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+3 && ch[i+1]=='e' && ch[i+2]=='t' && this._spCharCheck(ch[i+3])) {					
						str += "<span class='js-directive'>";
						state = "let";
					}
					break;
				//null
				case 'n':					
					console.log(ch[i]);
					if(ch.length-1 < i+4) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("null" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+4 && ch[i+1]=='u' && ch[i+2]=='l' && ch[i+3]=='l' && this._spCharCheck(ch[i+4])) {					
						str += "<span class='js-directive'>";
						state = "null";
					}
					break;
				//return
				case 'r':						
					if(ch.length-1 < i+6) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("return" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+6 && ch[i+1]=='e' && ch[i+2]=='t' && ch[i+3]=='u' && ch[i+4]=='r' && ch[i+5]=='n' 
							&& this._spCharCheck(ch[i+6])) {					
						str += "<span class='js-directive'>";
						state = "return";
					}
					break;
				//switch
				case 's':						
					if(ch.length-1 < i+6) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("switch" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+6 && ch[i+1]=='w' && ch[i+2]=='i' && ch[i+3]=='t' && ch[i+4]=='c' && ch[i+5]=='h' && this._spCharCheck(ch[i+6])) {					
						str += "<span class='js-directive'>";
						state = "switch";
					}
					break;
				//true, typeof
				case 't':
					//true
					if(ch.length-1 >= i+1 && ch[i+1] == 'r'){
						if(ch.length-1 < i+4) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("true" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+4 && ch[i+1]=='r' && ch[i+2]=='u' && ch[i+3]=='e' && this._spCharCheck(ch[i+4])) {					
							str += "<span class='js-directive'>";
							state = "true";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1] === 'y'){
						//typeof
						if(ch.length-1 < i+6) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("typeof" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+5 && ch[i+1]=='y' && ch[i+2]=='p' && ch[i+3]=='e' && ch[i+4]=='o' && ch[i+5]=='f' && this._spCharCheck(ch[i+6])) {					
							str += "<span class='js-directive'>";
							state = "typeof";
						}
					}					
					break;				
				//undefined
				case 'u':						
					if(ch.length-1 < i+9) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("undefined" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+9 && ch[i+1]=='n' && ch[i+2]=='d' && ch[i+3]=='e' && ch[i+4]=='f' && ch[i+5]=='i' && 
							ch[i+6]=='n' && ch[i+7]=='e' && ch[i+8]=='d' && this._spCharCheck(ch[i+9])) {					
						str += "<span class='js-directive'>";
						state = "undefined";
					}
					break;
				//var
				case 'v':						
					if(ch.length-1 < i+3) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("var" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+9 && ch[i+1]=='a' && ch[i+2]=='r' && this._spCharCheck(ch[i+3])) {					
						str += "<span class='js-directive'>";
						state = "var";
					}
					break;
					
					//throw new for continue try catch finally while delete
					
				}			
			}
			str += ch[i];
		}
		
		if("end" === state) {				
			str += "</span>";
			state = "none";
		}
		return str;
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