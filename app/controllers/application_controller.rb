class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private
  def record_not_found
    render html: "Record <strong>not found</strong>", status: 404
  end
end

