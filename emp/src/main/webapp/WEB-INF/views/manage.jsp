<%@ page language="java" contentType="text/html; charset=UTF8"  pageEncoding="UTF8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html> 
<head>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<meta charset="UTF8">
<title>Index</title>
<style>
    table {
        border-collapse: collapse;
    }
    th, td {
        border: 1px solid black;
        text-align: center;
        padding: 2px 4px 2px 4px;
    }
</style>
</head>
<body>
	<div>
		<h2 align="center">사원 관리 페이지</h2>
		
		<div>
			<div id="searchArea">
				<select id="searchItem">
					<option value="empno">사원번호</option>
					<option value="ename">사원명</option>
					<option value="job">직업</option>
					<option value="mgr">매니저</option>
					<option value="hiredate">입사일자</option>
					<option value="sal">연봉</option>
					<option value="comm">보너스</option>
					<option value="deptno">부서번호</option>
				</select>
				<input class="searchWord" value="${searchWord}">
				<button id="searchBtn">검색</button>
				<select id="rowOfPage">
					<option value="5">5명씩</option>
					<option value="10">10명씩</option>
					<option value="15">15명씩</option>
					<option value="20">20명씩</option>
				</select>
			</div>
			<div id="btnArea" align="right">
				<button id="addEmpBtn">추가</button>
				<button id="saveBtn">저장</button>
				<button id="deleteBtn">삭제</button>
			</div>
			<br>
			<div>
				총 ${empList[0].totalCnt}명
			</div>
			<div id="tableArea">
				<table>
					<thead>
						<tr style="background-color: skyblue">
							<td><input type="checkbox" id="ckAll"></td>
							<td width="100px"><b>사원번호</b></td><!-- <button data-item="empno" class="sort">↑</button> -->
							<td width="120px"><b>사원명</b></td>
							<td width="120px"><b>직업</b></td>
							<td width="90px"><b>매니저</b></td>
							<td width="120px"><b>입사일자</b></td>
							<td width="70px"><b>연봉</b></td>
							<td width="90px"><b>보너스</b></td>
							<td width="100px"><b>부서번호</b></td>
						</tr>
					</thead>
					
					<tbody>
						<c:choose>
							<c:when test="${empty empList}">
								<tr>
									<td colspan="9">검색 결과가 없습니다.</td>
								</tr>
							</c:when>
							<c:otherwise>
								<c:forEach items="${empList}" var="emp">
									<tr>
										<td><input type="checkbox" class="ckBox origin" value="${emp.empno}"></td>
										<td class="empno">${emp.empno}</td>
										<td class="ename">${emp.ename}</td>
										<td class="job">${emp.job}</td>
										<td class="mgr">${emp.mgr != 0 ? emp.mgr : "-"}</td>
										<td class="hiredate"><fmt:formatDate value="${emp.hiredate}" pattern="yyyy-MM-dd"/></td>
										<td class="sal" style="text-align: right">${emp.sal != 0 ? emp.sal : "-"}</td>
										<td class="comm" style="text-align: right">${emp.comm != 0 ? emp.comm : "-"}</td>
										<td class="deptno">${emp.deptno != 0 ? emp.deptno : "-"}</td>
									</tr>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</tbody>
					
					<tfoot>
					</tfoot>
				</table>
			</div>
			<br>
			<div id="pagingArea">
				<c:choose>
					<c:when test="${rowOfPage >= empList[0].totalCnt}">
					</c:when>
					<c:when test="${empty searchPage || searchPage == 1}">
						<button id="currPage">1</button>
						<button id="nextBtn">&gt</button>
					</c:when>
					<c:when test="${rowOfPage * searchPage >= empList[0].totalCnt}">
						<button id="prevBtn">&lt</button>
						<button id="currPage">${searchPage}</button>
					</c:when>
					<c:otherwise>
						<button id="prevBtn">&lt</button>
						<button id="currPage">${searchPage}</button>
						<button id="nextBtn">&gt</button>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</body>

<!-- 정보 가져오기 -->
<script>
	let dList = ${deptnoList};
	
	let jList = [];
	<c:forEach items="${jobList}" var="job">
		jList.push("${job}");
	</c:forEach>
	
	let empnoList = ${empnoList};
</script>

