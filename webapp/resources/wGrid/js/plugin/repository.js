/**
 * wGrid 데이터 관리 클래스
 * @author JeHoon
 * @version 0.0.1
 */
export class _repository{
	constructor(root, data){
		
		//근본 클래스
		this.root = root;		
		
		//데이터 원본 함수(콜백) 호출
		root._callback.initDataConvert(data);
		
		//데이터 옵션에 따라 가공
		
		//데이터 옵션가공된 상태에서 함수(콜백) 호출
		root._callback.initedDataConvert(data);
		
		//클론생성
		this.clone = null;
		
		//데이터
		this.data = null;
	
		
		
		
	}
	
	//데이터 가져오기
	getData(){
		
	}
	
	
}