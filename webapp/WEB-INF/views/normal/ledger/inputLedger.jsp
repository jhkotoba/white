<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="<%=request.getContextPath()%>"></c:set>
<script type="text/javascript">
$(document).ready(function(){	
	cfnCmmAjax("/ledger/selectPurBankList").done(inputLedger);
});

function inputLedger(data){
	console.log(data);
	let insertList = new Array();	
	$("#test").on("click", function(){
		console.log(insertList);
		
		
		/* //moveMoney 마이너스 수정
		for(let i=0; i<this.inList.length; i++){
			if(this.inList[i].purSeq === '0'){			
				this.inList[i].money = "-"+String(Math.abs(Number(this.inList[i].money)));
			}
		}
		if(confirm("입력한 내용을 저장 하시겠습니까?")){
			$.ajax({		
				type: 'POST',
				url: common.path()+'/ledgerRe/insertRecordList.ajax',
				data: {
					inList : JSON.stringify(this.inList)
				},
				dataType: 'json',
			    success : function(data, stat, xhr) {			    	
			    	if(data < 0){
			    		alert("입력한 데이터가 정확하지 않습니다.");
			    		//mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
			    	}else{
			    		alert(data+" 개의 행이 저장되었습니다.");
			    		mf.submit($("#moveForm #navUrl").val(), $("#moveForm #sideUrl").val());
			    	}
			    },
			    error : function(xhr, stat, err) {
			    	alert("insert error");
			    }
			});
		}	 */	
		
		
	})
	
	let purLp = {};
	for(let i=0; i<data.purList.length; i++){
		purLp[data.purList[i].purSeq] = data.purList[i].purType;
	}
	
	data.bankList.unshift({bankAccount: "", bankName: "현금", bankOrder: 0, bankSeq: 0, bankShowYn: "N",	bankUseYn: "N"});	
	insertList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:"", content:"",
		purSeq: "", purDtlSeq: "", bankSeq: "", moveSeq: "", money: ""}
	);
	
	let fieldList = [
		{title : "",		name:"", width : "3%", align:"center",
			headerTemplate: function(){				
				return $("<button>").attr("id", "add")
					.addClass("btn-gray trs")
					.text("+")
					.on("click", function(){
						insertList.push({recordDate: isDate.today()+" "+isTime.curTime(), position:"",
							content:"", purSeq: "",purDtlSeq: "", bankSeq: "", moveSeq: "", money: ""}
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
				.on("click", function(){
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
				return fnCreateCmmInput($("<input>"), "recordDate", item);				
			}
		},
		{title : "위치",		name:"position", 	width : "14%", align:"center", button:true,
			itemTemplate: function(item){
				return fnCreateCmmInput($("<input>"), "position", item);				
			}
		},		
		{title : "내용*",		name:"content", 	width : "16%", align:"center", button:true,
			itemTemplate: function(item){
				return fnCreateCmmInput($("<input>"), "content", item);
			}
		},
		{title : "목적*",		name:"purSeq", 		width : "13%", align:"center", button:true,
			itemTemplate: function(item){
				$select = $("<select>").addClass("select-gray wth80p");
				$option = $("<option>").text("목적선택").val("");
				$select.append($option);
				for(let i=0; i<data.purList.length; i++){
					$option = $("<option>").val(data.purList[i].purSeq)
						.text(data.purList[i].purpose)
						.data("purType", data.purList[i].purType);
					
					if(Number(item.purSeq) === Number(data.purList[i].purSeq)){
						$option.prop("selected", true);
					}
					
					$select.append($option)
				}
				return $select.on("change", function(e){
					item.purSeq = this.value;
					$dtlSelect = $(this).closest("td").next().children().first();
					$dtlSelect.empty();					
					
					$option = $("<option>").text("상세목적 선택").val("");
					$dtlSelect.append($option);
				
					for(let i=0; i<data.purDtlList.length; i++){
						if(Number(data.purDtlList[i].purSeq) === Number(item.purSeq)){
							$option = $("<option>").val(data.purDtlList[i].purDtlSeq)
								.text(data.purDtlList[i].purDetail);		
							$dtlSelect.append($option)
						}
					}
					
					$(this).children().each(function(idx, el){
						if(Number(item.purSeq) === Number(el.value)){							
							let $moveSp = $(this).closest("td").next().next().children().first();
							$moveSp.empty().removeClass();
							
							if($(el).data("purType") === "LP003"){								
								let $select = $("<select>").addClass("select-gray wth50p");								
								$select.append($("<option>").text("보낸곳 선택").val(""));								
								$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "bankSeq", "bankName", "bankAccount");
								
								$select.on("change", function(){
									item.bankSeq = this.value;
								});				
								$moveSp.append($select);
								
								$select = $("<select>").addClass("select-gray wth50p");								
								$select.append($("<option>").text("받는곳 선택").val(""));
								
								$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "moveSeq", "bankName", "bankAccount");
								
								$select.on("change", function(){
									item.moveSeq = this.value;
								});
								$moveSp.append($select).addClass("wth90p inbk");
							}else{
								//사용수단
								let $select = $("<select>").addClass("select-gray wth90p");								
								$select.append($("<option>").text("사용수단 선택").val(""));								
								$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "bankSeq", "bankName", "bankAccount");
								
								$select.on("change", function(){
									item.bankSeq = this.value;
								});	
								item.moveSeq = "";
								$moveSp.append($select).addClass("wth90p");								
							}
							
							let $moneySp = $(this).closest("td").next().next().next().children().first();
							$moneySp.empty().removeClass();
							fnCreateMoney($moneySp, purLp[item.purSeq], item);
							return false;
						}
					});
				});
			}
		},		
		{title : "상세목적",	name:"purDtlSeq", 	width : "11%", align:"center",
			itemTemplate: function(item){
				$select = $("<select>").addClass("select-gray wth100p");
				$option = $("<option>").text("상세목적 선택").val("");
				$select.append($option);
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
				return $select.on("change", function(){
					item.purDtlSeq = this.value;
				});
			}
		},		
		{title : "사용수단*",	name:"bankSeq", 	width : "20%", align:"center", button:true,
			itemTemplate: function(item){
				let $span = $("<span>").addClass("wth90p");
				
				if(isNotEmpty(item.purSeq)){
					for(let i=0; i<data.purList.length; i++){						
						if(Number(item.purSeq) === Number(data.purList[i].purSeq)){
							if(data.purList[i].purType === "LP003"){
								let $select = $("<select>").addClass("select-gray wth50p");
								$select.append($("<option>").text("보낸곳 선택").val(""));								
								$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "bankSeq", "bankName", "bankAccount");								
								$select.on("change", function(){
									item.bankSeq = this.value;
								});				
								$span.append($select);
								
								$select = $("<select>").addClass("select-gray wth50p");
								
								$select.append($("<option>").text("받는곳 선택").val(""));								
								$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "moveSeq", "bankName", "bankAccount");								
								$select.on("change", function(){
									item.moveSeq = this.value;
								});
								$span.append($select).addClass("wth90p inbk");
							}else{								
								let $select = $("<select>").addClass("select-gray wth90p");								
								$select.append($("<option>").text("사용수단 선택").val(""));								
								$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "bankSeq","bankName", "bankAccount");
								
								$select.on("change", function(){
									item.bankSeq = this.value;
								});	
								item.moveSeq = "";
								$span.append($select).addClass("wth90p");								
							}
							break;
						}
					}
				}else{		
					let $select = $("<select>").addClass("select-gray wth90p");					
					$select.append($("<option>").text("사용수단 선택").val(""));
									
					$select = fnCreateOptionList($select, data.bankList, item, "bankSeq", "bankSeq", "bankName", "bankAccount");
					
					$select.on("change", function(){
						item.bankSeq = this.value;
					});	
					item.moveSeq = "";
					$span.append($select).addClass("wth90p");
				}				
				return $span;
			}
		},	
		{title : "수입 지출*",	name:"money", 		width : "11%", align:"center",
			itemTemplate: function(item){				
				let $span = $("<span>");				
				return fnCreateMoney($span, purLp[item.purSeq], item);
			}
		}		
	]
	
	let $header = $("<div>").append(fnCreateHeader());	
	let $tbody = $("<div>").append(fnCreateRow());
	
	$("#ledgerList").append($header);
	$("#ledgerList").append($tbody);
	
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
			$tb.append($tr.append($th));			
		}
		
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
							.on("mouseenter", function(){								
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
	function fnCreateCmmInput($input, name, item){		
		return $input.addClass("input-gray wth80p").on("change", function(){
			item[name] = this.value;
		}).val(item[name]);
	}
	
	//셀렉트박스 옵션리스트 생성
	function fnCreateOptionList($select, list, item, seqNm1, seqNm2, name, name2){
		let $option = $("<option>");
		for(let i=0; i<list.length; i++){
			
			if(isNotEmpty(name2)){
				$option = $("<option>").val(list[i][seqNm1])
				.text(list[i][name] + (isEmpty(list[i][name2]) ? "" : "(" + list[i][name2] + ")"));
			}else{
				$option = $("<option>").val(list[i][seqNm1])
					.text(list[i][name]);
			}
			
			if(String(item[seqNm2]) === String(list[i][seqNm1])){				
				$option.prop("selected", true);
			}
			$select.append($option);
		}
		return $select;
	}
	
	//수입지출란 수입, 지출, 이동구분해서 생성
	function fnCreateMoney($moneySp, code, item){
		
		let $input = $("<input>").addClass("only-currency");
		$input.addClass("input-gray").on("keyup keydown change", function(){
			item.money = this.value;
		}).val(item.money);
		let $strong = $("<strong>");	
		switch(code){
		case "LP001":	
			$input.addClass("wth80p sync-red");
			$strong.text("+").addClass("pm-mark sync-red");
			break;
		case "LP002":
			$input.addClass("wth80p sync-blue");
			$strong.text("-").addClass("pm-mark sync-blue");
			break;		
		case "LP003":
			$input.addClass("wth80p sync-green");
			$strong.text(">").addClass("pm-mark sync-green");
			break;
		default:
			$input.addClass("wth100p");
			break;		
		}	
		$moneySp.append($strong);
		$moneySp.append($input);
		return $moneySp;
	}
}
</script>

<div id="searchBar" class="search-bar pull-right">	
	<button id="test" type="button" class="btn-gray trs">저장</button>
</div>
<div id="ledgerList"></div>