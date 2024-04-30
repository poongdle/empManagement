package prc.emp.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import prc.emp.domain.DeptDTO;
import prc.emp.domain.EmpDTO;

@Mapper
public interface ManageMapper2 {

	// 전체 사원 조회
	List<EmpDTO> findAll();

	// 전체 부서 조회
	List<DeptDTO> findDept();
	
	// 사원 검색
	List<EmpDTO> searchEmp(@Param("searchDept") int searchDept, @Param("searchWord") String searchWord, @Param("isName") boolean isName);

	// 부서 검색
	List<DeptDTO> searchDept(@Param("searchDept") int searchDept, @Param("searchWord") String searchWord, @Param("isName") boolean isName);

	// 직업 조회
	List<String> findJob();

	// 매니저 후보 조회
	List<Integer> findEmpno();

	// 매니저 조회
	List<Integer> findMgr();

	// 사원 추가
	void insertEmp(@Param("insertEmpList") List<EmpDTO> insertEmpList);

	// 사원 수정
	void updateEmp(@Param("updateEmpList") List<EmpDTO> updateEmpList);

	// 사원 삭제
	void deleteEmp(@Param("deleteEmpList") List<EmpDTO> deleteEmpList);

	// 부서 추가
	void insertDept(@Param("insertDeptList") List<DeptDTO> insertDeptList);

	// 부서 수정
	void updateDept(@Param("updateDeptList") List<DeptDTO> updateDeptList);

	// 부서에 해당하는 사원 삭제
	void deleteEmpOfDept(@Param("deleteDeptList") List<DeptDTO> deleteDeptList);
	
	// 부서에 해당하는 사원 수정
	void updateEmpOfDept(@Param("deleteDeptList") List<DeptDTO> deleteDeptList);
	
	// 부서 삭제
	void deleteDept(@Param("deleteDeptList") List<DeptDTO> deleteDeptList);
}
