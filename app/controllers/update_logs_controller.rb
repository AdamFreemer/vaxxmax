class UpdateLogsController < ApplicationController
  def index
    @update_logs = UpdateLog.all
  end

  private

  def set_update_log
    @update_log = UpdateLog.find(params[:id])
  end

  def update_log_params
    params.require(:update_log).permit(:task)
  end
end
