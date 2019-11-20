/**
 * wGrid에서 사용되는 유틸함수
 * @author JeHoon
 * @version 0.0.1
 */
export const _utils = {	
	//빈값 체크
	isEmpty : function(_str){
		return !this.isNotEmpty(_str);
	},
	//!빈값 체크
	isNotEmpty : function(_str){
		let obj = String(_str);
		if(obj == null || obj == undefined || obj == 'null' || obj == 'undefined' || obj == '' ) return false;
		else return true;
	},
	//함수여부
	isFunction : function(fn){
		if(typeof fn === "function"){
			return true;
		}else{
			return false;
		}
	},
	//함수 체크후 함수면 리턴 아니면 빈 함수 리턴	
	isFnRtnFn : function(fn){
		if(this.isFunction(fn)){
			return fn;
		}else{
			return this.emptyFn;
		}
	},
	//빈 함수
	emptyFn : function(){},
	
}