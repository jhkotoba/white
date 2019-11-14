/**
 * wGrid 콜백 클래스
 * @author JeHoon
 * @version 0.0.1
 */
export class _callback{
	constructor(root, args){		
		//근본 클래스
		this.root = root;
		
		//데이터 원본 함수(콜백) 호출
		this.initDataConvert = args.data.initDataConvert;
		//데이터 원본 함수(콜백) 호출
		this.initedDataConvert = args.data.initedDataConvert;
	}
}