-- Задача 3: найти всех менеджеров (RoleName = 'Менеджер'), у которых есть подчиненные.
-- Вывести: EmployeeID, Name, ManagerID, DepartmentName, RoleName, ProjectNames, TaskNames, TotalSubordinates (все подчиненные по иерархии).
-- Используем рекурсию для подсчета всех подчиненных.

WITH RECURSIVE SubordinateCounts AS (
    -- Базовый уровень: каждый сотрудник сам себе
    SELECT 
        EmployeeID AS RootID,
        EmployeeID AS SubordinateID,
        0 AS Level
    FROM Employees
    
    UNION ALL
    
    -- Рекурсивный уровень: добавляем подчиненных
    SELECT 
        sc.RootID,
        e.EmployeeID AS SubordinateID,
        sc.Level + 1
    FROM SubordinateCounts sc
    INNER JOIN Employees e ON e.ManagerID = sc.SubordinateID
),
TotalSubordinates AS (
    SELECT 
        RootID AS EmployeeID,
        COUNT(SubordinateID) - 1 AS TotalSubordinates  -- вычитаем самого себя
    FROM SubordinateCounts
    GROUP BY RootID
),
ManagerEmployees AS (
    SELECT 
        e.EmployeeID,
        e.Name,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    JOIN Roles r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'
),
EmployeeInfo AS (
    SELECT 
        me.EmployeeID,
        me.Name,
        me.ManagerID,
        d.DepartmentName,
        r.RoleName,
        COALESCE(ts.TotalSubordinates, 0) AS TotalSubordinates
    FROM ManagerEmployees me
    LEFT JOIN Departments d ON me.DepartmentID = d.DepartmentID
    LEFT JOIN Roles r ON me.RoleID = r.RoleID
    LEFT JOIN TotalSubordinates ts ON me.EmployeeID = ts.EmployeeID
    WHERE COALESCE(ts.TotalSubordinates, 0) > 0
),
EmployeeProjects AS (
    SELECT 
        ei.EmployeeID,
        STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName) AS ProjectNames
    FROM EmployeeInfo ei
    LEFT JOIN Projects p ON ei.DepartmentID = p.DepartmentID
    GROUP BY ei.EmployeeID
),
EmployeeTasks AS (
    SELECT 
        t.AssignedTo AS EmployeeID,
        STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName) AS TaskNames
    FROM Tasks t
    GROUP BY t.AssignedTo
)
SELECT 
    ei.EmployeeID,
    ei.Name AS EmployeeName,
    ei.ManagerID,
    ei.DepartmentName,
    ei.RoleName,
    ep.ProjectNames,
    et.TaskNames,
    ei.TotalSubordinates
FROM EmployeeInfo ei
LEFT JOIN EmployeeProjects ep ON ei.EmployeeID = ep.EmployeeID
LEFT JOIN EmployeeTasks et ON ei.EmployeeID = et.EmployeeID
ORDER BY ei.Name;