SET ECHO ON
SET FEEDBACK ON
SET LINESIZE 255
SET PAGESIZE 999

--**Q1
SELECT Emp_ID, Fname, Lname , NVL(TO_CHAR(MIN(ROUND(MONTHS_BETWEEN(TO_DATE(SYSDATE) , TO_DATE(Appr_Date)),0))),'N/A') AS MONTHS
FROM Employee 	JOIN DEPARTMENT  USING (Dept_ID)
				LEFT JOIN TRAINING USING (Emp_ID)
WHERE  Dept_Name = 'IT'
GROUP BY Emp_ID, Fname, Lname 
ORDER BY Lname;

--**Q2
SELECT *
FROM(SELECT T.Crs_ID, T.Section, T.Sem_Cmpltd, CO.Crs_Title, TO_CHAR(COUNT(1) * Co.Tuition,'$9999990.99') AS Expense
FROM Training T
JOIN Class C ON C.Crs_ID = T.Crs_ID AND C.Section = T.Section AND C.Sem_Cmpltd = T.Sem_Cmpltd
JOIN Course Co ON Co.Crs_ID = T.Crs_ID
GROUP BY T.Crs_ID, T.Section, T.Sem_Cmpltd, Co.Crs_Title, Co.Tuition
ORDER BY Expense DESC)
WHERE ROWNUM=1;
  
  
--Q3
SELECT Crs_ID,Crs_Title, College_Name, TO_CHAR(MAX(Emp_Count)) AS Popularity
  FROM COURSE JOIN(SELECT CRS_ID,COUNT(EMP_ID) AS Emp_Count
  FROM TRAINING GROUP BY CRS_ID) USING(CRS_ID)
  HAVING MAX(Emp_Count) = (SELECT MAX(Emp_Count)
  FROM COURSE JOIN(SELECT CRS_ID,COUNT(EMP_ID) AS Emp_Count
  FROM TRAINING GROUP BY CRS_ID) USING(CRS_ID))
  GROUP BY Crs_ID,Crs_Title,College_Name;

--Q4
SELECT COUNT(Emp_ID)
FROM Course JOIN TRAINING USING (Crs_ID)
			JOIN EMPLOYEE USING (Emp_ID)
WHERE College_Name = 'Oakland'
AND Appr_Date LIKE '%21%';

--Q5
COLUMN Times FORMAT A6
SELECT Crs_ID, Crs_Title, College_Name, TO_CHAR(Times), Times*Tuition
FROM(
SELECT Crs_ID, Crs_Title, College_Name, COUNT(Crs_ID) AS Times, Tuition
FROM Course JOIN TRAINING USING (Crs_ID)
			JOIN EMPLOYEE USING (Emp_ID)
WHERE Lname = 'Boon'
AND Fname ='Pat'
GROUP BY Crs_ID, Crs_Title, College_Name, Tuition
HAVING COUNT(Crs_ID) > 1)
UNION
SELECT 'Total_Tuition', ' ',' ',' ', SUM(Times *Tuition)
FROM(
SELECT Crs_ID, Crs_Title, COUNT(Crs_ID) AS Times, Tuition
FROM Course JOIN TRAINING USING (Crs_ID)
			JOIN EMPLOYEE USING (Emp_ID)
WHERE Lname = 'Boon'
AND Fname ='Pat'
GROUP BY Crs_ID, Crs_Title, Tuition);

--Q6
COLUMN NAME FORMAT 'A20'
SELECT I.Instr_ID, Fname || ', ' || Lname Name, Phone, Number_of_classes, Number_of_employees 
FROM Instructor I 	LEFT JOIN(SELECT Instr_ID,Count(Instr_ID) Number_of_classes 
							FROM class 
							GROUP BY Instr_ID 
							HAVING Count(*) > 1) C 
					ON C.Instr_ID = I.Instr_ID 
					LEFT JOIN(SELECT Count(DISTINCT T.emp_id) Number_of_employees, Instr_ID
							FROM Training T
							JOIN class C 
							ON C.Crs_ID = T.Crs_ID
							AND C.Section = T.Section 
							AND C.Sem_Cmpltd = T.Sem_Cmpltd 
							GROUP BY Instr_ID) T 
							ON t.Instr_ID = I.Instr_ID 
ORDER BY I.Lname;

--**Q7									
SELECT S.SUP_ID, EE.Fname, ee.Lname, Number_of_Employees
FROM Employee ee 
Join (
SELECT DISTINCT S.sup_id,Count(DISTINCT E.emp_id) AS Number_of_employees
FROM employee S left join(SELECT T.emp_id,sup_id
							FROM training T 
							join employee E 
							ON E.emp_id = T.emp_id 
							join class C 
							ON C.crs_id = T.crs_id 
							AND C.SECTION = T.SECTION  
							AND C.sem_cmpltd = T.sem_cmpltd
							WHERE  C.crs_id IN (SELECT crs_id FROM course 
												WHERE crs_title IN ( 'Java', 'C++' ))  
							AND T.grade <> 'R') E    
							ON E.sup_id = S.sup_id 
							WHERE S.sup_id <> 0 
							GROUP BY S.sup_id
) S ON ee.emp_id = S.sup_id
ORDER BY Number_of_employees DESC;
											
--
-- SELECT S.SUP_ID, EE.Fname, ee.Lname, Number_of_Employees
-- FROM Employee ee 
-- Join (
-- SELECT DISTINCT S.sup_id,
                -- Count(DISTINCT E.emp_id) AS Number_of_employees
-- FROM   employee S
-- left join(

    -- SELECT T.emp_id, E.sup_id
    -- FROM   training T
    -- join employee E ON E.emp_id = T.emp_id
    -- join class C ON C.crs_id = T.crs_id AND C.SECTION = T.SECTION AND C.sem_cmpltd = T.sem_cmpltd
    -- WHERE  C.crs_id IN (SELECT crs_id FROM   course WHERE  crs_title IN ( 'Java', 'C++' )) AND T.grade <> 'R'
    
-- ) E   ON E.sup_id = S.sup_id
   
    
-- WHERE  S.sup_id <> 0
-- GROUP  BY S.sup_id
-- ) S ON ee.emp_id = S.sup_id
-- ORDER BY Number_of_employees DESC; 
												
												
