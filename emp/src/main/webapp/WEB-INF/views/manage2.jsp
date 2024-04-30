<%@ page language="java" contentType="text/html; charset=UTF8"  pageEncoding="UTF8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    .deleted * {
    	text-decoration: line-through;
		color: red;
    }
    .deleted .status::after {
    	content: "D";
    	color: red;
    }
    .modified .status::after {
    	content: "U";
    	color: orange;
    }
    .new .status::after {
    	content: "N";
    	color: blue;
    }
</style>
</head>
<body>
	<div>
		<div>
			<h2 align="center" style="max-width: 1380px;"><a href="/manage2">사원 관리 페이지</a></h2>
		</div>
		
		<div>
			<div id="searchArea" style="border: 2px solid skyblue; max-width: 1380px; padding: 5px">
				&nbsp 부서번호/부서명
				<select id="searchDept">
					<option value="-1">선택안함</option>
					<c:forEach items="${deptList}" var="dept" >
						<option value="${dept.deptno}">${dept.deptno} / ${dept.dname}</option>
					</c:forEach>
				</select>
				&nbsp &nbsp 사원번호/사원명
				<input class="searchWord" value="${searchWord}">
				&nbsp &nbsp
				<button id="searchBtn">조회</button>
			</div>
			<br>
			<div id="tableArea">
				<div id="deptArea" style="float: left; padding: 10px">
					<div id="printDeptCntArea" style="float: left; padding: 10px;">
					* 부서 목록 ( 총 ${fn:length(searchedDeptList)}개 )
					</div>
					<div id="deptBtnArea" style="padding: 5px">	
						<button id="addDeptBtn">신규</button>
						<button id="deleteDeptBtn">삭제</button>
						<button id="cancelDeptBtn">취소</button>
						<button id="saveDeptBtn">저장</button>
					</div>
					<table style="float: left;">
						<thead>
							<tr style="background-color: skyblue">
								<td></td>
								<td width="20px"></td>
								<td width="40px"><b>No.</b></td>
								<td width="80px"><b>부서번호</b></td>
								<td width="120px"><b>부서명</b></td>
								<td width="110px"><b>지역</b></td>
							</tr>
						</thead>
						<tbody id="deptTbody">
							<c:choose>
								<c:when test="${empty searchedDeptList}">
									<tr>
										<td colspan="6">검색 결과가 없습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach items="${searchedDeptList}" var="dept">
										<c:if test="${dept.deptno != 0}">
											<tr class="dept origin">
												<td><input type="checkbox" class="ckBox" value="${dept.deptno}"></td>
												<td class="status"></td>
												<td class="deptNo"><b>${dept.no}</b></td>
												<td class="deptno">${dept.deptno}</td>
												<td><input class="change" name="dname" value="${dept.dname}" style="width: 120px;" data-old-val="${dept.dname}"></td>
												<td><input class="change" name="loc" value="${dept.loc}" style="width: 100px;" data-old-val="${dept.loc}"></td>
											</tr>
										</c:if>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
				<div id="empArea" style="float: left; padding: 10px">
					<div id="printEmpCntArea" style="float: left; padding: 10px;">
						* 사원 목록 ( 총 ${fn:length(empList)}명 )
					</div>
					<div id="empBtnArea" style="padding: 5px;">	
						<button id="addEmpBtn">신규</button>
						<button id="deleteEmpBtn">삭제</button>
						<button id="cancelEmpBtn">취소</button>
						<button id="saveEmpBtn">저장</button>
					</div>
					<table style="float: left;">
						<thead id="empThead">
							<tr style="background-color: skyblue">
								<td><input type="checkbox" id="empCkAll"></td>
								<td width="20px"></td>
								<td width="40px"><b>No.</b></td>
								<td width="80px"><b>사원번호</b></td>
								<td width="120px"><b>사원명</b></td>
								<td width="110px"><b>직업</b></td>
								<td width="80px"><b>매니저</b></td>
								<td width="120px"><b>입사일자</b></td>
								<td width="70px"><b>연봉</b></td>
								<td width="70px"><b>보너스</b></td>
								<td width="80px"><b>부서번호</b></td>
							</tr>
						</thead>
						<tbody id="empTbody">
							<c:choose>
								<c:when test="${empty empList}">
									<tr id="noResultEmp">
										<td colspan="11">검색 결과가 없습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<c:forEach items="${empList}" var="emp">
										<tr class="emp origin">
											<td><input type="checkbox" class="ckBox" value="${emp.empno}"></td>
											<td class="status"></td>
											<td class="empNo"><b>${emp.no}</b></td>
											<td class="empno">${emp.empno}</td>
											<td class="ename">${emp.ename}</td>
											<td>
												<select class="change" name="job" data-old-val="${empty emp.job ? '' : emp.job}">
													<option value="">선택안함</option>
													<c:forEach items="${jobList}" var="job">
														<c:choose>
															<c:when test="${job == emp.job}">
																<option value="${job}" selected>${job}</option>
															</c:when>
															<c:otherwise>
																<option value="${job}">${job}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
													<option value="add">추가</option>
												</select>
											</td>
											<td>
												<select class="change" name="mgr" data-old-val="${empty emp.mgr? 0 : emp.mgr}">
													<option value="0">선택안함</option>
													<c:forEach items="${empnoList}" var="empno">
														<c:choose>
															<c:when test="${empno == emp.mgr}">
																<option value="${empno}" selected>${empno}</option>
															</c:when>
															<c:when test="${empno != emp.empno}">
																<option value="${empno}">${empno}</option>
															</c:when>
														</c:choose>
													</c:forEach>
												</select>
											</td>
											<td>
												<input class="change" name="hiredate" type="date" data-old-val="${emp.hiredate}" value="${emp.hiredate}">
											</td>
											<td>
												<input class="change" name="sal" type="number" data-old-val="${emp.sal}" value="${emp.sal}" style="width: 60px;">
											</td>
											<td>
												<input class="change" name="comm" type="number" data-old-val="${emp.comm}" value="${emp.comm}" style="width: 60px;">
											</td>
											<td>
												<select class="change" name="deptno" data-old-val="${empty emp.deptno? 0 : emp.deptno}">
													<option value="0">선택안함</option>
													<c:forEach items="${deptList}" var="dept">
														<c:choose>
															<c:when test="${dept.deptno == emp.deptno}">
																<option value="${dept.deptno}" selected>${dept.deptno}</option>
															</c:when>
															<c:otherwise>
																<option value="${dept.deptno}">${dept.deptno}</option>
															</c:otherwise>
														</c:choose>
													</c:forEach>
												</select>
											</td>
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>

