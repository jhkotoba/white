/**
 *  공통 이벤트
 */
//################## 공통 change 이벤트 #####################
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
				value[2] = value[2].replace(/(^0+)/, "");
			}
			event.target.value = value[2];
			break;
		}
		value = null;
	});
});