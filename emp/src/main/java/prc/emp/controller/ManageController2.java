package prc.emp.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.AllArgsConstructor;
import prc.emp.domain.DeptDTO;
import prc.emp.domain.EmpDTO;
import prc.emp.service.ManageService2;

@Controller
@AllArgsConstructor
public class ManageController2 {
	
	private final ManageService2 service;
	
	// 조회
	@GetMapping("/manage2")
	public String manage2(Model model
						, @RequestParam(name = "searchDept", required = false) Integer searchDept
						, @RequestParam(name = "searchWord", required = false) String searchWord) {
		System.out.println("Manage2.manage2()");
		
		// 부서 정보 전송
		List<DeptDTO> deptList = service.findDept();
		model.addAttribute("deptList", deptList);
		
		// 사원, 검색된 부서 정보 전송
		List<EmpDTO> empList = null;
		if (searchDept == null) {
			model.addAttribute("searchedDeptList", deptList);
			empList = service.findAll();
		} else {
			model.addAttribute("searchedDeptList", service.searchDept(searchDept, searchWord));
			empList = service.searchEmp(searchDept, searchWord);
		}
		model.addAttribute("empList", empList);
		
		// 직업 정보 전송
		List<String> jobList = service.findJob();
		model.addAttribute("jobList", jobList);
		
		// 매니저 후보 정보 전송
		List<Integer> empnoList = service.findEmpno();
		model.addAttribute("empnoList", empnoList);
		
		// 매니저 정보 전송
		List<Integer> mgrList = service.findMgr();
		model.addAttribute("mgrList", mgrList);
		
		return "/WEB-INF/views/manage2.jsp";
	}
	
	// 사원 변경
	@PostMapping("/manage2/save/emp")
	public ResponseEntity saveEmp(@RequestBody List<List<EmpDTO>> data) {
		System.out.println("Manage2.saveEmp()");
		
		// 추가, 수정, 삭제 작업 수행
		boolean idSuccessed = service.saveEmp(data);
		
		// 성공 여부에 따라 return
		if (idSuccessed) return ResponseEntity.status(HttpStatus.OK).body("저장 성공");
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 실패");
	}
	
	// 부서 변경
	@PostMapping("/manage2/save/dept")
	public ResponseEntity saveDept(@RequestBody List<List<DeptDTO>> data) {
		System.out.println("Manage2.saveDept()");
		
		// 추가, 수정, 삭제 작업 수행
		boolean idSuccessed = service.saveDept(data);
		
		// 성공 여부에 따라 return
		if (idSuccessed) return ResponseEntity.status(HttpStatus.OK).body("저장 성공");
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("저장 실패");
	}

}

