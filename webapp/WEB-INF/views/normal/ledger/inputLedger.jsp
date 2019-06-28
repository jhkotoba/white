<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<style>
.dncp{border: 1px solid #9E9E9E;}
</style>
<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/ledger/selectPurBankList").done(inputLedger);
	cfnCmmAjax("/ledger/selectRecordList", {searchType:"recent", schdTime:$("#schdTime").val()}).done(recordList);
	
	$("#schdTime").on("change", function(){
		cfnCmmAjax("/ledger/selectRecordList", {searchType:"recent", schdTime:$("#schdTime").val()}).done(recordList);
	});
});

//가계부 기입란
function inputLedger(data){	
	let insertList = new Array();
	
	let purLp = {};
	for(let i=0; i<data.purList.length; i++){
		purLp[data.purList[i].purSeq] = data.purList[i].purType;
	}	
	
	data.bankList.unshift({bankAccount: "", bankName: "현금", bankOrder: 0, bankSeq: 0, bankUseYn: "N"});	
	insertList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:"", content:"",
		purSeq: "", purDtlSeq: "", bankSeq: "", moveSeq: "", money: "", statsYn: "Y"}
	);
	
	let fieldList = [
		{title : "",		name:"", width : "3%", align:"center",
			headerTemplate: function(){				
				return $("<button>").attr("id", "add")
					.addClass("btn-gray trs")
					.text("+")
					.off().on("click", function(){
						insertList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:"",
							content:"", purSeq: "",purDtlSeq: "", bankSeq: "", moveSeq: "", money: "", statsYn: "Y"}
						);
						$tbody.empty().append(
							$("<div>").append(fnCreateRow())
						);
					});			
			},
			itemTemplate: function(item, idx){
				return $("<button>")
				.addClass("btn-gray trs")
				.text("-")
				.off().on("click", function(){
					if(confirm("삭제 하시겠습니까?")){
						insertList.splice(idx,1);
						$tbody.empty().append(
							$("<div>").append(fnCreateRow())
						);
					}		
				});				
			}
		},
		{title : "날짜*",		name:"recordDate",	width : "11%", align:"center", button:true,
			itemTemplate: function(item){				
				let $input = fnCreateInput("recordDate", item);
				$input.datepicker({
					language: 'ko',
					timepicker: true,
					onSelect: function() {
						item.recordDate = $input.val();
					}
				});
				return $input;
			}
		},
		{title : "위치",		name:"position", 	width : "14%", align:"center", button:true,
			itemTemplate: function(item){
				return fnCreateInput("position", item);				
			}
		},		
		{title : "내용*",		name:"content", 	width : "15%", align:"center", button:true,
			itemTemplate: function(item){
				return fnCreateInput("content", item);
			}
		},
		{title : "목적*",		name:"purSeq", 		width : "12%", align:"center", button:true,
			itemTemplate: function(item){
				return fnCreatePurpose(item);
			}
		},		
		{title : "상세목적*",	name:"purDtlSeq", 	width : "11%", align:"center",
			itemTemplate: function(item){
				return fnCreatePurposeDetail(item);
			}
		},		
		{title : "사용수단*",	name:"bankSeq", 	width : "19%", align:"center", button:true,
			itemTemplate: function(item){				
				let $span = $("<span>");				
				if(isNotEmpty(item.purSeq)){
					for(let i=0; i<data.purList.length; i++){				
						if(Number(item.purSeq) === Number(data.purList[i].purSeq)){							
							fnCreateBank(item, data.purList[i].purType, $span);							
							break;
						}
					}
				}else{fnCreateBank(item, null, $span);}
				return $span;
			}
		},	
		{title : "수입지출*",	name:"money", 		width : "10%", align:"center",
			itemTemplate: function(item){
				return fnCreateMoney(item, purLp[item.purSeq], $("<span>"));
			}
		},
		{title : "통계여부",	name:"statsYn", 		width : "4%", align:"center",
			itemTemplate: function(item, idx){
				return $("<button>").addClass("btn-gray trs").text("Y").val("Y").off().on("click", function(){
					if($(this).val() === "Y"){ $(this).val("N").text("N"); item.statsYn = this.value;}
					else{ 					   $(this).val("Y").text("Y"); item.statsYn = this.value;}					
				});				
			}
		}	
	]
	
	let $header = $("<div>").append(fnCreateHeader());	
	let $tbody = $("<div>").append(fnCreateRow());
	
	$("#ledgerList").append($header);
	$("#ledgerList").append($tbody);
	
	$("#saveBtn").off().on("click", function(){
		//유효성 검사
		let isVali = true;
		$("[name='sync']").each(function(i, e){
			if(isEmpty($(e).val())){
				isVali = false;
				wVali.alert({element : $(e), msg: $(e)[0].nodeName === "SELECT" ? "값을 선택해 주세요." : "값을 입력해 주세요."}); return false;
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
	
		if(isVali && confirm("입력한 내용을 저장 하시겠습니까?")){			
			for(let i=0; i<insertList.length; i++){
				insertList[i].money =  insertList[i].money.replace(/,/gi, "");
				switch(purLp[insertList[i].purSeq]){
				case "LED001":				
					insertList[i].money = Number(insertList[i].money);
					break;				
				case "LED002":
				case "LED003":
					insertList[i].money = Number("-"+insertList[i].money);				
					break;					
				}
			}
			
			let param = {};
			param.insertList = JSON.stringify(insertList);
			
			cfnCmmAjax("/ledger/insertRecordList", param).done(function(data){				
				if(Number(data) > 0){
					alert(data + "행이 저장되었습니다.");

					insertList = new Array();
					insertList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:"", content:"",
						purSeq: "", purDtlSeq: "", bankSeq: "", moveSeq: "", money: "", statsYn:"Y"}
					);						
					$tbody.empty().append($("<div>").append(fnCreateRow()));					
					cfnCmmAjax("/ledger/selectRecordList", {searchType:"recent", schdTime:$("#schdTime").val()}).done(recordList);
				}else{
					alert("저장에 실패하였습니다. error:"+data);	
					for(let i=0; i<insertList.length; i++){						
						insertList[i].money = cfnSetComma(String(Math.abs(Number(insertList[i].money))));
					}					
				}
			});
		}
	});	
	
	//해더 생성
	function fnCreateHeader(){
		
		let $tb = $("<table>").addClass("table-header");
		let $tr = $("<tr>");
		let $th = null;
		
		for(let i=0; i<fieldList.length; i++){			
			$th = $("<th>").attr("style", "width:"+fieldList[i].width);			
			if(isNotEmpty(fieldList[i].headerTemplate)){
				$th.append(fieldList[i].headerTemplate());
			}else{
				$th.text(fieldList[i].title);
			}
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
		let obj = null;
				
		for(let i=0; i<insertList.length; i++){
			$tr = $("<tr>");
			for(let j=0; j<fieldList.length; j++){
				$td = $("<td>").attr("style", "width:"+fieldList[j].width);
				if(isNotEmpty(fieldList[j].itemTemplate)){
					$td.append(fieldList[j].itemTemplate(insertList[i], i).attr("style", "text-align:"+fieldList[j].align));
					if(fieldList[j].button === true){
						$button = $("<button>").addClass("btn-gray trs").text("↓")
							//마우스 오버 이벤트
							.off().on("mouseenter", function(){
								for(let k=i; k<insertList.length; k++){
									obj = $(this).closest("table").children().eq(k).children().eq(j).children().eq(0);
									if(obj[0].tagName === "SPAN")	obj.children().eq(0).addClass("dncp");
									else	obj.addClass("dncp");
								}
							//마우스 아웃 이벤트
							}).on("mouseleave", function(){								
								for(let k=i; k<insertList.length; k++){
									obj = $(this).closest("table").children().eq(k).children().eq(j).children().eq(0);
									if(obj[0].tagName === "SPAN")	obj.children().eq(0).removeClass("dncp");
									else	obj.removeClass("dncp");
								}
							//클릭 이벤트 - 해당란부터 마지막란까지 일괄 변경
							}).on("click", function(){
								let value = "";
								obj = $(this).prev();
								if(obj[0].tagName === "SPAN")	value = obj.children().eq(0).val();
								else	value = obj.val();
								
								for(let k=i; k<insertList.length; k++){
									obj = $(this).closest("table").children().eq(k).children().eq(j).children().eq(0);
									if(obj[0].tagName === "SPAN")	obj.children().eq(0).val(value).trigger('change');
									else	obj.val(value).trigger('change');
								}
							});
						$td.append($button);
					}
				}else{
					$td.text(insertList[i][fieldList[j].name]);
				}				
				$tr.append($td);
			}
			$tb.append($tr);			
		}		
		return $tb;
	}
	
	//기본 input 생성
	function fnCreateInput(name, item){		
		return $("<input>").addClass("input-gray wth80p").attr("name", "sync")
			.data("name", name).off().on("change", function(){
			item[name] = this.value;
		}).val(item[name]);
	}
	
	//목적 selectbox 생성
	function fnCreatePurpose(item){		
		let $option = $("<option>").text("목적선택").val("");		
		let $select = $("<select>").addClass("select-gray wth80p").attr("name", "sync")
			.data("name", "purSeq").append($option);
		
		//목적 셀렉트 박스
		for(let i=0; i<data.purList.length; i++){
			$option = $("<option>").val(data.purList[i].purSeq).text(data.purList[i].purpose)
				.data("purType", data.purList[i].purType);
			
			if(Number(item.purSeq) === Number(data.purList[i].purSeq)){
				$option.prop("selected", true);
			}			
			$select.append($option);
		}
		
		$select.off().on("change", function(e){
			item.purSeq = this.value;
			
			//상세목적 셀렉트박스
			fnCreatePurposeDetail(item, $(this).closest("td").next().children().first().empty());			
			
			$(this).children().each(function(idx, element){
				if(Number(item.purSeq) === Number(element.value)){					
					//현금,은행 입력란
					let $move = $(this).closest("td").next().next().children().first().empty().removeClass();
					fnCreateBank(item, $(element).data("purType"), $move);
					//금액 입력란
					let $money = $(this).closest("td").next().next().next().children().first().empty().removeClass();
					fnCreateMoney(item, purLp[item.purSeq], $money);
					return false;
				}
			});
		});		
		return $select;
	}
	
	//상세목적 selectbox 생성
	function fnCreatePurposeDetail(item, $select){
		if(isEmpty($select)) $select = $("<select>");
		
		let $option = $("<option>").text("상세목적 선택").val("");
		$select.addClass("select-gray wth80p").attr("name", "sync").append($option);
		for(let i=0; i<data.purDtlList.length; i++){
			if(Number(data.purDtlList[i].purSeq) === Number(item.purSeq)){
				$option = $("<option>").val(data.purDtlList[i].purDtlSeq)
					.text(data.purDtlList[i].purDetail)
				
				if(Number(item.purDtlSeq) === Number(data.purDtlList[i].purDtlSeq)){
					$option.prop("selected", true);
				}
			}					
			$select.append($option)
		}
		return $select.off().on("change", function(){
			item.purDtlSeq = this.value;
		});
	}
	
	//은행 select 생성
	function fnCreateBank(item, purType, $span){
		let $select = $("<select>");		
		switch(purType){
		case "LED001":
		case "LED002":
			
			//LED003에서 LED002,LED001이동시 moveSeq값 같게하기
			item.moveSeq = item.bankSeq;
			
			$select.addClass("select-gray wth90p").attr("name", "sync")
				.data("name", "bankSeq").append($("<option>").text("사용수단 선택").val(""))
				.off().on("change", function(){
					item.bankSeq = this.value;
					item.moveSeq = this.value;
				});;
			
			fnCreateOption(item, "bankSeq", $select);			
			$span.append($select).addClass("wth90p");
			break;
		case "LED003":
			//보내는곳
			item.moveSeq = "";
			$select.addClass("select-gray wth50p").attr("name", "sync")
				.data("name", "bankSeq").append($("<option>").text("보낸곳 선택").val(""))
				.off().on("change", function(){
					item.bankSeq = this.value;
				});
			
			fnCreateOption(item, "bankSeq", $select);			
			$span.append($select);
			
			//받는곳
			$select = $("<select>").addClass("select-gray wth50p").attr("name", "sync")
				.data("name", "moveSeq").append($("<option>").text("받는곳 선택").val(""))								
				.off().on("change", function(){
					item.moveSeq = this.value;
				});
			
			fnCreateOption(item, "moveSeq", $select);		
			$span.append($select).addClass("wth90p inbk");
			break;
		default:
			$select.addClass("select-gray wth90p").append($("<option>").text("사용수단 선택").val(""))
				.off().on("change", function(){
					item.bankSeq = this.value;
				});
		
			fnCreateOption(item, "bankSeq", $select);
		
			item.moveSeq = "";
			$span.append($select).addClass("wth90p");
			break;
		}
	}
	
	//은행 셀렉트박스 옵션리스트 생성
	function fnCreateOption(item, seq, $select){
		let $option = $("<option>");
		for(let i=0; i<data.bankList.length; i++){
			
			$option = $("<option>").val(data.bankList[i].bankSeq)
				.text(data.bankList[i].bankName + (isEmpty(data.bankList[i].bankAccount) ? "" : "(" + data.bankList[i].bankAccount + ")"));
			
			if(String(item[seq]) === String(data.bankList[i].bankSeq)){				
				$option.prop("selected", true);
			}
			$select.append($option);
		}
		return $select;
	}
	
	//수입지출란 수입, 지출, 이동구분해서 생성
	function fnCreateMoney(item, code, $money){	
		let $input = $("<input>").addClass("only-currency").attr("name", "sync").data("name", "money");
		
		$input.addClass("input-gray").off().on("keyup keydown change", function(){
			item.money = this.value;
		}).val(cfnRemoveMinus(item.money));
		
		let $strong = $("<strong>");		
		switch(code){
		case "LED001":	
			$input.addClass("wth80p sync-red");
			$strong.text("+").addClass("pm-mark sync-red");
			break;
		case "LED002":
			$input.addClass("wth80p sync-blue");
			$strong.text("-").addClass("pm-mark sync-blue");
			break;		
		case "LED003":
			$input.addClass("wth80p sync-green");
			$strong.text(">").addClass("pm-mark sync-green");
			break;
		default:
			$input.addClass("wth100p");
			break;		
		}
		
		$money.append($strong);
		$money.append($input);
		return $money;
	}
}

function recordList(data){
	$("#recordList").empty().jsGrid({
        height: "auto",
        width: "100%",
        
        autoload: true,
		data: data,		
		paging: true,
		pageSize: 10,
		
		confirmDeleting : false,
       
        autoload: true,
        fields: [
			{ title:"날짜",		name:"recordDate",	type:"text", width: "8%",	align:"center"},
			{ title:"위치",		name:"position",	type:"text", width: "14%",	align:"center"},
			{ title:"내용",		name:"content",		type:"text", width: "14%",	align:"center"},
			{ title:"목적",		name:"purpose",		type:"text", width: "8%",	align:"center"},
			{ title:"상세목적",	name:"purDetail",	type:"text", width: "9%",	align:"center"},
			{ title:"은행",		name:"bankName",	type:"text", width: "8%",	align:"center"},
			{ title:"은행상세",	name:"bankAccount",	type:"text", width: "12%",	align:"center"},
			{ title:"금액",		name:"money",		type:"text", width: "5%",	align:"center"},
			{ title:"통계여부",	name:"statsYn",		type:"text", width: "4%",	align:"center"},
			{ title:"수정일시",	name:"editDate",	type:"text", width: "9%",	align:"center"},
			{ title:"등록일시",	name:"regDate",		type:"text", width: "9%",	align:"center"},
        ]
    });	
}
</script>

<div class="button-bar">
	<div class="btn-right">		
		<button id="saveBtn" type="button" class="btn-gray trs">저장</button>
	</div>
</div>
<div class="mgbottom30">
	<div>
		<div class="title-icon"></div>
		<label class="title">기입란</label>
	</div>
	<div id="ledgerList"></div>
</div>
<div>
	<div class="button-bar">		
		<div class="btn-right">
			<table>
				<colgroup>
					<col width="90px" class="search-th"/>
					<col width="*"/>								
				</colgroup>
				<tr>
					<th>시간설정</th>
					<td>
						<select id="schdTime" class="select-gray">
							<option value="1" selected="selected">1H</option>
							<option value="3">3H</option>
							<option value="6">6H</option>
							<option value="12">12H</option>
							<option value="24">24H</option>
						</select>
					</td>					
				</tr>
			</table>			
		</div>
	</div>
	<div>
		<div class="title-icon"></div>
		<label class="title">최근기입목록</label>
	</div>
	<div id="recordList"></div>
	<div id="pager" class="pager"></div>
</div>
