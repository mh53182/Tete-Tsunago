class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, if: :admin_url
  # before_action :set_current_customer, unless: :admin_url

  def admin_url
    request.fullpath.include?("/admin")
  end

end
