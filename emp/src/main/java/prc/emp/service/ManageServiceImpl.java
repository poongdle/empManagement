package prc.emp.service;

import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import prc.emp.domain.EmpDTO;
import prc.emp.mapper.ManageMapper;

@Service
@AllArgsConstructor
public class ManageServiceImpl implements ManageService {
	
	private final ManageMapper mapper;
	
	// 전체 조회
	@Override
	@Transactional
	public List<EmpDTO> findAll(String searchPage, String rowOfPage) {
		System.out.println("manageServiceImpl.findAll()");
		
		// null일 경우 기본값으로 return
		if (searchPage == null) return mapper.findAll(1, 5);
		
		// 페이지 첫 행, 마지막 행 계산
		Integer [] startAndEndRow = getRowRange(searchPage, rowOfPage);
		int startRow = startAndEndRow[0];
		int endRow = startAndEndRow[1];
		
		return mapper.findAll(startRow, endRow);
	}
	
	// 검색
	@Override
	@Transactional
	public List<EmpDTO> searchEmp(String searchItem, String searchWord, String searchPage, String rowOfPage) { // , String orderItem, String orderType
		System.out.println("manageServiceImpl.searchEmp()");
		
		// 페이지 첫 행, 마지막 행 계산
		Integer [] startAndEndRow = getRowRange(searchPage, rowOfPage);
		int startRow = startAndEndRow[0];
		int endRow = startAndEndRow[1];
		
		// 사원명 검색인 경우 upperCase
		if (searchItem.equals("ename")) searchWord = searchWord.toUpperCase();
		
		// 범위 검색 시 값 초기화
		Integer [] searchRange = getSearchRange(searchWord);
		int searchRange1 = searchRange[0];
		int searchRange2 = searchRange[1];
		
		/*
		// 검색어가 없을 시 정렬만 수행
		if (searchWord == null || searchWord.equals("")) {
			return mapper.orderEmp(searchItem, startRow, endRow, orderItem, orderType);
		}
		*/
		return mapper.searchEmp(searchItem, searchWord, searchRange1, searchRange2, startRow, endRow); // , orderItem, orderType
	}

	// deptno 조회
	@Override
	@Transactional
	public List<Integer> findDeptno() {
		System.out.println("manageServiceImpl.findDeptno()");
		return mapper.findDeptno();
	}

	// job 조회
	@Override
	public List<String> findJob() {
		System.out.println("manageServiceImpl.findJob()");
		return mapper.findJob();
	}

	// empno 조회
	@Override
	public List<Integer> findEmpno() {
		System.out.println("manageServiceImpl.findEmpno()");
		return mapper.findEmpno();
	}

	// 삭제
	@Override
	@Transactional
	public int deleteEmp(List<Integer> empnoList) {
		System.out.println("manageServiceImpl.deleteEmp()");
		
		// 삭제 요청 리스트 출력
		Iterator<Integer> ir = empnoList.iterator();
		while (ir.hasNext()) {
			int empno = ir.next();
			System.out.println(empno + " 삭제");
		}
		
		// 삭제 작업
		return mapper.deleteEmp(empnoList);
	}

	// 변경
	@Override
	@Transactional
	public int modifyEmp(List<EmpDTO> empList) {
		System.out.println("manageServiceImpl.modifyEmp()");
		
		int rowCnt = 0;
		
		Iterator<EmpDTO> ir = empList.iterator();
		while (ir.hasNext()) {
			EmpDTO emp = ir.next();
			System.out.println(emp.getEmpno() + " 변경");
			rowCnt += mapper.updateEmp(emp);
		}
		
		return rowCnt;
	}

	// 추가
	@Override
	@Transactional
	public int addEmp(List<EmpDTO> empList) {
		System.out.println("manageServiceImpl.addEmp()");
		
		int rowCnt = 0;
		
		Iterator<EmpDTO> ir = empList.iterator();
		while (ir.hasNext()) {
			EmpDTO emp = ir.next();
			System.out.println(emp.getEmpno() + " 추가");
			rowCnt += mapper.insertEmp(emp);
		}
		
		return rowCnt;
	}
	
	
	// 페이지 첫 행, 마지막 행 계산
	private Integer[] getRowRange(String searchPage, String rowOfPage) {
		Integer[] startAndEndRow = new Integer[2];

		int searchPageInt = Integer.parseInt(searchPage);
		int rowOfPageInt = Integer.parseInt(rowOfPage);
		
		startAndEndRow[1] = searchPageInt * rowOfPageInt;
		startAndEndRow[0] = startAndEndRow[1] - rowOfPageInt + 1;
		
		return startAndEndRow;
	}
	
	// 검색 범위 시작값, 끝값 계산
	private Integer[] getSearchRange(String searchWord) {
		Integer[] searchRange = {0, 0};
		
		int indexOfRange = searchWord.indexOf("~");
		
		if (indexOfRange != -1) {
			searchRange[0] = Integer.parseInt(searchWord.substring(0, indexOfRange));
			searchRange[1] = Integer.parseInt(searchWord.substring(indexOfRange+1));
		}
		
		return searchRange;
	}

}

