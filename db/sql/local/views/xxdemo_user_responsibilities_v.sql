CREATE OR REPLACE FORCE VIEW apps.xxdemo_user_responsibilities_v AS
SELECT ur.user_id user_id
    ,ur.responsibility_id
    ,ur.responsibility_application_id
    ,ur.start_date
    ,ur.end_date
    ,r.start_date AS responsibility_start_date
    ,r.end_date AS responsibility_end_date
    ,r.responsibility_key key
    ,rt.responsibility_name NAME
    ,m.menu_name AS menu_code
FROM
    fnd_user_resp_groups_all ur,
    fnd_application a,
    fnd_responsibility r,
    fnd_responsibility_tl rt,
    fnd_menus m
WHERE a.application_short_name in ('PER','HR')
  AND a.application_id = ur.responsibility_application_id
  AND r.responsibility_id = rt.responsibility_id
  AND r.application_id = rt.application_id
  AND rt.language = 'US'
  AND r.application_id = a.application_id
  AND ur.responsibility_id = r.responsibility_id
  AND m.menu_id = r.menu_id
