class UserResponsibility < ActiveRecord::Base
  set_table_name "apps.xxdemo_user_responsibilities_v"
  # actually there is no primary key, just to avoid primary key query
  set_primary_key "user_id"

  belongs_to :user
end
