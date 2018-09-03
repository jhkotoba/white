/**
 * @author jeHoon
 */
let wVali = {
	_clause : ["empty"],
	clause : function(clause){
		
		//체크구분 list로 변환
		if(clause === null || clause === "" || clause === undefined){
			clause = ["empty"];
		}else if(typeof clause === "string"){
			clause = [clause];
		}else if(typeof clause === "object" && clause.length === undefined){			
			let keys = Object.keys(clause);	let temp = [];
			for(let i=0; i<keys.length; i++) push(keys[i]);
			clause = temp;
		}	
		this._clause = clause;
		return this;
	},
	_exclude : new Set(),		
	exclude : function(exclude){
		
		//제외값 set으로 변환		
		let set = new Set();
		
		if(exclude === null || exclude === "" || exclude === undefined){		
		}else if(typeof item.exclude === "string"){
			exclude = set.add(exclude);
		}else if(typeof exclude === "object" && exclude.length === undefined){			
			let keys = Object.keys(exclude);
			for(let i=0; i<keys.length; i++) set.add(keys[i]);	
		}else{
			for(let i=0; i<exclude.length; i++) set.add(exclude[i]);
		}
		
		this.exclude = set;
		return this;
	},
	_parent : "",
	parent : function(parent){
		
		//부모id 체크
		if(parent === null || parent === undefined || parent === "#") parent = "";
		else if(parent.substring(1, parent.length) !== "#") parent = "#"+parent;
		
		this._parent = parent;		
		return this;
	},
	check : function(param, isDefault){
		
		if(isDefault === undefined || isDefault === false) this.init();
		
		//유효성 검사
		let result = {};		
		let keys = Object.keys(param);		
		for(let i=0; i<keys.length; i++){
			if(!this._exclude.has(keys[i])){
				for(let j=0; j<this._clause.length; j++){
					switch(this._clause[j]){					
					case "empty":
						if(param[keys[i]].replace(/^\s+|\s+$/g,"") === "" || param[keys[i]] === null || param[keys[i]] === undefined){
							return this.alert({parent: this._parent, id: "#"+keys[i], cause: this._clause[j], 
								msg: $(this._parent+" #"+keys[i])[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."});
						}
						break;
					case "maxLen":
						let maxLen = $(this._parent+" #"+keys[i]).attr("maxlength");
						if(maxLen !== undefined){
							if($(this._parent+" #"+keys[i]).val().length > maxLen){
								return this.alert({parent: this._parent, id: "#"+keys[i], cause: this._clause[j], msg: "글자수가 많습니다. <br> (최대글자수: "+maxLen+")"});								 
							} 
						}
						break;
					case "number":
						break;
					case "money":
						break;
					case "email":
						break;
					case "phone":
						break;
					case "krText":
						break;
					case "enText":
						break;
					case "datetime":
						break;
					case "date":
						break;
					case "time":
						break;
					}
				}			
			}		
		}
		return true;
	},	
	alert : function(item){
		let target = $(item.parent +" "+item.id);
		$(target).addClass("wVali-border").focus();	
		
		$("body").append("<div id='wValiAlert' class='wVali-alert'>"+item.msg+"</div>");
		let offset = $(target).offset();
		$("#wValiAlert").offset({top: offset.top-42, left: offset.left});		
		
		$(target).on("focusout", function(){
			$(target).removeClass("wVali-border").off("focusout");
			$("#wValiAlert").remove();
		});
		return false;
	},
	init : function(){
		this._clause = ["empty"];
		this._exclude = new Set();
		this._parent = "";
		return this;
	}
	
}