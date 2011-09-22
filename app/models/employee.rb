class Employee < ActiveRecord::Base
  include ActiveSupport::Benchmarkable

  set_table_name "apps.xxdemo_employees_v"
  set_primary_key "id"

  validates_presence_of :first_name, :last_name

  def self.search(q)
    if q.blank?
      scoped
    else
      i = 0
      parameters = {}
      condition_string = q.split(/\s+/).map do |word|
        i += 1
        key = :"q#{i}"
        parameters[key] = "%#{word.downcase}%"
        '(' <<
        %w(first_name last_name email_address organization_name).map do |column|
          "LOWER(#{column}) LIKE :#{key}"
        end.join(' OR ') << ')'
      end.join(' AND ')
      scoped.where(condition_string, parameters)
    end
  end

  set_update_method do
    benchmark "DEBUG: initialize EBS session" do
      User.current.initialize_ebs_session
    end
    benchmark "DEBUG: update person" do
      plsql.hr_person_api.update_person(
        :p_effective_date => effective_start_date,
        :p_datetrack_update_mode => 'CORRECTION',
        :p_person_id => id,
        :p_object_version_number => object_version_number,
        :p_employee_number => employee_number,
        :p_first_name => first_name,
        :p_last_name => last_name,
        :p_email_address => email_address
      )
    end
  end

end