<!-- 정보 가져오기 -->
<script>
	// 부서번호 리스트
	let dList = [];
	<c:forEach items="${deptList}" var="dept">
		dList.push(${dept.deptno});
	</c:forEach>
	
	// 직업 리스트
	let jList = [];
	<c:forEach items="${jobList}" var="job">
		jList.push("${job}");
	</c:forEach>
	
	// 매니저 후보 리스트
	let empnoList = ${empnoList};
	
	// 매니저 리스트
	let mgrList = ${mgrList};
</script>

<!-- 체크 박스와 관련된 script -->
<script>
	const empCkAll = $("#empCkAll");
	let empCkBoxes = $(".emp .ckBox");
	
	// 사원 - 전체 체크 박스 선택
	$(empCkAll).on("click", function() {
		
		// 각 체크박스를 돌며 체크/해제 작업
		$(".emp .ckBox").each(function() {
			$(this).prop("checked", empCkAll.prop("checked"));
		});
	});
	
	// 사원 - 개별 체크 박스 선택
	$(empCkBoxes).on("click", function() {
		// 체크 해제 시 [전체 체크 박스] 해제
		if(!$(this).prop("checked")) {
			empCkAll.prop("checked", false);
			return;
		}
		
	 	// 전체 체크 시 [전체 체크 박스] 체크
		if ($(".emp .ckBox").length === $(".emp .ckBox:checked").length) {
			empCkAll.prop("checked", true);
		}
	});
	
	// 부서 - 개별 체크 박스 선택
	$(".dept.origin .ckBox").on("click", function () {
		
		// 선택된 부서 번호로 사원 조회
		if($(this).prop("checked")) location.href=`/manage2?searchDept=`+$(this).val();
		else location.href=`/manage2`;
	})
