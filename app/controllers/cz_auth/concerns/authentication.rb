module CzAuth
  module Concerns
    module Authentication

      extend ActiveSupport::Concern

      included do
        authentication_models.each do |model|
          create_helper_methods_for(model)
        end
      end

      module ClassMethods

        # Determine which models are used for authentication
        def authentication_models
          @authentication_models ||= begin
            Dir.glob("app/models/*.rb").map do |file|
              model = File.basename(file, File.extname(file))
              resource = model.classify.constantize
              if resource.instance_methods.include?(:password)
                model
              end
            end
          end
        end

        # Defines helper methods, such as current_user
        def create_helper_methods_for(model)
          define_method(:"current_#{model}")       { current_resource(model)       }
          define_method(:"#{model}_signed_in?")    { resource_signed_in?(model)    }
          define_method(:"authenticate_#{model}!") { authenticate_resource!(model) }
          helper_method :"current_#{model}", :"#{model}_signed_in?"
        end

      end

      protected

        # Convenience method to wrap authentication method, and cookie creation
        def perform_authentication_for(resource)
          authenticated = resource.try(:authenticate, credentials[:password] || auth_token)
          create_session_for(authenticated)
          return authenticated
        end

        # Create a cookie with the auth_token as the value
        # Will set expiration to the return value of session_length
        def create_session_for(resource)
          if defined?(session) && !!resource
            session[:auth_token] = resource.auth_token
          end
        end

        # Fetch the auth_token from either the URL, or HTTP Header
        def auth_token
          auth_token = request.headers["X-AUTH-TOKEN"] || params[:auth_token]
          auth_token ||= session[:auth_token] if defined?(session)
          auth_token
        end

      private

        # Simple credentials object
        def credentials
          { email: params[:email], password: params[:password], auth_token: auth_token }
        end

        # Simple finder to get resource, or return the class
        def query_resource(model)
          klass = model.classify.constantize
          klass.where(auth_token: auth_token).first || klass
        rescue NoMethodError => e
          klass
        end

        # Returns an instance of the currently authenticated resource, or nil
        def current_resource(var)
          @current_resource ||= perform_authentication_for(query_resource(var))
        end

        # Returns boolean describing whether or not a resource is currently signed in
        def resource_signed_in?(var)
          @resource_signed_in ||= !!current_resource(var)
        end

        # Called to protect a controller
        # Throws a CzAuth::UnauthorizedAccess if unable to verify existing authentication
        # Can be rescued from to customize handling
        def authenticate_resource!(var)
          raise CzAuth::UnauthorizedAccess unless resource_signed_in?(var)
        end

    end
  end
end

# Simple exception object, can be rescued from to handle response
class CzAuth::UnauthorizedAccess < StandardError;end
