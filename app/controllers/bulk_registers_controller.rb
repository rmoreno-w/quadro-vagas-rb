class BulkRegistersController < ApplicationController
  before_action :check_user_is_admin
  def index
    @bulk_registers = Current.user.bulk_registers
  end

  def new
    @bulk_register = Current.user.bulk_registers.build
  end

  def create
    @bulk_register = Current.user.bulk_registers.build(bulk_register_params)
    @bulk_register.pending!

    if @bulk_register.save
      BulkRegistersFileReadingJob.perform_later(@bulk_register)
      redirect_to bulk_registers_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private
  def check_user_is_admin
    unless Current.user.admin?
      redirect_to root_path
    end
  end

  def bulk_register_params
    params.require(:bulk_register).permit(:user_uploaded_file)
  end
end