</script>

<!-- 조회와 관련된 script -->
<script>
	// 검색 조건 유지
	$(document).ready(function(){
		// url에서 파라미터 값 받아오기
		let params = new URLSearchParams(window.location.search);
		let searchDept = params.get("searchDept");
		let searchWord = params.get("searchWord");

		// 검색 조건 유지
		if (searchDept) {
			let ckBox = $(".dept .ckBox[value='"+searchDept+"']");
			
			// 부서번호/부서명 유지
			$("#searchDept").val(searchDept);
			
			// 체크박스 유지
			ckBox.prop("checked", true);
		}
		if (searchWord) $(".searchWord").val(searchWord);
	});
	
	// 사원번호/사원명
	
	// [조회] 버튼 클릭 시
	$("#searchBtn").on("click", function () {
		let searchDept = $("#searchDept").val();
		let searchWord = $(".searchWord").val().toUpperCase();
		
		if (searchDept == -1 && !searchWord) location.href=`/manage2`;
		else location.href=`/manage2?searchDept=`+searchDept+`&searchWord=`+searchWord;
	});
</script>

<!-- option 태그 생성하는 함수 -->
<script>
	function createOption(name, list) {
		let opt = `<select name="`+name+`">
			  			<option value="">선택안함</option>`;
		
		for(let li of list) {
			opt += `<option value="`+li+`">`+li+`</option>`;
		}
		
		opt += `</select>`;
		
		return opt;
	}
	
	function createChangeOption(name, list, oldVal) {
		let opt = `<select name="`+name+`" class="change" data-old-val="`+oldVal+`">
			<option value="">선택안함</option>`;
	
		for(let li of list) {
			if(li === oldVal) {
				opt += `<option value="`+li+`" selected>`+li+`</option>`;
			} else {
				opt += `<option value="`+li+`">`+li+`</option>`;
			}
		}
		
		opt += `<option value="add">추가</option></select>`;
		
		return opt;
	}
</script>

<!-- [신규] 버튼과 관련된 script -->
<script>
	// 사원 - [신규] 버튼 선택 시 신규 행 추가
	$("#addEmpBtn").on("click", function () {
		// 최대 No. 값 가져오기
		let max = Number($("#empTbody .empNo:last").text())+1;
		
		// 추가할 html 코드 만들기
		let content = `<tr class="emp new">
							<td><input type="checkbox" class="ckBox" checked></td>
							<td class="status"></td>
							<td class="empNo"><b>`+max+`</b></td>
							<td><input name="empno" type="number" style="width: 70px;" min="1" max="9999"></td>
							<td><input name="ename" style="width: 110px;"></td>
							<td>`;
		content += `<select name="job"><option value="">선택안함</option>`;
		for(let job of jList) content += `<option value="`+job+`">`+job+`</option>`;
		content += `<option value="add">추가</option></select></td><td>`;
		content += createOption("mbr", empnoList)+`</td><td>`;
		content += `<input type="date" name="hiredate"></td>
					<td><input name="sal" type="number" style="width: 60px;" min="0"></td>
					<td><input name="comm" type="number" style="width: 60px;" min="0"></td><td>`;
		content += createOption("deptno", dList)+`</td></tr>`;
		
		// 만약 사원이 0명이라면 "검색 결과가 없습니다."행 삭제
		if ($("#noResultEmp")) $("#noResultEmp").remove();
			
		// tbody의 마지막 자식으로 추가
		$("#empTbody").append(content);
	});
	
	$("tbody").on("change", ".new [name='job']", function () {
		if ($(this).val() == 'add') {
			$(this).parent().html(`<input class="change" name="job" style="width: 100px;">`);
		}
	})
	
	
	// 부서 - [신규] 버튼 선택 시 신규 행 추가
	$("#addDeptBtn").on("click", function () {
		// 최대 No. 값 가져오기
		let max = Number($("#deptTbody .deptNo:last").text())+1;
		
		// 추가할 html 코드 만들기
		let content = `<tr class="dept new">
							<td><input type="checkbox" class="ckBox" checked></td>
							<td class="status"></td>
							<td class="deptNo"><b>`+max+`</b></td>
							<td><input name="deptno" type="number" style="width: 70px;" min="1" max="9999"></td>
							<td><input name="dname" style="width: 110px;"></td>
							<td><input name="loc" style="width: 100px;"></td></tr>`;
		
		// tbody의 마지막 자식으로 추가
		$("#deptTbody").append(content);
	});
