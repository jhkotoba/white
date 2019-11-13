//유틸함수
import { _utils } from './plugin/utils.js';
//생성 및 초기화 클래스
import { _configure } from './plugin/configure.js';
//데이터 클래스
import { _repository } from './plugin/repository.js';
//컨트롤러 클래스
import { _controller } from './plugin/controller.js';


/**
 * wGrid 기본객체
 * @author JeHoon 
 * @version 0.1.0
 */
class wGrid{	
	constructor(targetId, args){
		
		//타겟 ID
		this._id = targetId;
		
		//타겟 셀럭터
		this._targetId = document.getElementById(this.id);
		
		//유틸함수 저장(연결)
		this._utils = _utils;		
		
		//초기 셋팅클래스
		this._config = new _configure(this, args.option);
				
		//data 클래스		
		this._data = null;
		
		//컨트롤러
		this._controller = new _controller(args.controller);
		
		return this;
	}	
	
	//그리드 생성
	createGird(){
		
	}
	
	//옵션
	getOption(){
		return this._config.getOption();		
	}
	
	//데이터 주입
	setData(data){
		this._data = new _repository(this, data);
	}
	
	
	
};
window.wGrid = wGrid;




