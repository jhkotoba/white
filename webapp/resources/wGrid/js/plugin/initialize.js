/**
 * wGrid 초기생성, 초기화때 사용하는 클래스
 * @author JeHoon
 * @version 0.0.1
 */
export class _initialize{
	constructor(root, option){
		
		this.root = root;		
		
		//option default 값
		this.option = {
			//페이징 여부
			isPaging : false,
			//화면 수정시 내부값 바인딩			
			isDataSync : true,
			//그리드 수정시 색상변경
			isColorSync : false,
			
				
				
				
				
		}
		
		
	}
	
	getOption(){
		return this.option;
	}
	
	isPaging(){
		this.option.isPaging;
	}
	
	isDataSync(){
		this.option.isDataSync;
	}
	
	isColorSync(){
		this.option.isColorSync;
	}
}