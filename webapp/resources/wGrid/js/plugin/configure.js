/**
 * wGrid 초기생성, 초기화때 사용하는 클래스
 * @author JeHoon
 * @version 0.0.1
 */
export class _configure{
	constructor(root, option){
		
		//근본 클래스
		this.root = root;		
		
		//option default 값
		this.option = {
			//페이징
			isPaging : false, //페이징 여부
			pageCount : 5, //페이지 개수
			pageSize : 10, //목록 수			
			
			//그리드내 데이터 수정시 내부값 바인딩			
			isDataSync : true,
			//그리드내 데이터 수정시 색상변경
			isColorSync : false	
		}
		
		//옵션값 적용
		for(let key in option) {
			if (option.hasOwnProperty(key)) {
				this.option[key] = option[key];
			}
		}	
	}
	
	//옵션값 가져오기
	getOption(selector){
		if(this.root._utils.isEmpty(selector)){
			return this.option;
		}else{
			return this.option[selector];
		}
	}
	
	//페이징 옵션값 가져오기
	getPagingOption(){
		return {
			isPaging : this.option.isPaging,
			pageCount : this.pageCount,
			pageSize : this.pageSize
		}
	}
}