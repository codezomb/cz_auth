module CzAuth
  class AuthenticationController < ApplicationController
    skip_before_filter { :"authorize_#{model}!" }

    def create
      resource = model.where(email: params[:email]).first
      @authenticated = perform_authentication_for(resource || model)
      render @authenticated ? 'create' : 'invalid'
    end

    def destroy
      delete_session_cookie
    end

    private

      def resource_param
        "#{params[:resource]}".classify
      end

      def model
        resource = "#{resource_param}".constantize
      end

  end
end