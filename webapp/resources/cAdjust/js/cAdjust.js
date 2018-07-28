/**
 * @author JeHoon
 * 
 */

let cAdjust = {
	
	adjust : function(type, data){
		let adjustData;
		
		type = type.replace(/^\s+|\s+$/g,"").toLowerCase();
		switch(type){		
		case "javascript":	case "jquery":	case "jsgrid":
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
				break;
			case "var":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='r'){
					str += "</span>";
					state = "none";
				}
				break;
			case "false":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='e'){
					str += "</span>";
					state = "none";
				}
				break;
			case "throw":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='w'){
					str += "</span>";
					state = "none";
				}
				break;
			case "new":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='w'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "continue":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='e'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "finally":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='y'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "delete":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='e'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "while":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='e'){
					str += "</span>";
					state = "none";
				}				
				break;
			case "catch":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='h'){
					str += "</span>";
					state = "none";
				}
				break;
			case "try":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='y'){
					str += "</span>";
					state = "none";
				}
				break;
			case "for":
				if(ch.length-1 > i+1 && this._spCharCheck(ch[i]) && ch[i-1]=='r'){
					str += "</span>";
					state = "none";
				}
				break;
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
				//case, continue, catch
				case 'c':	
					if(ch.length-1 >= i+2 && ch[i+1]=='a' && ch[i+2]=='s'){
						//case
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
							state = "case";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1]=='o'){
						//continue
						if(ch.length-1 < i+8) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("continue" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp === "";						
						}else if(ch.length-1 >= i+8 && ch[i+1]=='o' && ch[i+2]=='n' && ch[i+3]=='t' && 
								ch[i+4]=='i' && ch[i+5]=='n' && ch[i+6]=='u' && ch[i+7]=='e' && this._spCharCheck(ch[i+8])) {					
							str += "<span class='js-directive'>";
							state = "continue";
						}
					}else if(ch.length-1 >= i+2 && ch[i+1]=='a' && ch[i+2]=='t'){
						
						//catch
						if(ch.length-1 < i+5) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("catch" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp === "";						
						}else if(ch.length-1 >= i+5 && ch[i+1]=='a' && ch[i+2]=='t' && ch[i+3]=='c' && ch[i+4]=='h' && this._spCharCheck(ch[i+5])) {					
							str += "<span class='js-directive'>";
							state = "catch";
						}
					}
					break;
				//default, delete
				case 'd':
					if(ch.length-1 >= i+2 && ch[i+1]=='e' && ch[i+2]=='f'){
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
					}else if(ch.length-1 >= i+1 && ch[i+1]=='e' && ch[i+2]=='l'){
						if(ch.length-1 < i+7) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("delete" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp === "";						
						}else if(ch.length-1 >= i+6 && ch[i+1]=='e' && ch[i+2]=='l' && ch[i+3]=='e' && ch[i+4]=='t' && ch[i+5]=='e'
								&& this._spCharCheck(ch[i+6])) {					
							str += "<span class='js-directive'>";
							state = "delete";
						}
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
				//function, false, for, finally
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
						//false
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
					}else if(ch.length-1 >= i+1 && ch[i+1]=='o'){
						//for
						if(ch.length-1 < i+3) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("for" === temp) {
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+3 && ch[i+1]=='o' && ch[i+2]=='r' && this._spCharCheck(ch[i+3])) {					
							str += "<span class='js-directive'>";
							state = "for";
						}
					}else if(ch.length-1 >= i+1 && ch[i+1]=='i'){
						//finally
						if(ch.length-1 < i+7) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("finally" === temp) {
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+7 && ch[i+1]=='i' && ch[i+2]=='n' && ch[i+3]=='a' && ch[i+4]=='l' 
								&& ch[i+5]=='l' && ch[i+6]=='y' && this._spCharCheck(ch[i+7])) {					
							str += "<span class='js-directive'>";
							state = "finally";
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
				//null, new
				case 'n':
					if(ch.length-1 >= i+1 && ch[i+1] == 'u'){
						//null
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
					}else if(ch.length-1 >= i+1 && ch[i+1] == 'e'){
						//new
						if(ch.length-1 < i+3) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("new" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp === "";						
						}else if(ch.length-1 >= i+3 && ch[i+1]=='e' && ch[i+2]=='w' && this._spCharCheck(ch[i+3])) {					
							str += "<span class='js-directive'>";
							state = "new";
						}
						
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
				//true, typeof, throw, try
				case 't':
					//true, try
					if(ch.length-1 >= i+1 && ch[i+1] == 'r'){
						//true
						if(ch.length-1 >= i+2 && ch[i+2] == 'u'){
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
						//try
						}else if(ch.length-1 >= i+2 && ch[i+2] == 'y'){
							if(ch.length-1 < i+3) {
								for(let j=i; j<ch.length; j++) {
									temp += ch[j];
								}
								if("try" === temp) {								
									str += "<span class='js-directive'>";
									state = "end";
								}
								temp = "";
							}else if(ch.length-1 >= i+3 && ch[i+1]=='r' && ch[i+2]=='y' && this._spCharCheck(ch[i+3])) {					
								str += "<span class='js-directive'>";
								state = "try";
							}
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
					}else if(ch.length-1 >= i+1 && ch[i+1] === 'h'){
						//throw
						if(ch.length-1 < i+5) {
							for(let j=i; j<ch.length; j++) {
								temp += ch[j];
							}
							if("throw" === temp) {								
								str += "<span class='js-directive'>";
								state = "end";
							}
							temp = "";
						}else if(ch.length-1 >= i+5 && ch[i+1]=='h' && ch[i+2]=='r' && ch[i+3]=='o' && ch[i+4]=='w' && this._spCharCheck(ch[i+5])) {					
							str += "<span class='js-directive'>";
							state = "throw";
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
				case 'w':
					//while
					if(ch.length-1 < i+5) {
						for(let j=i; j<ch.length; j++) {
							temp += ch[j];
						}
						if("while" === temp) {								
							str += "<span class='js-directive'>";
							state = "end";
						}
						temp === "";						
					}else if(ch.length-1 >= i+5 && ch[i+1]=='h' && ch[i+2]=='i' && ch[i+3]=='l' && ch[i+4]=='e' && this._spCharCheck(ch[i+5])) {					
						str += "<span class='js-directive'>";
						state = "while";
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
					}else if(ch.length-1 >= i+3 && ch[i+1]=='a' && ch[i+2]=='r' && this._spCharCheck(ch[i+3])) {					
						str += "<span class='js-directive'>";
						state = "var";
					}
					break;					
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