<!-- 체크 박스와 관련된 script -->
<script>
	const ckAll = $("#ckAll");
	let ckBoxes = $(".ckBox");
	
	// 전체 체크 박스
	$(ckAll).on("click", function() {
		
		// 각 체크박스를 돌며 작업
		$(".ckBox").each(function() {
		
			// 체크/해제 작업
			$(this).prop("checked", ckAll.prop("checked"));

			// 기존 자료이면서, 수정이 안 되었다면, 수정 가능한 행으로 변경
			if ($(this).is(".origin") && !$(this).is(".modified")) {
				doModify($(this));
			} else if (!ckAll.is(":checked")) { // 전체 체크 해제 시, 기존 자료를 원복
				cancelModify($(this));
			}
		});
	});
	
	// 개별 체크 박스
	$(ckBoxes).on("click", function() {
		ckBoxes = $(".ckBox");
		
		// 체크 해제 시 [전체 체크 박스] 해제
		if(!$(this).prop("checked")) {
			ckAll.prop("checked", false);
			return;
		}
		
	 	// 전체 체크 시 [전체 체크 박스] 체크
	 	let checkedBoxesCnt = ckBoxes.filter(":checked").length;
	 	
		if (ckBoxes.length === checkedBoxesCnt) {
			ckAll.prop("checked", true);
		}
	});
</script>

<!-- select, option 태그 생성하는 함수 -->
<script>
	function createOption(className, list, oldVal) {
		let opt = `<select class="`+className+`">
			  			<option value="">선택안함</option>`;
		
		for(let li of list) {
			if (li === oldVal) {
				opt += `<option value="`+li+`" selected>`+li+`</option>`;
			} else {
				opt += `<option value="`+li+`">`+li+`</option>`;
			}
		}
		
		opt += `</select>`;
		
		return opt;
	}
</script>

<!-- 검색 조건에 따라 input 태그 변경하는 함수 -->
<script>
	function changeInput () {
		
		$(".searchWord").remove();
		
		let content = `<input class="searchWord">`;
		
		switch ($("#searchItem").val()) {
		case "empno": case "ename" :
			content = `<input class="searchWord">`;
			break;
		case "hiredate":
			content = `<input class="searchWord" type="date">`;
			break;
		case "sal": case "comm" :
			content = `<div class="searchWord"><input class="searchRange" id="range1" placeholder="0" onkeyup="rangeChange()">~<input class="searchRange" id="range2" placeholder="100" onkeyup="rangeChange()"><div>`;
			break;
		case "job": 
			content = createOption("searchWord", jList);
			break;
		case "mgr": 
			content = createOption("searchWord", empnoList);
			break;
		case "deptno": 
			content = createOption("searchWord", dList);
			break;
		}
		
		$("#searchItem").after(content);
	}
</script>

<!-- 사원 추가와 관련된 script -->
<script>
	// [추가] 버튼 선택 시 새로운 사원 추가할 수 있는 행이 추가됨
	$("#addEmpBtn").on("click", function () {
		// 추가할 html 코드 만들기
		let content = `<tr>
							<td><input type="checkbox" class="ckBox new" checked></td>
							<td class="empno"><input type="number" style="width: 50px;" min="1" max="9999"></td>
							<td class="ename"><input style="width: 100px;"></td>
							<td class="job">`;
		content += createOption("job", jList)+`</td><td class="mgr">`;
		content += createOption("mbr", empnoList)+`</td><td class="hiredate">`;
		content += `<input type="date"></td>
					<td class="sal"><input type="number" style="width: 50px;" min="0"></td>
					<td class="comm"><input type="number" style="width: 50px;" min="0"></td>
					<td class="deptno">`;
		content += createOption("deptno", dList)+`</td><td><button class="removeBtn"> X </button></td></tr>`;
		
		// tbody의 마지막 자식으로 추가
		$("tbody").append(content);
	})
	
	// [X] 버튼 선택 시 행 삭제
	$("tbody").on("click", ".removeBtn", function() {
		$(this).parent().parent().remove();
	})
</script>

