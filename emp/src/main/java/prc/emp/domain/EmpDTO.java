package prc.emp.domain;

import java.sql.Date;

import org.springframework.stereotype.Component;

import lombok.Getter;

@Component
@Getter
public class EmpDTO {
	
	int no;
	
	int empno;
	String ename;
	String job;
	int mgr;
	Date hiredate;
	int sal;
	int comm;
	int deptno;
	
}
