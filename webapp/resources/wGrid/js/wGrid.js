//유틸함수
import { _utils } from './plugin/utils.js';
//생성 및 초기화 클래스
import { _initialize } from './plugin/initialize.js';
//데이터 클래스
import { _repository } from './plugin/repository.js';


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
		this._init = new _initialize(this, args.option);
				
		//data 클래스		
		this._data = null;
		
		//컨트롤러
		this._controller = args.controller;
	}
	
	//그리드 초기화
	ititGrid(){
		
	}
	
	//그리드 생성
	createGird(){
		
	}
	
	//데이터 주입
	setData(data){
		this._data = new _repository(this, data);
	}
	
	
	
};
window.wGrid = wGrid;




