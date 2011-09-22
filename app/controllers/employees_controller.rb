class EmployeesController < ApplicationController
  before_filter :login_required

  def index
    @employees = Employee.search(params[:q]).order(:last_name, :first_name).page params[:page]
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      render :json => @employee.to_json
    else
      render :json => @employee.errors, :status => :unprocessable_entity
    end
  end

end