<!-- 사원 수정과 관련된 script -->
<script>
	// 사원 개별 선택 시 수정 작업
	$(ckBoxes).filter(".origin").not(".modified").on("click", function () {
		// 수정이 이미 됐다면 수정 취소
		if ($(this).is(".modified")){
			cancelModify($(this))
			return;
		}
		// 수정이 안 됐다면 수정 가능한 행으로 변경
		doModify($(this));
	})
	
	// 기존 자료의 checkbox를 선택하면 수행하는 함수
	function doModify(ckBox){
		// 작업 전, tr 태그들 가져오기
		let emp = ckBox.parent().siblings();
		let job = emp.filter(".job");
		let mgr = emp.filter(".mgr");
		let sal = emp.filter(".sal");
		let comm = emp.filter(".comm");
		let deptno = emp.filter(".deptno");
	
		// checkbox에 modified 클래스 추가
		ckBox.addClass("modified");
		
		// input, select 태그로 교체
		job.prop("oldVal", job.text()).html(createOption("job", jList, job.text()));
		mgr.prop("oldVal", mgr.text()).html(createOption("mgr", empnoList, mgr.text()));
		sal.prop("oldVal", sal.text()).html(`<input type="number" style="width: 50px;" value="`+sal.text()+`">`);
		comm.prop("oldVal", comm.text()).html(`<input type="number" style="width: 50px;" value="`+comm.text()+`">`);
		deptno.prop("oldVal", deptno.text()).html(createOption("mgr", dList, deptno.text()));
	}
	
	// 기존 자료의 checkbox를 해제하면 수행하는 함수
	function cancelModify(ckBox){
		// 작업 전, tr 태그들 가져오기
		let emp = ckBox.parent().siblings();
		let job = emp.filter(".job");
		let mgr = emp.filter(".mgr");
		let sal = emp.filter(".sal");
		let comm = emp.filter(".comm");
		let deptno = emp.filter(".deptno");
		
		// checkbox에 modified 클래스 제거
		ckBox.removeClass("modified");
		
		// td 태그로 교체
		job.html(job.prop("oldVal"));
		mgr.html(mgr.prop("oldVal"));
		sal.html(sal.prop("oldVal"));
		comm.html(comm.prop("oldVal"));
		deptno.html(deptno.prop("oldVal"));
	}
</script>

<!-- 변경 사항 저장과 관련된 script -->
<script>
	// 저장 버튼 클릭 시 수행
	$("#saveBtn").on("click", function(){
		if(confirm("선택된 항목을 저장하시겠습니까?")) {
			let doNext = true;
			
			// 신규 사원 추가
			doNext = addNewEmps();
			
			// 기존 사원 변경
			if (doNext) {
				doNext = editOldEmps();
			}
			
			// 페이지 새로고침
			if (doNext) {
				setTimeout(() => {
					location.reload();
				}, 1000);
			}
		}
	});
	
	// 신규 사원 추가하는 함수
	function addNewEmps(){
		// 신규 사원 추가값 받아오기
		let newEmpObj;
		let newEmpObjList = [];
		let isOkToInsert = true; // 값이 적절한지 여부
		
		$(".ckBox").filter(".new").map(function(){
			if (!isOkToInsert) return; // 하나라도 적절하지 않은 값이 있다면, 함수 빠져나감
			
			// 값 저장
			let emp = $(this).parent().siblings();
			
			newEmpObj = new Object();
			newEmpObj.empno = emp.filter(".empno").find("input").val();
			newEmpObj.ename = emp.filter(".ename").find("input").val().toUpperCase();
			newEmpObj.job = emp.filter(".job").find("select").val();
			newEmpObj.mgr = emp.filter(".mgr").find("select").val();
			newEmpObj.hiredate = emp.filter(".hiredate").find("input").val();
			newEmpObj.sal = emp.filter(".sal").find("input").val();
			newEmpObj.comm = emp.filter(".comm").find("input").val();
			newEmpObj.deptno = emp.filter(".deptno").find("select").val();
			
			// 값 체크
			isOkToInsert = checkInsertValues(newEmpObj);
			
			// 입사 일자가 없을 시 오늘로 저장
			if (newEmpObj.hiredate === "") {
				newEmpObj.hiredate = new Date();
			}
			
			// 배열에 저장
			newEmpObjList.push(newEmpObj);
		});

		// 값이 적절하지 않을 시, 함수 빠져나감
		if (!isOkToInsert) return;
		
		// 신규 사원 추가 요청
		if (newEmpObjList.length !== 0) {
			$.ajax({
				type : "POST",
				url : "/manage",
				contentType: "application/json",
				data : JSON.stringify(newEmpObjList),
				success : function(){
					console.log("add success");
				}, error : function(xhr, status, error){
		            alert("add " + xhr.responseText);
				}
			});
		}
		return true;
	};
	
	// 신규 사원 값 체크하는 함수
	function checkInsertValues(newEmpObj) {
		// 사원 번호가 없을 시 저장 취소
		if (newEmpObj.empno === "") {
			alert(newEmpObj.empno + ": 사원 번호는 필수 입력 값입니다.");
			return false;
		}
		// 사원 번호가 1~9999가 아닐 시 저장 취소
		if (newEmpObj.empno > 9999 || newEmpObj.empno < 1) {
			alert(newEmpObj.empno + ": 사원번호는 1~9999 사이여야 합니다.");
			return false;
		}
		// 사원명이 없을 시 저장 취소
		if (newEmpObj.ename === "") {
			alert(newEmpObj.empno + ": 사원명은 필수 입력 값입니다.");
			return false;
		}
		// 연봉이 음수일 시 저장 취소
		if (newEmpObj.sal < 0) {
			alert(newEmpObj.empno + ": 연봉은 0원 이상이어야 합니다.");
			return false;
		}
		// 보너스가 음수일 시 저장 취소
		if (newEmpObj.comm < 0) {
			alert(newEmpObj.empno + ": 보너스는 0원 이상이어야 합니다.");
			return false;
		}
		return true;
	}
	
	// 기존 사원 변경하는 함수
	function editOldEmps(){
		// 기존 사원 수정값 받아오기
		let empObj;
		let empObjList = [];
		let isOkToUpdate = true;
		
		ckBoxes.filter(".modified").map(function(){
			if (!isOkToUpdate) return;
			let emp = $(this).parent().siblings();
			
			empObj = new Object();
			empObj.empno = emp.filter(".empno").text();
			empObj.job = emp.filter(".job").find("select").val();
			empObj.mgr = emp.filter(".mgr").find("select").val();
			empObj.sal = emp.filter(".sal").find("input").val();
			empObj.comm = emp.filter(".comm").find("input").val();
			empObj.deptno = emp.filter(".deptno").find("select").val();
			
			empObjList.push(empObj);
			
			// 연봉이 음수일 시 저장 취소
			if (empObj.sal < 0) {
				alert(empObj.empno + ": 연봉은 0원 이상이어야 합니다.");
				isOkToUpdate = false;
				return;
			}
			// 보너스가 음수일 시 저장 취소
			if (empObj.comm < 0) {
				alert(empObj.empno + ": 보너스는 0원 이상이어야 합니다.");
				isOkToUpdate = false;
				return;
			}
		})
		
		// 값이 적절하지 않을 시 저장 취소
		if (!isOkToUpdate) return;
		
		// 기존 사원 수정 요청
		if (empObjList.length !== 0) {
			$.ajax({
				type : "PATCH",
				url : "/manage",
				contentType: "application/json",
				data : JSON.stringify(empObjList),
				success : function(){
					console.log("modify success");
				}, error : function(xhr, status, error){
		            alert("modify " + xhr.responseText);
				}
			});
		}
		return true;
	}
