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
			//페이징 여부
			isPaging : false,
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
	
	getOption(){
		return this.option;
	}
}