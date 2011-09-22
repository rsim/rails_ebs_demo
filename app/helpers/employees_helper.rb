module EmployeesHelper
  def highlight_q(text)
    if params[:q].blank? || text.blank?
      text
    else
      highlight text, params[:q].split(/\s+/)
    end
  end
end