</script>

<!-- 사원 삭제와 관련된 script -->	
<script>
	$("#deleteBtn").on("click", function() {
		// 매니저 리스트 가져오기
		let mgrList = $(".mgr").map(function(){
			return $(this).html();
		}).get();
		
		if (confirm("선택된 사원을 삭제하시겠습니까?")) {
			// 선택된 사원들의 empno 가져오기
			let empDeleteList = [];
			
			// 기존 사원만 삭제 가능
			empDeleteList = ckBoxes.filter(".origin:checked").map(function () {
				let empno = $(this).val();
				
				// 누군가의 매니저가 아닐 때에만 반환
				if (mgrList.indexOf(empno) === -1) {
					return empno;
				}
				
				// 매니저는 삭제 불가능 알람
				alert("매니저는 삭제가 불가능합니다.");
			}).get();
			
			// 삭제 요청
			$.ajax({
				type : "DELETE",
				url : "/manage",
				contentType: "application/json",
				data : JSON.stringify(empDeleteList),
				success : function(){
					$(location).attr("href", "/manage");
				}, error : function(xhr, status, error){
		            alert(xhr.responseText);
				}
			});
		}
	});
</script>

<!-- 사원 검색과 관련된 script -->
<script>
	// 검색 조건 유지
	$(document).ready(function(){
		// url에서 파라미터 값 받아오기
		let params = new URLSearchParams(window.location.search);
		let searchItem = params.get("searchItem");
		let searchWord = params.get("searchWord");
		let rowOfPage = params.get("rowOfPage");
		// let orderItem = params.get("orderItem");
		// let orderType = params.get("orderType");

		// 검색 항목 변경
		if (searchItem) $("#searchItem").val(searchItem);
		
		// 검색 항목에 따라 input 태그 / select 태그 변경
		changeInput();
		
		// 검색 키워드 변경
		if (searchWord) {
			let indexOfRange = searchWord.indexOf("~");
			if (indexOfRange != -1) {
				$("#range1").val(searchWord.substr(0, indexOfRange));
				$("#range2").val(searchWord.substr(indexOfRange+1));
			} else {
				$(".searchWord").val(searchWord);
			}
		}
		
		// 범위 검색일 경우, 값 설정
		if ($("#range1").length) rangeChange();
		
		// 페이지 보기 변경
		if (rowOfPage) $("#rowOfPage").val(rowOfPage);
		/* 
		// 정렬 기준 유지
		if (orderItem) {
			let sortBtn = $(`.sort[data-item='`+orderItem+`']`);
			sortBtn.addClass("sorted");
			
			if (orderType === "ASC") sortBtn.text("↑");
			else if (orderType === "DESC") sortBtn.text("↓");
			else sortBtn.text("-");
		}
		*/
	})
	
	// 범위 검색
	function rangeChange() {
		$(".searchWord").val($("#range1").val()+"~"+$("#range2").val());
	}
	
	// 검색 조건이 변경될 때마다 input 태그 변경
	$("#searchItem").on("change", function(){
		changeInput();
	})
	
	// 검색 버튼 클릭 시
	$("#searchBtn").on("click", function () {
		let searchItem = $("#searchItem").val();
		let searchWord = $(".searchWord").val();
		let rowOfPage = $("#rowOfPage").val();
		
		location.href=`/manage?searchItem=`+searchItem+`&searchWord=`+searchWord+`&searchPage=1&rowOfPage=`+rowOfPage;
	})
