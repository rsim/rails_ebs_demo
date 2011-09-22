CREATE OR REPLACE FORCE VIEW apps.xxdemo_employees_v AS
SELECT
  p.person_id id,
  p.full_name,
  p.first_name,
  p.last_name,
  p.email_address,
  p.employee_number,
  p.effective_start_date,
  p.effective_end_date,
  p.object_version_number,
  p.business_group_id,
  bg.name business_group_name,
  a.organization_id,
  o.name organization_name,
  a.supervisor_id,
  a.effective_start_date AS assignment_start_date,
  a.effective_end_date   AS assignment_end_date
FROM
  per_all_people_f p,
  per_all_assignments_f a,
  hr_all_organization_units bg,
  hr_all_organization_units o
WHERE
  p.person_id = a.person_id
  -- filter last employee version
  AND p.rowid IN
  (SELECT FIRST_VALUE(p2.rowid) OVER(PARTITION BY p2.person_id ORDER BY p2.effective_end_date DESC, p2.effective_start_date ASC)
  FROM per_all_people_f p2
  WHERE p2.person_id = p.person_id
  )
  -- filter last assignemnt for each employee
  AND a.assignment_type = 'E'
  AND a.primary_flag    = 'Y'
  AND a.rowid          IN
    (SELECT FIRST_VALUE(a2.rowid) OVER(PARTITION BY a2.person_id ORDER BY a2.effective_end_date DESC, a2.effective_start_date ASC)
    FROM per_all_assignments_f a2
    WHERE a2.person_id     = a.person_id
    AND a2.assignment_type = 'E'
    AND a2.primary_flag    = 'Y'
    )
  AND p.business_group_id = bg.organization_id
  AND bg.name LIKE 'Vision%'
  AND a.organization_id = o.organization_id
