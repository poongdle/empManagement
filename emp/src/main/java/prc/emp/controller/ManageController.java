package prc.emp.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.AllArgsConstructor;
import prc.emp.domain.EmpDTO;
import prc.emp.service.ManageService;

@Controller
@AllArgsConstructor
public class ManageController {
	
	private final ManageService service;
	
	// 조회
	@GetMapping("/manage")
	public String manage(Model model
						, @RequestParam(name = "searchItem", required = false) String searchItem
						, @RequestParam(name = "searchWord", required = false) String searchWord
						, @RequestParam(name = "searchPage", required = false) String searchPage
						, @RequestParam(name = "rowOfPage", required = false) String rowOfPage
						// , @RequestParam(name = "orderItem", required = false) String orderItem
						// , @RequestParam(name = "orderType", required = false) String orderType
						) {
		System.out.println("Manage.manage()");
		
		// 사원 정보 전송
		List<EmpDTO> empList = null;
		if ((searchWord == null || searchWord.equals(""))) { // &&(orderItem == null || orderItem.equals(""))
			System.out.println("전체 조회");
			empList = service.findAll(searchPage, rowOfPage);
		} else {
			System.out.println("검색");
			empList = service.searchEmp(searchItem, searchWord, searchPage, rowOfPage); // , orderItem, orderType
		}
		model.addAttribute("empList", empList);
		
		// 부서 정보 전송
		List<Integer> deptnoList = service.findDeptno();
		model.addAttribute("deptnoList", deptnoList);
		
		// 직업 정보 전송
		List<String> jobList = service.findJob();
		model.addAttribute("jobList", jobList);
		
		// 매니저 정보 전송
		List<Integer> empnoList = service.findEmpno();
		model.addAttribute("empnoList", empnoList);
		
		// 조회 정보 넘겨주기
		System.out.println("searchItem : " + searchItem
						+ ", searchWord : " + searchWord
						+ ", searchPage : " + searchPage
						+ ", rowOfPage : " + rowOfPage);
		model.addAttribute("searchPage", searchPage);
		model.addAttribute("rowOfPage", rowOfPage);
		
		return "/WEB-INF/views/manage.jsp";
	}
	
	// 삭제
	@DeleteMapping("/manage")
	public ResponseEntity manageDelete(@RequestBody List<Integer> empnoList) {
		System.out.println("manage.manageDelete()");
		
		// 삭제 작업 수행
		int rowCnt = service.deleteEmp(empnoList);
		if (rowCnt > 0) {
			return ResponseEntity.status(HttpStatus.OK).body("성공");
		}
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("실패");
	}
	
	// 변경
	@PatchMapping("/manage")
	public ResponseEntity managePatch(@RequestBody List<EmpDTO> empList) {
		System.out.println("manage.managePatch()");
		
		int rowCnt = service.modifyEmp(empList);
		if (rowCnt > 0) {
			return ResponseEntity.status(HttpStatus.OK).body("성공");
		}
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("실패");
	}
	
	// 추가
	@PostMapping("/manage")
	public ResponseEntity manageAdd(@RequestBody List<EmpDTO> empList) {
		System.out.println("manage.manageAdd()");
		
		int rowCnt = service.addEmp(empList);
		if (rowCnt > 0) {
			return ResponseEntity.status(HttpStatus.OK).body("성공");
		}
		
		return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("실패");
	}

}

