package prc.emp.domain;

import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class DeptDTO {
	
	int no;
	
	int deptno;
	String dname;
	String loc;
	
	boolean cascade;
}
