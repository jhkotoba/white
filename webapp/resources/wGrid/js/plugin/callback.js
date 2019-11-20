/**
 * wGrid 콜백 클래스
 * @author JeHoon
 * @version 0.0.1
 */
export class _callback{
	constructor(root, callback){
		
		//콜백 설정을 하지 않을 경우 빈 콜백함수 저장
		if(root.util.isEmpty(callback)){
			this.initDataConvert = root.util.emptyFn;
			this.initedDataConvert = root.util.emptyFn;
		}else{
			//데이터 원본 함수(콜백) 호출 //_repository
			this.initDataConvert = root.isFnRtnFn(callback.initDataConvert);
			//데이터 옵션가공된 상태에서 함수(콜백) 호출 //_repository
			this.initedDataConvert = root.isFnRtnFn(callback.initedDataConvert);
		}
	}
}