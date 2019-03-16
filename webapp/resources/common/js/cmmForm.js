/**
 * 폼관련 공통
 */

//form clear
$.fn.clear = function() {
	return this.each(function() {
		let type = this.type, tag = this.tagName.toLowerCase();
		if (tag === 'form'){
			return $(':input',this).clear();
		}
		if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
			this.value = '';
		}else if (type === 'checkbox' || type === 'radio'){
			this.checked = false;
			this.value = '';
		}else if (tag === 'select'){
			this.selectedIndex = 0;
		}else if(tag === "span"){
			$(this).text("");
		}else if(tag === "label"){
			$(this).text("");
		}
		$(this).removeData();
    });
};

//form getParam
$.fn.getParam = function() {
	let param = {};	
	this.find("*").each(function(){
		if(this.value !== undefined){
			let type = this.type, tag = this.tagName.toLowerCase();			
			if(type === "text" || type === "password" || type === "hidden" || tag === "textarea"){
				param[this.id] = this.value;
			}else if(tag === "select"){
				param[this.id] = this.value;
			}else if (type === 'checkbox'){
				
			}else if(type === 'radio'){
				
			}
		}		
	});
	return param;	
};

//form setParam
$.fn.setParam = function(param){
	this.find("*").each(function(){
		if(param[this.id] !== undefined){
			let type = this.type, tag = this.tagName.toLowerCase();
			if(type === "text" || type === "password" || type === "hidden" || tag === "textarea"){
				this.value = param[this.id];
			}else if(tag === "select"){
				$(this).val(param[this.id]).prop("selected", true);			
			}else if (type === 'checkbox'){
				$(this).prop("checked", true).val(param[this.id]);
			}else if(type === 'radio'){				
			
			}else if(tag === "span"){
				$(this).text(param[this.id]);
			}else if(tag === "label"){
				$(this).text(param[this.id]);
			}
		}		
	});
	return this;
}