</script>

<!-- 페이징 처리에 관한 script -->
<script>
	// 이전 페이지 버튼 클릭 시
	$("#prevBtn").on("click", function(){
		// 검색 조건
		let searchItem = $("#searchItem").val();
		let searchWord = $(".searchWord").val();
		
		// 페이지
		let searchPage = Number($("#currPage").html())-1;
		let rowOfPage = $("#rowOfPage").val();
		
		// 정렬 조건
		// let orderItem = $(".sorted").attr("data-item");
		// let orderType = getOrderOption(sign);
		
		location.href=`/manage?searchItem=`+searchItem+`&searchWord=`+searchWord+`&searchPage=`+searchPage+`&rowOfPage=`+rowOfPage;
	})
	// 다음 페이지 버튼 클릭 시
	$("#nextBtn").on("click", function(){
		// 검색 조건
		let searchItem = $("#searchItem").val();
		let searchWord = $(".searchWord").val();
		
		// 페이지
		let searchPage = Number($("#currPage").html())+1;
		let rowOfPage = $("#rowOfPage").val();
		
		// 정렬 조건
		// let orderItem = $(".sorted").attr("data-item");
		// let orderType = getOrderOption(sign);
		
		location.href=`/manage?searchItem=`+searchItem+`&searchWord=`+searchWord+`&searchPage=`+searchPage+`&rowOfPage=`+rowOfPage;
	})
	// 페이지 보기 변경 시
	$("#rowOfPage").on("change", function(){
		// 검색 조건
		let searchItem = $("#searchItem").val();
		let searchWord = $(".searchWord").val();
		
		// 페이지
		let rowOfPage = $("#rowOfPage").val();
		
		// 정렬 조건
		// let orderItem = $(".sorted").attr("data-item");
		// let orderType = getOrderOption(sign);
		
		location.href=`/manage?searchItem=`+searchItem+`&searchWord=`+searchWord+`&searchPage=1&rowOfPage=`+rowOfPage;
	})
</script>

<!-- 정렬에 관한 script
<script>
	$(".sort").on("click", function(){
		// 정렬 항목 받아오기
		let orderItem = $(this).attr("data-item");
		
		$(".sort").removeClass("sorted");
		$(this).addClass("sorted");
		
		// 정렬 기준 받아오기
		let sign = $(this).text();

		// 다른 정렬 항목 초기화
		$(".sort").text("-");
		
		// 정렬 기준 기호를 문자열으로 변경
		let orderType = getOrderOption(sign);
		
		// 검색 값 받아오기
		let searchItem = $("#searchItem").val();
		let searchWord = $(".searchWord").val();
		let rowOfPage = $("#rowOfPage").val();
		
		// 검색 요청
		location.href=`/manage?searchItem=`+searchItem+`&searchWord=`+searchWord+`&searchPage=1&rowOfPage=`+rowOfPage+`&orderItem=`+orderItem+`&orderType=`+orderType;
	})
	
	// 정렬 기준 기호를 문자열로 변환하는 함수
	function getOrderOption(sign) {
		if (sign === "↓") {
			$(".sorted").text("-");
			return "NONE";
		} else if (sign === "↑") {
			$(".sorted").text("↓");
			return "DESC";
		} else {
			$(".sorted").text("↑");
			return "ASC";
		}
	}
</script>
 -->
 
</html>

