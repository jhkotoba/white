/**
 *  공통 이벤트
 */
//################## 공통 keyup 이벤트 #####################
document.addEventListener("keyup", event => {	
	event.target.classList.forEach(className => {
		let value = [];
		switch(className){
		//금액 입력란 설정
		case "only-currency" :
			value[0] = event.target.value;
			value[1] = value[0].replace(/\D/g,"");			
			value[2] = String(value[1]);
			while (/(\d+)(\d{3})/.test(value[2])) {
				value[2] = value[2].replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
			}
			event.target.value = value[2];
			break;
		}
		value = null;
	});
});


/*//통화 입력 - 숫제만
function _getNumber(obj){	
	let num01;
	let num02;
	num01 = obj.value;
	num02 = num01.replace(/\D/g,"");
	num01 = _setComma(num02);
	obj.value =  num01;
}
//통화 입력 - 콤마추가
function _setComma(inNum){     
	let outNum;
	outNum = String(inNum); 
	while (/(\d+)(\d{3})/.test(outNum)) {
		outNum = outNum.replace(/(\d+)(\d{3})/, '$1' + ',' + '$2');
	}
	return outNum;
}*/