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
	}
}