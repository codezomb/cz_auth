module CzAuth
  class SessionsController < ApplicationController

    skip_before_filter { :"authorize_#{resource_model}!" }
    respond_to :json, except: :new

    def new
      redirect_to root_url and
        return if resource_signed_in?(params[:resource])
      respond_with resource_model.new
    end

    def create
      resource = resource_model.where(email: params[:email]).first
      @authenticated = perform_authentication_for(resource || resource_model)
      respond_to do |format|
        format.html { handle_create_html_response }
        format.json { handle_create_json_response }
      end
    end

    def destroy
      session[:auth_token] = nil
      redirect_to root_url
    end

    private

      # Sanitize the resource param
      def resource_param
        "#{params[:resource]}".classify
      end

      # Constantize the resource model
      def resource_model
        resource = "#{resource_param}".constantize
      end

      # Helper method to clean up controller action
      def handle_create_html_response
        if @authenticated
          redirect_to root_url
        else
          flash[:error] = "Invalid Login. Please try again."
          redirect_to cz_auth.new_resource_session_url
        end
      end

      # Helper method to clean up controller action
      def handle_create_json_response
        render @authenticated ? 'create' : 'invalid'
      end

  end
end