-- Задача 2: как задача 1, но добавить TotalTasks (количество задач сотрудника)
-- и TotalSubordinates (количество прямых подчиненных).
-- Используем рекурсию для получения всех подчиненных Ивана Иванова,
-- затем отдельно считаем прямых подчиненных.

WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый уровень: Иван Иванов
    SELECT 
        EmployeeID,
        Name,
        ManagerID,
        DepartmentID,
        RoleID
    FROM Employees
    WHERE EmployeeID = 1
    
    UNION ALL
    
    -- Рекурсивный уровень: подчиненные
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
),
EmployeeInfo AS (
    SELECT 
        eh.EmployeeID,
        eh.Name,
        eh.ManagerID,
        d.DepartmentName,
        r.RoleName
    FROM EmployeeHierarchy eh
    LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
    LEFT JOIN Roles r ON eh.RoleID = r.RoleID
),
EmployeeProjects AS (
    SELECT 
        e.EmployeeID,
        STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM EmployeeInfo e
    LEFT JOIN Projects p ON e.DepartmentID = p.DepartmentID
    GROUP BY e.EmployeeID
),
EmployeeTasks AS (
    SELECT 
        t.AssignedTo AS EmployeeID,
        STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames,
        COUNT(t.TaskID) AS TotalTasks
    FROM Tasks t
    GROUP BY t.AssignedTo
),
DirectSubordinates AS (
    SELECT 
        ManagerID,
        COUNT(EmployeeID) AS SubCount
    FROM Employees
    GROUP BY ManagerID
)
SELECT 
    ei.EmployeeID,
    ei.Name AS EmployeeName,
    ei.ManagerID,
    ei.DepartmentName,
    ei.RoleName,
    ep.ProjectNames,
    et.TaskNames,
    COALESCE(et.TotalTasks, 0) AS TotalTasks,
    COALESCE(ds.SubCount, 0) AS TotalSubordinates
FROM EmployeeInfo ei
LEFT JOIN EmployeeProjects ep ON ei.EmployeeID = ep.EmployeeID
LEFT JOIN EmployeeTasks et ON ei.EmployeeID = et.EmployeeID
LEFT JOIN DirectSubordinates ds ON ei.EmployeeID = ds.ManagerID
ORDER BY ei.Name;