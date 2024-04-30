package prc.emp.service;

import java.util.List;

import prc.emp.domain.EmpDTO;

public interface ManageService {

	List<EmpDTO> findAll(String searchPage, String rowOfPage);

	List<EmpDTO> searchEmp(String searchItem, String searchWord, String searchPage, String rowOfPage); // , String orderItem, String orderType

	List<Integer> findDeptno();

	List<String> findJob();

	List<Integer> findEmpno();

	int deleteEmp(List<Integer> empnoList);

	int modifyEmp(List<EmpDTO> empList);

	int addEmp(List<EmpDTO> empList);

}
