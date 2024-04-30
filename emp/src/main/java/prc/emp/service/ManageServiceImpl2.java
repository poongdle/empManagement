package prc.emp.service;

import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;
import prc.emp.domain.DeptDTO;
import prc.emp.domain.EmpDTO;
import prc.emp.mapper.ManageMapper2;

@Service
@AllArgsConstructor
public class ManageServiceImpl2 implements ManageService2 {
	
	private final ManageMapper2 mapper;
	
	// 전체 사원 조회
	@Override
	@Transactional
	public List<EmpDTO> findAll() {
		System.out.println("manageServiceImpl2.findAll()");
		
		return mapper.findAll();
	}

	// 전체 부서 조회
	@Override
	@Transactional
	public List<DeptDTO> findDept() {
		System.out.println("manageServiceImpl2.findDept()");
		return mapper.findDept();
	}
	
	// 사원 검색
	@Override
	@Transactional
	public List<EmpDTO> searchEmp(int searchDept, String searchWord) {
		System.out.println("manageServiceImpl2.searchEmp()");
		System.out.println("검색 부서 : " + searchDept + ", 검색 단어 : " + searchWord);
		
		boolean isName = true;
		if (searchWord != null && searchWord.matches("^[0-9]+$")) isName = false;
		
		return mapper.searchEmp(searchDept, searchWord, isName);
	}

	// 부서 검색
	@Override
	@Transactional
	public List<DeptDTO> searchDept(int searchDept, String searchWord) {
		System.out.println("manageServiceImpl2.searchDept()");
		System.out.println("검색 부서 : " + searchDept + ", 검색 단어 : " + searchWord);

		boolean isName = true;
		if (searchWord != null && searchWord.matches("^[0-9]+$")) isName = false;
		
		return mapper.searchDept(searchDept, searchWord, isName);
	}

	// 직업 조회
	@Override
	@Transactional
	public List<String> findJob() {
		System.out.println("manageServiceImpl2.findJob()");
		return mapper.findJob();
	}

	// 매니저 후보 조회
	@Override
	@Transactional
	public List<Integer> findEmpno() {
		System.out.println("manageServiceImpl2.findEmpno()");
		return mapper.findEmpno();
	}

	// 매니저 조회
	@Override
	@Transactional
	public List<Integer> findMgr() {
		System.out.println("manageServiceImpl2.findMgr()");
		return mapper.findMgr();
	}

	// 사원 추가, 수정, 삭제 작업
	@Override
	@Transactional
	public boolean saveEmp(List<List<EmpDTO>> data) {
		System.out.println("manageServiceImpl2.saveEmp()");
		
		try {
			List<EmpDTO> insertEmpList = data.get(0);
			List<EmpDTO> updateEmpList = data.get(1);
			List<EmpDTO> deleteEmpList = data.get(2);
			
			if (insertEmpList != null && insertEmpList.size() != 0) {
				System.out.println("emp insert start");
				Iterator ir = insertEmpList.iterator();
				while (ir.hasNext()) {
					EmpDTO emp = (EmpDTO) ir.next();
					System.out.println("insert : " + emp.getEmpno());
				}
				mapper.insertEmp(insertEmpList);
			}
			if (updateEmpList != null && updateEmpList.size() != 0) {
				System.out.println("emp update start");
				Iterator ir2 = updateEmpList.iterator();
				while (ir2.hasNext()) {
					EmpDTO emp = (EmpDTO) ir2.next();
					System.out.println("update : " + emp.getEmpno());
				}
				mapper.updateEmp(updateEmpList);
			}
			if (deleteEmpList != null && deleteEmpList.size() != 0) {
				System.out.println("emp delete start");
				Iterator ir3 = deleteEmpList.iterator();
				while (ir3.hasNext()) {
					EmpDTO emp = (EmpDTO) ir3.next();
					System.out.println("delete : " + emp.getEmpno());
				}
				mapper.deleteEmp(deleteEmpList);
			}

			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 부서 추가, 수정, 삭제 작업
	@Override
	public boolean saveDept(List<List<DeptDTO>> data) {
		System.out.println("manageServiceImpl2.saveDept()");
		
		try {
			List<DeptDTO> insertDeptList = data.get(0);
			List<DeptDTO> updateDeptList = data.get(1);
			List<DeptDTO> deleteDeptList = data.get(2);
			
			if (insertDeptList != null && insertDeptList.size() != 0) {
				System.out.println("dept insert start");
				Iterator ir = insertDeptList.iterator();
				while (ir.hasNext()) {
					DeptDTO dept = (DeptDTO) ir.next();
					System.out.println("insert : " + dept.getDeptno());
				}
				mapper.insertDept(insertDeptList);
			}
			if (updateDeptList != null && updateDeptList.size() != 0) {
				System.out.println("dept update start");
				Iterator ir2 = updateDeptList.iterator();
				while (ir2.hasNext()) {
					DeptDTO dept = (DeptDTO) ir2.next();
					System.out.println("update : " + dept.getDeptno());
				}
				mapper.updateDept(updateDeptList);
			}
			if (deleteDeptList != null && deleteDeptList.size() != 0) {
				System.out.println("dept delete start");
				Iterator ir3 = deleteDeptList.iterator();
				while (ir3.hasNext()) {
					DeptDTO dept = (DeptDTO) ir3.next();
					System.out.println("delete : " + dept.getDeptno());
				}
				
				// 사원 삭제/수정 작업
				if (deleteDeptList.get(0).isCascade()) mapper.deleteEmpOfDept(deleteDeptList);
				else mapper.updateEmpOfDept(deleteDeptList);
				
				mapper.deleteDept(deleteDeptList);
			}
			
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}

