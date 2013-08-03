module CzAuth
  class ApplicationController < ActionController::Base
    include CzAuth::Concerns::Authentication
    respond_to :html, :json
  end
end