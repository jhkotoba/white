/**
 * @author jeHoon
 */
let wVali = {
	_checkItem : ["empty"],
	checkItem : function(checkItem){
		
		//체크구분 list로 변환
		if(checkItem === null || checkItem === "" || checkItem === undefined){
			checkItem = ["empty"];
		}else if(typeof checkItem === "string"){
			checkItem = [checkItem];
		}else if(typeof checkItem === "object" && checkItem.length === undefined){			
			let keys = Object.keys(checkItem);	let temp = [];
			for(let i=0; i<keys.length; i++) push(keys[i]);
			checkItem = temp;
		}	
		this._checkItem = checkItem;
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
		
		let result = {};		
		let keys = Object.keys(param);
		
		//key수 만큼 유효성 검사
		for(let i=0; i<keys.length; i++){
			if(!this._exclude.has(keys[i])){				
				for(let j=0; j<this._checkItem.length; j++){
					switch(this._checkItem[j]){					
					case "empty":
						if(param[keys[i]].replace(/^\s+|\s+$/g,"") === "" || param[keys[i]] === null || param[keys[i]] === undefined){
							return this.alert({
								/*parent: this._parent,
								id: "#"+keys[i],*/
								element: $(this._parent + " " + "#"+keys[i]),
								checkItem: this._checkItem[j], 
								msg: $(this._parent+" #"+keys[i])[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."});
						}
						break;
					case "maxLen":
						let maxLen = $(this._parent+" #"+keys[i]).attr("maxlength");
						if(maxLen !== undefined){
							if($(this._parent+" #"+keys[i]).val().length > maxLen){
								return this.alert({
										/*parent: this._parent, 
										id: "#"+keys[i],*/
										element: $(this._parent + " " + "#"+keys[i]),
										checkItem: this._checkItem[j],
										msg: "글자수가 많습니다. <br> (최대글자수: "+maxLen+")"
										});								 
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
		let $target = item.element;		
		//let target = $(item.parent +" "+item.id);
		
		$target.addClass("wVali-border").focus();	
		
		$("body").append($("<div>").attr("id", "wValiAlert").addClass("wVali-alert").text(item.msg));
		let offset = $target.offset();
		$("#wValiAlert").offset({top: offset.top-42, left: offset.left});		
		
		$target.on("focusout", function(){
			$target.removeClass("wVali-border").off("focusout");
			$("#wValiAlert").remove();
		});
		return false;
	},
	init : function(){
		this._checkItem = ["empty"];
		this._exclude = new Set();
		this._parent = "";
		return this;
	}
	
}