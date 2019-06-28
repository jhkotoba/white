<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	$("#searchBar #startDate").val(isDate.firstDay());
	$("#searchBar #endDate").val(isDate.lastDay());	
	cfnCmmAjax("/ledger/selectPurBankList").done(ledgerList);
});

function ledgerList(data){
	let $option = null;
	let purMap = {};
	let purDtlMap = {};
	let bankMap = {};
	let cloneList = null;
	
	let purLp = {};
	for(let i=0; i<data.purList.length; i++){
		purLp[data.purList[i].purSeq] = data.purList[i].purType;
	}
	
	//목적
	for(let i=0; i<data.purList.length; i++){
		$option = $("<option>").val(data.purList[i].purSeq)
			.text(data.purList[i].purpose)
			.data("purType", data.purList[i].purType);		
		$("#searchBar #purSeq").append($option);
		
		//seq값 목적명 맵 생성
		purMap[data.purList[i].purSeq] = data.purList[i].purpose;
	}
	
	//상세목적seq 맵 생성
	for(let i=0; i<data.purDtlList.length; i++){
		purDtlMap[data.purDtlList[i].purDtlSeq] = data.purDtlList[i].purDetail;
	}
	
	//목적-상세목적
	$("#searchBar #purSeq").on("change", function(e){
		$("#purDtlSeq").empty();
		$("#searchBar #purDtlSeq").append($("<option>").val("").text(""));
		for(let i=0; i<data.purDtlList.length; i++){
			if(Number(data.purDtlList[i].purSeq) === Number(this.value)){
				$option = $("<option>").val(data.purDtlList[i].purDtlSeq)
					.text(data.purDtlList[i].purDetail);		
				$("#searchBar #purDtlSeq").append($option);
			}
		}
	});
	
	//사용수단
	for(let i=0; i<data.bankList.length; i++){
		$option = $("<option>").val(data.bankList[i].bankSeq)
			.text(data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")");					
		$("#searchBar #bankSeq").append($option);
		
		//은행seq 맵 생성
		bankMap[data.bankList[i].bankSeq] = data.bankList[i].bankName+"("+data.bankList[i].bankAccount+")";
	}
	
	//조회버튼
	$("#search").off().on("click", function(){
		let param = {};			
		param.startDate = $("#searchBar #startDate").val();
		param.endDate = $("#searchBar #endDate").val();
		param.purSeq = $("#searchBar #purSeq").val();
		param.purDtlSeq = $("#searchBar #purDtlSeq").val();
		param.bankSeq = $("#searchBar #bankSeq").val();
		param.searchType = "edit";
		
		if(!isDatePattern(param.startDate, "yyyy-MM-dd")){			
			wVali.alert({element : $("#searchBar #startDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		if(!isDatePattern(param.endDate, "yyyy-MM-dd")){			
			wVali.alert({element : $("#searchBar #endDate"), msg: "ex)2019-01-01의 형식으로 입력할 수 있습니다."});
			return;
		}
		
		param.startDate = param.startDate + " 00:00";
		param.endDate = param.endDate + " 23:59";
		
		cfnCmmAjax("/ledger/selectRecordList", param).done(function(data){			
			//데이터 초기 세팅
			for(let i=0; i<data.length; i++){
				data[i].type = "select";
				data[i].money = cfnSetComma(Math.abs(data[i].money));
			}
			
			//편집리스트 생성
			cloneList = common.clone(data);
			fnCreateLedgerEditList(common.clone(data));
			
			//초기화 버튼
			$("#btns #cancel").off().on("click", function(){
				fnCreateLedgerEditList(common.clone(data));
			});
		});
	}).trigger("click");
	
	//가계부 리스트 생성
	function fnCreateLedgerEditList(list){
		$("#ledgerList").empty();		
		
		//저장버튼 이벤트
		$("#btns #save").off().on("click", function(){
			
			let name = null;
			let isVali = true;
			$("[name^='sync']").each(function(i, e){
				if($(e).data("name") !== "purDtlSeq" && $(e).data("name") !== "position"){
					if(isEmpty($(e).val())){
						isVali = false;
						wVali.alert({element : $(e), msg: $(e)[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."}); return false;
					}
				}
				
				switch($(e).data("name")){
				case "recordDate":
					if(!isDatePattern($(e).val(), "yyyy-MM-dd HH:mm")){
						isVali = false;
						wVali.alert({element : $(e), msg: "ex)2019-01-01 08:00의 형식으로 입력할 수 있습니다."}); return false;
					}
					break;
				case "position" :
					if($(e).val().length > 20){
						isVali = false;
						wVali.alert({element : $(e), msg: "최대 글자수 20자 까지 입력할 수 있습니다."}); return false;
					}
					break;
				case "content" :
					if($(e).val().length > 50){
						isVali = false;
						wVali.alert({element : $(e), msg: "최대 글자수 50자 까지 입력할 수 있습니다."}); return false;
					}
					break;
				case "money" :
					if(!isOnlyNum($(e).val().replace(/,/gi, ""))){
						isVali = false;
						wVali.alert({element : $(e), msg: "숫자를 입력해 주세요."}); return false;
					}
					break;
				case "bankSeq" :
					if(String($(e).val()) === String($($(e)[0]).next().val())){
						isVali = false;
						wVali.alert({element : $(e), msg: "보내는 곳과 받는곳이 일치합니다."}); return false;
					}
					break;
				}
			});
		
			let updateList = new Array();
			let deleteList = new Array();
			
			if(isVali && confirm("수정한 내용을 저장 하시겠습니까?")){	
				for(let i=0; i<list.length; i++){
					switch(list[i].type){
					case "delete":
						deleteList.push(common.clone(list[i])); 
						break;
					case "update": 
						updateList.push(common.clone(list[i]));
						break;
					}
				}
				
				if(deleteList.length === 0 && updateList.length === 0){
					alert("수정 및 삭제할 내용이 없습니다.");
					updateList = null;
					deleteList = null;
					return;
				}
				
				for(let i=0; i<deleteList.length; i++){
					deleteList[i].money =  deleteList[i].money.replace(/,/gi, "");
					switch(purLp[deleteList[i].purSeq]){
					case "LED001":
						deleteList[i].money = Number(deleteList[i].money);
						break;
					case "LED002":
					case "LED003":
						deleteList[i].money = Number("-"+deleteList[i].money);				
						break;
					}
				}	
				for(let i=0; i<updateList.length; i++){
					updateList[i].money =  updateList[i].money.replace(/,/gi, "");
					switch(purLp[updateList[i].purSeq]){
					case "LED001":
						updateList[i].money = Number(updateList[i].money);
						break;
					case "LED002":
					case "LED003":
						updateList[i].money = Number("-"+updateList[i].money);
						break;
					}
				}
				
				let param = {};
				param.updateList = JSON.stringify(updateList);
				param.deleteList = JSON.stringify(deleteList);
				
				cfnCmmAjax("/ledger/applyRecordList", param).done(function(data){
					if(isEmpty(data.updateCnt) && isEmpty(data.deleteCnt)){
						alert("데이터 수정에 실패하였습니다");
					}else{
						let msg = "";
						if(isEmpty(data.updateCnt)){
							msg = data.deleteCnt + "개의 데이터가 삭제 되었습니다.";
						}else if(isEmpty(data.deleteCnt)){
							msg = data.updateCnt + "개의 데이터가 수정 되었습니다.";
						}else{
							msg = data.updateCnt + "개의 데이터가 수정, " + data.deleteCnt + "개의 데이터가 삭제 되었습니다.";
						}
						
						alert(msg);
						$("#search").trigger("click");
					}
				});
			}
		});
		
		let fieldList = [
			{title : "",		name:"", width : "3%",
				itemTemplate: function(item, idx){
					return $("<button>")
					.addClass("btn-gray trs")
					.text("-")
					.on("click", function(){
						switch(item.type){
						case "select": 
						case "update": 
							item.type = "delete";
							$("[name='sync"+idx+"']").addClass("sync-red").prop("disabled", true);
							break;
						case "delete":
							fnCompareData(null, item, idx) ? item.type = "select" : item.type = "update";							
							$("[name='sync"+idx+"']").removeClass("sync-red").prop("disabled", false);
							break;
						}
					});
				}
			},
			{title: "날짜", 		name: "recordDate", width: "10%",
				itemTemplate: function(item, idx){
					return fnCreateInput(item, idx, "recordDate");
				}
			},
			{title: "위치", 		name: "position", 	width: "16%",
				itemTemplate: function(item, idx){
					return fnCreateInput(item, idx, "position");
				}
			},
			{title: "내용", 		name: "content", 	width: "18%",
				itemTemplate: function(item, idx){
					return fnCreateInput(item, idx, "content");
				}
			},
			{title: "목적", 		name: "purSeq", 	width: "11%",
				itemTemplate: function(item, idx){					
					return fnCreatePurSelect(item, idx, "purSeq")
					.on("change", function(){
						
						//상세목적 셀렉트박스 변경
						let $option = null;
						let $nextSelect = $($(this).closest("td").next().children().first()[0]).empty();						
						$nextSelect.append($("<option>").val("").text(""));
						for(let i=0; i<data.purDtlList.length; i++){
							if(String(this.value) === String(data.purDtlList[i].purSeq)){
								$option = $("<option>").val(data.purDtlList[i].purDtlSeq).text(data.purDtlList[i].purDetail);								
								$nextSelect.append($option);								
							}
						}					
				
						//상세목적 셀렉트박스 색상변경						
						if(String(cloneList[idx].purDtlSeq) === ""){
							//no
						}else if(String(cloneList[idx].purDtlSeq) === String($nextSelect.val())){
							$nextSelect.removeClass("sync-blue");
						}else{
							$nextSelect.addClass("sync-blue");
						}				
						
						//수입지출 기호 변경, 목적이 금액이동일 경우 사용수단 변경 아닐경우 원복
						let $bank = $($(this).closest("td").next().next()[0]);
						let $sign = $($(this).closest("td").next().next().next().children().children().first()[0]);
						switch(purLp[this.value]){						
						case "LED001": $sign.text("+"); break;
						case "LED002": $sign.text("-"); break;
						case "LED003": $sign.text(">"); break;
						}
						//item.moveSeq = "";
						$bank.empty().append(fnCreateBankSelect(item, idx));
					});
				}
			},
			{title: "상세목적", 	name: "purDtlSeq", 	width: "11%",
				itemTemplate: function(item, idx){
					return fnCreatePurSelect(item, idx, "purDtlSeq");
				}
			},
			{title: "사용수단", 	name: "bankSeq",	width: "17%",
				itemTemplate: function(item, idx){
					return fnCreateBankSelect(item, idx);
				}
			},
			{title: "수입/지출", 	name: "money", 		width: "10%",
				itemTemplate: function(item, idx){
					return fnCreateMoney(item, idx);
				}
			},
			{title : "통계 표시",	name:"statsYn", 		width : "4%", align:"center",
				itemTemplate: function(item, idx){
					return $("<button>").addClass("btn-gray trs").text(item.statsYn).val(item.statsYn).attr("name","sync"+idx)
						.on("click", function(){
						if($(this).val() === "Y"){ $(this).val("N").text("N"); item.statsYn = this.value; fnTypeSync(this, "statsYn", item, idx);}
						else{ 					   $(this).val("Y").text("Y"); item.statsYn = this.value; fnTypeSync(this, "statsYn", item, idx);}					
					});				
				}
			}
		];
		
		let $header = $("<div>").append(fnCreateHeader());	
		let $tbody = $("<div>").append(fnCreateRow());
		
		$("#ledgerList").append($header).append($tbody);
		
		//해더 생성
		function fnCreateHeader(){
			let $tb = $("<table>").addClass("table-header");
			let $tr = $("<tr>");
			let $th = null;
			
			for(let i=0; i<fieldList.length; i++){
				$th = $("<th>").html(fieldList[i].title).attr("style", "width:"+fieldList[i].width);
				$tr.append($th);				
			}
			$tb.append($tr);
			return $tb;
		}
		
		//새로운 행 생성
		function fnCreateRow(){
			let $tb = $("<table>").addClass("table-body");
			let $tr = null;
			let $td = null;
			let $input = null;
			
			for(let i=list.length-1; i>=0; i--){								
				if(isNotEmpty($("#searchBar #purSeq").val()) && String($("#searchBar #purSeq").val()) !== String(list[i].purSeq)){
					continue;				
				}
				if(isNotEmpty($("#searchBar #purDtlSeq").val()) && String($("#searchBar #purDtlSeq").val()) !== String(list[i].purDtlSeq)){
					continue;				
				}
				if(isNotEmpty($("#searchBar #bankSeq").val()) && String($("#searchBar #bankSeq").val()) !== String(list[i].bankSeq)){
					continue;				
				}
				
				$tr = $("<tr>");
				for(let j=0; j<fieldList.length; j++){
					$td = $("<td>").attr("style", "width:"+fieldList[j].width);					
					$td.append(fieldList[j].itemTemplate(list[i], i));
					$tr.append($td);
				}
				$tb.append($tr);
			}
			return $tb;
		}
	}
	
	//데이터 비교
	function fnCompareData(name, item, idx){
		if(isEmpty(name)){
			if(item.recordDate !== cloneList[idx].recordDate){				
				return false;
			}else if(item.position !== cloneList[idx].position){
				return false;
			}else if(item.content !== cloneList[idx].content){
				return false;
			}else if(String(item.purSeq) !== String(cloneList[idx].purSeq)){
				return false;
			}else if(String(item.purType) !== String(cloneList[idx].purType)){
				return false;	
			}else if(String(item.purDtlSeq) !== String(cloneList[idx].purDtlSeq)){
				return false;
			}else if(String(item.bankSeq) !== String(cloneList[idx].bankSeq)){
				return false;
			}else if(String(item.money).replace(/,/g,"") !== String(cloneList[idx].money).replace(/,/g,"")){
				return false;
			}else if(String(item.statsYn) !== String(cloneList[idx].statsYn)){
				return false;
			}else if(String(item.moveSeq) !== String(cloneList[idx].moveSeq)){
				return false;
			}else if(isNotEmpty(item.moveSeq)){
				if(String(item.moveSeq) !== String(cloneList[idx].moveSeq)){
					return false;
				}
			}else{
				return true;
			}
		}else{			
			if(String(item[name]).replace(/,/g,"") !== String(cloneList[idx][name]).replace(/,/g,"")){
				return false;			
			}else{
				return true;
			}
		}
	}
	
	//input 생성
	function fnCreateInput(item, idx, name){
		let $input = $("<input>").data("name", name);
		
		return $input.addClass("input-gray wth100p").attr("name","sync"+idx)
			.off().on("keyup change", function(){
				item[name] = this.value;
				fnTypeSync(this, name, item, idx);
			}).val( cfnRestore(item[name]) );
	}

	//select box 생성
	function fnCreatePurSelect(item, idx, name){
		let $select = $("<select>").data("name", name);
		let $option = null;
		let list = null;
		
		switch(name){
		case "purDtlSeq":
			list = data.purDtlList;
			for(let i=0; i<list.length; i++){
				if(String(item.purSeq) === String(list[i].purSeq)){
					$option = $("<option>").val(list[i].purDtlSeq).text(list[i].purDetail);	
					if(String(item.purDtlSeq) === String(list[i].purDtlSeq)){				
						$option.prop("selected", true);
					}
					$select.append($option);
				}
			}
			break;
		case "purSeq":
			list = data.purList;
			for(let i=0; i<list.length; i++){
				$option = $("<option>").val(list[i].purSeq).text(list[i].purpose);	
				if(String(item.purSeq) === String(list[i].purSeq)){				
					$option.prop("selected", true);
				}
				$select.append($option);
			}
			break;
		}
		
		return $select.addClass("select-gray wth100p").attr("name","sync"+idx)
			.off().on("change", function(){
				item[name] = this.value;
				if(name === "purSeq") item.purType = purLp[this.value];
				fnTypeSync(this, name, item, idx);
			});
	}
	
	//사용수단 생성
	function fnCreateBankSelect(item, idx){
		let $span = $("<span>");
		let $select = $("<select>").data("name", "bankSeq").append($("<option>").val("0").text("현금"));
		let bankList = data.bankList;
		
		for(let i=0; i<bankList.length; i++){
			$option = $("<option>").val(bankList[i].bankSeq).text(bankList[i].bankName+"("+bankList[i].bankAccount+")");	
			if(String(cloneList[idx].bankSeq) === String(bankList[i].bankSeq)){				
				$option.prop("selected", true);
			}
			$select.append($option);
		}
		
		$select.addClass("select-gray")
			.addClass(item.purType==="LED003"?"wth50p":"wth100p")
			.attr("name","sync"+idx)
			.off().on("change", function(){			
				item.bankSeq = this.value;				
				if(item.purType==="LED001" || item.purType==="LED002")	item.moveSeq = this.value;
				else item.moveSeq = "";
				fnTypeSync(this, "bankSeq", item, idx);
			});		
		$span.append($select);
		
		if(item.purType==="LED003"){
			$select = $("<select>").data("name", "moveSeq").append($("<option>").val("0").text("현금"));
			for(let i=0; i<bankList.length; i++){
				$option = $("<option>").val(bankList[i].bankSeq).text(bankList[i].bankName+"("+bankList[i].bankAccount+")");	
				if(String(cloneList[idx].moveSeq) === String(bankList[i].bankSeq)){				
					$option.prop("selected", true);
				}
				$select.append($option);
			}
			$select.addClass("select-gray")
				.addClass(item.purType==="LED003"?"wth50p":"wth100p")
				.attr("name","sync"+idx)
				.off().on("change", function(){
					item.moveSeq = this.value;
					fnTypeSync(this, "moveSeq", item, idx);
				});			
			
			if(cloneList[idx].purType !== "LED003"){
				$select.addClass("sync-blue");
			}else{
				$select.removeClass("sync-blue");
			}
			
			$span.append($select);			
		}		
		return $span;
	}
	
	//수입지출란 수입, 지출, 이동구분해서 생성
	function fnCreateMoney(item, idx){
		
		let code = purLp[item.purSeq];
		let $input = $("<input>").addClass("only-currency").data("name", "money");
		$input.addClass("input-gray").val(cfnSetComma(item.money)).attr("name","sync"+idx)
			.off().on("keyup change", function(){
				item.money = this.value;
				fnTypeSync(this, "money", item, idx);
			});
		
		let $strong = $("<strong>");	
		switch(code){
		case "LED001":	
			$input.addClass("wth80p");
			$strong.text("+").addClass("pm-mark");
			break;
		case "LED002":
			$input.addClass("wth80p");
			$strong.text("-").addClass("pm-mark");
			break;		
		case "LED003":
			$input.addClass("wth80p");
			$strong.text(">").addClass("pm-mark");
			break;
		default:
			$input.addClass("wth100p");
			break;		
		}
		return $("<span>").append($strong).append($input);
	}
	
	//타입, sync 체크
	function fnTypeSync(obj, name, item, idx){
		let isbool = fnCompareData(name, item, idx);
		if(item.type !== "delete" && isbool){
			item.type = "select";
			$(obj).removeClass("sync-blue");
		}else if(item.type !== "delete" && !isbool){
			item.type = "update";
			$(obj).addClass("sync-blue");
		}
	}
}

</script>

<div class="button-bar">
	<div id="btns" class="btn-right">
		<button id="search" class="btn-gray trs">조회</button>
		<button id="save"  class="btn-gray trs">저장</button>
		<button id="cancel" class="btn-gray trs">초기화</button>
	</div>
</div>

<div>
	<div>
		<div class="title-icon"></div>
		<label class="title">가계부 목록</label>
	</div>
	<div id="searchBar" class="search-bar">
		<table>
			<colgroup>
				<col width="5%" class="search-th"/>
				<col width="10%" />
				<col width="5%" class="search-th"/>
				<col width="10%">
				<col width="5%" class="search-th"/>
				<col width="15%"/>
				<col width="5%" class="search-th"/>
				<col width="15%"/>
				<col width="5%" class="search-th"/>
				<col width="15%"/>				
			</colgroup>
			<tr>
				<th>시작일자</th>
				<td>
					<input id="startDate" value="" type="text" class="input-gray input-center wth100p datepicker-here" data-language='ko'>
				</td>
				<th>종료일자</th>
				<td>
					<input id="endDate" value="" type="text" class="input-gray input-center wth100p datepicker-here" data-language='ko'>
				</td>
				<th>목적</th>
				<td>
					<select id="purSeq" class="select-gray wth100p">
						<option value=''>전체</option>
					</select>
				</td>
				<th>상세목적</th>
				<td>
					<select id="purDtlSeq" class="select-gray wth100p">
						<option value=''>전체</option>
					</select>
				</td>
				<th>은행</th>
				<td>
					<select id="bankSeq" class="select-gray wth100p">
						<option value=''>전체</option>
						<option value='0'>현금</option>
					</select>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="ledgerList" class="text-drag-block"></div>