</script>

<!-- 수정과 관련된 script -->
<script>
	// 기존 자료 수정 시
	$("td").on("change", ".change", function () {
		// 수정된 tr 태그
		let tr = $(this).closest("tr");
		
		// 모든 값이 같은지 체크하는 변수
		let isAllEqul = true;
		
		// 해당 tr 태그의 모든 변경 가능한 값을 돌며 체크
		tr.find(".change").each(function () {
			if ($(this).data("old-val") != $(this).val()) {
				isAllEqul = false; // 하나라도 다른 값이 있다면, fasle로 변경
				return; // each문 빠져나감
			}
		})
		
		// 만약 모든 값이 old-val과 같다면 수정 취소
		if (isAllEqul) {
			// modified 클래스 삭제, 체크 박스 해제, "U" flag 삭제 후 함수 종료
			tr.removeClass("modified").find(".ckBox").prop("checked", false);
			tr.find(".status").html("");
			
			// 만약 job이 input 태그라면, option 태그로 다시 변경
			let job = tr.find("input[name='job']");
			if(job.length >= 1) {
				job.parent().html(createChangeOption("job", jList, job.data("old-val")));
			}
			
			// 함수 리턴
			return;
		}
		
		// 만약 새로운 직업을 추가한다면 input 태그로 변경
		if ($(this).val() == "add") {
			let oldval = $(this).data("old-val");
			$(this).parent().html(`<input class="change" name="job" data-old-val="`+oldval+`" value="`+oldval+`" style="width: 100px;">`);
		}
		
		tr.addClass("modified");
		tr.find(".ckBox").prop("checked", true);
	})
</script>

<!-- [취소] 버튼과 관련된 script -->
<script>
	function cancelAddAndModify(checked) {
		// 수정 취소
		if (checked.is(".modified")) {
			
			// 원래 값으로 되돌리기
			checked.removeClass("modified").find(".change").each(function(){
				$(this).val($(this).data("old-val"));
			});
			
			// 만약 job이 input 태그라면, option 태그로 다시 변경
			let job = checked.find("input[name='job']");
			if(job.length >= 1) {
				job.parent().html(createChangeOption("job", jList, job.data("old-val")));
			}
			
		// 추가 취소
		} else if (checked.is(".new")) {
			checked.remove();
		}
	}
	
	// 취소하는 함수
	function cancel(checked){
		checked.closest("tr").each(function () {
			
			// 수정, 추가 취소 작업
			cancelAddAndModify($(this));
			
			// 삭제 취소
			if ($(this).is(".deleted")) {
				// 수정 가능하게 변경
				$(this).removeClass("deleted").find(".change").prop("disabled", false);
			}
		});
		
		// 체크 해제
		checked.prop("checked", false);
	}
	
	// 사원 - [취소] 버튼 클릭 시 수행
	$("#cancelEmpBtn").on("click", function () {
		
		// 수정, 추가, 삭제 취소 작업
		cancel($(".emp .ckBox:checked"));
		
		// 사원이 0명이라면 "검색 결과가 없습니다."행 추가
		let noResult = `<tr id="noResultEmp"><td colspan="11">검색 결과가 없습니다.</td></tr>`
		if ($(".emp").length === 0) $("#empTbody").append(noResult);
		
		// 전체 체크박스 체크 해제
		empCkAll.prop("checked", false);
	});
	
	// 부서 - [취소] 버튼 클릭 시 수행
	$("#cancelDeptBtn").on("click", function () {
		
		// 수정, 추가, 삭제 취소 작업
		cancel($(".dept .ckBox:checked"));
		
		// 만약 부서가 0개라면 "검색 결과가 없습니다."행 추가
		let noResult = `<tr id="noResultDept"><td colspan="6">검색 결과가 없습니다.</td></tr>`
		if ($(".dept").length === 0) $("#deptTbody").append(noResult);
		
		// 만약 전체 부서 체크 해제 시 메인 화면으로
	});
