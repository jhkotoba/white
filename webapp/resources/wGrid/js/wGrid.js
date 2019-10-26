//유틸함수
import { _utils } from './plugin/utils.js';
//생성 및 초기화 클래스
import { _construct } from './plugin/construct.js';

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
		this._construct = new _construct(args.option);
		
	}
	
	
	
};
window.wGrid = wGrid;




