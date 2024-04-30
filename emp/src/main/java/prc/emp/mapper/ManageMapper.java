package prc.emp.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import prc.emp.domain.EmpDTO;

@Mapper
public interface ManageMapper {

	List<EmpDTO> findAll(@Param("startRow") int startRow, @Param("endRow") int endRow);

	/*
	List<EmpDTO> orderEmp(@Param("searchItem") String searchItem
						 , @Param("startRow") int startRow
						 , @Param("endRow") int endRow
						 , @Param("orderItem") String orderItem
						 , @Param("orderType") String orderType);
	*/
	
	List<EmpDTO> searchEmp(@Param("searchItem") String searchItem
						 , @Param("searchWord") String searchWord
						 , @Param("searchRange1") int searchRange1
						 , @Param("searchRange2") int searchRange2
						 , @Param("startRow") int startRow
						 , @Param("endRow") int endRow
						 ); //, @Param("orderItem") String orderItem	 , @Param("orderType") String orderType

	List<Integer> findDeptno();

	List<String> findJob();

	List<Integer> findEmpno();

	int deleteEmp(@Param("empnoList") List<Integer> empnoList);

	int updateEmp(@Param("emp") EmpDTO emp);

	int insertEmp(@Param("emp") EmpDTO emp);
}