</script>

<!-- [삭제] 버튼과 관련된 script -->
<script>
	function deleteOperation(ckBox) {
		ckBox.closest("tr").each(function () {
			// deleted 클래스 추가
			$(this).addClass("deleted");
			
			// 추가, 수정 취소
			cancelAddAndModify($(this));
			
			// 수정 막기
			$(this).find(".change").not(".ckBox").prop("disabled", true);
		});
	}
	
	// 사원 - [삭제] 버튼 클릭 시 수행
	$("#deleteEmpBtn").on("click", function(){
		// 삭제 작업
		deleteOperation($(".emp .ckBox:checked"));
		
		// 만약 사원이 0명이라면 "검색 결과가 없습니다."행 추가
		let noResult = `<tr id="noResultEmp"><td colspan="11">검색 결과가 없습니다.</td></tr>`
		if ($(".emp").length === 0) $("#empTbody").append(noResult);
	});
	
	// 부서 - [삭제] 버튼 클릭 시 수행
	$("#deleteDeptBtn").on("click", function () {
		// 삭제 작업
		deleteOperation($(".dept .ckBox:checked"));
	});
</script>

<!-- [저장] 버튼과 관련된 script -->
<script>
	// 사원 - [저장] 버튼 클릭 시 수행
	$("#saveEmpBtn").on("click", function(){
		if(confirm("선택한 수정 사항을 저장하시겠습니까?")) {
			let data = [];
			
			// 신규 사원 추가
			data[0] = addNewEmps();
			
			// 기존 사원 변경
			data[1] = editOldEmps();
			
			// 기존 사원 삭제
			data[2] = deleteOldEmps();
			
			// null 값은 제거
			data = data.filter(function (val) {
				return val != null;
			});
			
			// 만약 하나라도 유효한 값이 있으면
			if (data.length > 0) {
				// 값 전달
				$.ajax({
					type : "POST",
					url : "/manage2/save/emp",
					contentType: "application/json",
					data : JSON.stringify(data),
					success : function(data){
						console.log(data);
						// 페이지 새로고침
						setTimeout(() => {
							location.reload();
						}, 1000);
					}, error : function(xhr, status, error){
			            alert(xhr.responseText);
					}
				});
			} // if
		} // if
	});
	
	// 부서 - [저장] 버튼 클릭 시 수행
	$("#saveDeptBtn").on("click", function () {
		
		if(confirm("선택한 수정 사항을 저장하시겠습니까?")) {
			let data = [];
			
			// 신규 부서 추가
			data[0] = addNewDepts();
				
			// 기존 부서 변경
			data[1] = editOldDepts();
			
			// 기존 부서 삭제
			data[2] = deleteOldDepts();
			
			// null 값은 제거
			data = data.filter(function (val) {
				return val != null;
			});
			
			// 만약 하나라도 유효한 값이 있으면
			if (data.length > 0) {
				// 값 전달
				$.ajax({
					type : "POST",
					url : "/manage2/save/dept",
					contentType: "application/json",
					data : JSON.stringify(data),
					success : function(data){
						console.log("success");
						// 페이지 새로고침
						setTimeout(() => {
							location.reload();
						}, 1000);
					}, error : function(xhr, status, error){
			            alert(xhr.responseText);
					}
				});
			} // if
		} // if
	});
</script>

