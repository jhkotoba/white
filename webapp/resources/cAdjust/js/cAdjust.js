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
			break;		
		}	
		
		console.log(adjustData);
		return adjustData;
	},
	
	_jsp : function(){
		
	},
	_javascript : function(data){
		
		//조합 데이터
		let str = "";
		
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
			console.log(str);
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
			case "\"":
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
			case "\'":
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
				//function
				/*case 'f':						
					if(ch.length-1 < i+8) {
						for(let j=i; j<ch.length; j++) {
							temp.append(ch[j]);
						}
						if("function".equals(temp.toString())) {								
							str.append(this.blue);
							state = "end";
						}
						temp.setLength(0);
					}else if(ch.length-1 >= i+8 && ch[i+1]=='u' && ch[i+2]=='n' && ch[i+3]=='c' && 
						ch[i+4]=='t' && ch[i+5]=='i' && ch[i+6]=='o' && ch[i+7]=='n' && this.spCharCheck(ch[i+8])) {					
						str.append(this.blue);
						state = "function";
					}
					break;*/	
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
		
	}
}