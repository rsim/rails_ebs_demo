class User < ActiveRecord::Base
  set_table_name "apps.xxdemo_users_v"
  set_primary_key "id"

  has_many :user_responsibilities

  class_attribute :current

  def hrms_manager_responsibility
    user_responsibilities.where("key LIKE '%HRMS_MANAGER'").first
  end

  class MissingCurrentUser < StandardError
  end

  class MissingResponsibility < StandardError
  end

  def initialize_ebs_session
    raise MissingResponsibility unless responsibility = hrms_manager_responsibility
    plsql.fnd_global.apps_initialize(id, responsibility.responsibility_id, responsibility.responsibility_application_id)
    plsql.hr_signon.initialize_hr_security
  end

  def self.initialize_ebs_session
    raise MissingCurrentUser unless current
    current.initialize_ebs_session
  end

  def self.authenticate(user_name, password)
    authenticator = OracleEbsAuthentication::Authenticator.new
    if authenticator.validate_user_password(user_name, password)
      User.find_by_user_name(user_name.upcase)
    else
      logger.error "AUTHENTICATION: Could not authenticate user #{user_name}"
      nil
    end
  end

end
