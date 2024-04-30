package prc.emp.service;

import java.util.List;

import prc.emp.domain.DeptDTO;
import prc.emp.domain.EmpDTO;

public interface ManageService2 {

	// 전체 조회
	List<DeptDTO> findDept();
	List<EmpDTO> findAll();

	// 검색
	List<EmpDTO> searchEmp(int searchDept, String searchWord);
	List<DeptDTO> searchDept(int searchDept, String searchWord);

	// 기타 조회
	List<String> findJob();
	List<Integer> findEmpno();
	List<Integer> findMgr();

	// 추가, 수정, 삭제 작업
	boolean saveEmp(List<List<EmpDTO>> data);
	boolean saveDept(List<List<DeptDTO>> data);

}
