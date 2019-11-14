/**
 * wGrid 컨트롤 클래스
 * @author JeHoon
 * @version 0.0.1
 */
export class _controller{
	constructor(root, control){
		
		//근본 클래스
		this.root = root;
		
		this._control = control;
		
	}
	
	//조회
	_load(){		
		this._control.load().than(result => {
			
		});
	}
	
	//수정
	_edit(){
		this._control.edit().than(result => {
			
		});
	}
	
	//저장
	_save(){
		this._control.save().than(result => {
			
		});
	}
	
	//삭제
	_remove(){		
		this._control.remove().than(result => {
			
		});
	}
	
	//적용(수정, 저장, 삭제)
	_remove(){		
		this._control.apply().than(result => {
			
		});
	}
	
	
	
	
	
	
}