<!-- 신규 사원 추가하는 함수 -->
<script>
	//신규 사원 값 체크해서 반환하는 함수
	function addNewEmps(){
		// 신규 사원 추가값 받아오기
		let newEmpObj;
		let newEmpObjList = [];
		let newEmpCkBoxes = Array.from($(".emp.new .ckBox:checked"));
		
		// 체크된 사원 하나씩 돌며 확인
		for (let newEmpCkBox of newEmpCkBoxes) {
			let emp = $(newEmpCkBox).parent().siblings();
			
			// 입력된 값 저장
			newEmpObj = new Object();
			newEmpObj.empno = emp.find("[name='empno']").val();
			newEmpObj.ename = emp.find("[name='ename']").val().toUpperCase();
			newEmpObj.job = emp.find("[name='job']").val();
			newEmpObj.mgr = emp.find("[name='mgr']").val();
			newEmpObj.hiredate = emp.find("[name='hiredate']").val();
			newEmpObj.sal = emp.find("[name='sal']").val();
			newEmpObj.comm = emp.find("[name='comm']").val();
			newEmpObj.deptno = emp.find("[name='deptno']").val();
			
			// 하나라도 적절하지 않은 값이 있다면, 함수 종료
			if (!checkInsertValues(newEmpObj, newEmpObjList)) return;
			
			// 입사 일자가 없을 시 오늘로 저장
			if (newEmpObj.hiredate === "") newEmpObj.hiredate = new Date();
			
			// 신규 사원 리스트에 저장
			newEmpObjList.push(newEmpObj);
		}
		
		// 신규 사원 리스트 반환
		return newEmpObjList;
	};
	
	// 신규 사원 값 체크하는 함수
	function checkInsertValues(newEmpObj, newEmpObjList) {
		// 사원 번호가 없을 시 저장 취소
		if (newEmpObj.empno === "") {
			alert("사원 번호는 필수 입력 값입니다.");
			return false;
		}
		// 사원 번호가 1~9999가 아닐 시 저장 취소
		if (newEmpObj.empno > 9999 || newEmpObj.empno < 1) {
			alert(newEmpObj.empno + ": 사원 번호는 1~9999 사이여야 합니다.");
			return false;
		}
		// 사원 번호가 기존 사원과 동일할 시 저장 취소
		for(empno of empnoList) {
			if (empno == newEmpObj.empno) {
				alert(newEmpObj.empno + ": 이미 동일한 사원 번호가 존재합니다.");
				return false;
			}
		}
		// 입력된 사원 번호 중 중복이 있을 시 저장 취소
		for(newEmp of newEmpObjList) {
			if(newEmp.empno == newEmpObj.empno){
				alert(newEmpObj.empno + ": 사원 번호는 중복될 수 없습니다.");
				return false;
			}
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
</script>

<!-- 기존 사원 삭제하는 함수 -->	
<script>
	function deleteOldEmps() {
		// 삭제할 사원 번호 받아오기
		let empObj;
		let empObjList = [];
		let deleteEmpCkBoxes = Array.from($(".emp.deleted .ckBox:checked"));
		
		// 체크된 사원 하나씩 돌며 확인
		for (let deleteEmpCkBox of deleteEmpCkBoxes) {
			let empno = deleteEmpCkBox.value;
			
			// 매니저가 아닐 때에만 저장
			if (mgrList.indexOf(Number(empno)) === -1) {
				empObj = new Object();
				empObj.empno = empno;
				empObjList.push(empObj);
				continue;
			}
			alert("매니저는 삭제가 불가능합니다.");
		}
		
		return empObjList;
	}
</script>

<!-- 기존 사원 변경하는 함수 -->
<script>
	// 기존 사원 변경하는 함수
	function editOldEmps() {
		// 기존 사원 수정값 받아오기
		let empObj;
		let empObjList = [];
		let modifiedEmpCkBoxes = Array.from($(".emp.modified .ckBox:checked"));
		
		// 체크된 사원 하나씩 돌며 확인
		for (let modifiedEmpCkBox of modifiedEmpCkBoxes) {
			let emp = $(modifiedEmpCkBox).parent().siblings();
			
			// 변경된 값 저장
			empObj = new Object();
			empObj.empno = emp.filter(".empno").text();
			empObj.job = emp.find("[name='job']").val();
			empObj.mgr = emp.find("[name='mgr']").val();
			empObj.sal = emp.find("[name='sal']").val();
			empObj.comm = emp.find("[name='comm']").val();
			empObj.deptno = emp.find("[name='deptno']").val();
			
			// 하나라도 적절하지 않은 값이 있다면, 함수 종료
			if (!checkModifyValues(empObj)) return;
			
			empObjList.push(empObj);
		}
		
		return empObjList;
	}
	
	// 수정 값 확인하는 함수
	function checkModifyValues(empObj) {
		// 연봉이 음수일 시 저장 취소
		if (empObj.sal < 0) {
			alert(empObj.empno + ": 연봉은 0원 이상이어야 합니다.");
			return false;
		}
		// 보너스가 음수일 시 저장 취소
		if (empObj.comm < 0) {
			alert(empObj.empno + ": 보너스는 0원 이상이어야 합니다.");
			return false;
		}
		return true;
	}
</script>

<!-- 신규 부서 추가하는 함수 -->
<script>
	// 신규 부서 값 체크해서 반환하는 함수
	function addNewDepts(){
		// 신규 부서값 받아오기
		let newDeptObj;
		let newDeptObjList = [];
		let newDeptCkBoxes = Array.from($(".dept.new .ckBox:checked"));
		
		// 체크된 부서 하나씩 돌며 확인
		for (let newDeptCkBox of newDeptCkBoxes) {
			let dept = $(newDeptCkBox).parent().siblings();
			
			// 입력된 값 저장
			newDeptObj = new Object();
			newDeptObj.deptno = dept.find("[name='deptno']").val();
			for (deptno of dList) {
				if (deptno == newDeptObj.deptno){
					alert("이미 동일한 부서 번호가 존재합니다.");
					return null;
				}
			}
			for (newDept of newDeptObjList) {
				if (newDept.deptno == newDeptObj.deptno) {
					alert("부서 번호는 중복될 수 없습니다.")
					return null;
				}
			}
			newDeptObj.dname = dept.find("[name='dname']").val().toUpperCase();
			newDeptObj.loc = dept.find("[name='loc']").val().toUpperCase();
			
			newDeptObjList.push(newDeptObj);
		}
		
		// 신규 부서 리스트 반환
		return newDeptObjList;
	};
</script>

<!-- 기존 부서 삭제하는 함수 -->
<script>
	function deleteOldDepts() {
		// 삭제할 부서 번호 받아오기
		let deptObj;
		let deptObjList = [];
		let deleteDeptCkBoxes = Array.from($(".dept.deleted .ckBox:checked"));
		
		// 체크된 부서 하나씩 돌며 확인
		for (let deleteDeptCkBox of deleteDeptCkBoxes) {
			deptObj = new Object();
			
			// 해당 부서의 사원이 1명 이상이라면
			if (${fn:length(empList)} > 0) {
				// cascade 옵션 물어보기
				deptObj.cascade = false;
				if (confirm("부서에 있는 사원도 전부 삭제하겠습니까?")){
					deptObj.cascade = true;
				}
			}
			
			// 삭제할 부서 번호 저장
			deptObj.deptno = deleteDeptCkBox.value;
			console.log(deptObj.deptno);
			deptObjList.push(deptObj);
		}
		
		return deptObjList;
	}
</script>

<!-- 기존 부서 변경하는 함수 -->
<script>
	function editOldDepts() {
		// 기존 부서 수정값 받아오기
		let deptObj;
		let deptObjList = [];
		let modifiedDeptCkBoxes = Array.from($(".dept.modified .ckBox:checked"));
		
		// 체크된 부서 하나씩 돌며 확인
		for (let modifiedDeptCkBox of modifiedDeptCkBoxes) {
			let dept = $(modifiedDeptCkBox).parent().siblings();
			
			// 변경된 값 저장
			deptObj = new Object();
			deptObj.deptno = dept.filter(".deptno").text();
			deptObj.dname = dept.find("[name='dname']").val();
			deptObj.loc = dept.find("[name='loc']").val();
			
			deptObjList.push(deptObj);
		}
		
		return deptObjList;
	}
</script>

</html>

