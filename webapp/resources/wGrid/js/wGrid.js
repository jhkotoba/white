//유틸함수
import { _utils } from './plugin/utils.js';
//콜백 클래스
import { _callback } from './plugin/callback.js';
//옵션 설정 클래스
import { _configure } from './plugin/configure.js';
//필드 정보 클래스
import { _fields } from './plugin/fields.js';
//데이터 클래스
import { _repository } from './plugin/repository.js';
//생성 클래스
import { _creator } from './plugin/creator.js';
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
		this.util = _utils;
		
		//콜백 클래스
		this._callback = new _callback(this, args.callback);
		
		//옵션 설정 클래스
		this._config = new _configure(this, args.option);
		
		//옵션 설정 클래스
		this._fields = new _fields(this, args.fields);		
				
		//data 클래스		
		this._data = null;
		
		//생성클래스
		this._creator = new _creator(this);
		
		//컨트롤러
		this._controller = new _controller(this, args.controller);		
		
		return this;
	}	
	
	//그리드 생성
	createGird(){
		this._creator.createGrid();
		return this;
	}
	
	//옵션
	getOption(){
		return this._config.getOption();		
	}	
	
	//데이터 주입
	setData(data){
		this._data = new _repository(this, data);
		return this;
	}
	
	//데이터 가져오기
	getData(){
		return this._data.getData();
	}
};
window.wGrid = wGrid;




