class BulkRegistersController < ApplicationController
  before_action :check_user_is_admin
  def index
  end

  private
  def check_user_is_admin
    unless Current.user.admin?
      redirect_to root_path
    end
  end
end
