module CzAuth
  class ApplicationController < ActionController::Base
    include CzAuth::Concerns::Authentication
  end
end