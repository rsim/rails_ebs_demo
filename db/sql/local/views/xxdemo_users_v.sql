CREATE OR REPLACE FORCE VIEW apps.xxdemo_users_v AS 
SELECT u.user_id AS id
      ,u.user_name
      ,u.email_address
      ,u.employee_id
      ,u.start_date
      ,u.end_date
FROM fnd_user u
