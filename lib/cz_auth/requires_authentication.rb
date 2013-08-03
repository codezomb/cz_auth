module CzAuth
  module RequiresAuthentication
    extend ActiveSupport::Concern

    module ClassMethods

      def requires_authentication(options = {})
        has_secure_password
        before_create { generate_token(:auth_token) }
      end

    end

    # Generate a token for the specified field
    def generate_token(column)
      begin
        self[column] = SecureRandom.uuid
      end while self.class.exists?(column => self[column])
    end

    # Generate a token for the specified field, and save
    def generate_token!(column)
      generate_token(column)
      save
    end

    # Set the default length of the session
    # Override to set different value
    # Default: 2.weeks
    def session_length
      2.weeks
    end

  end
end

#
# Override authenticate in order to allow for auth_token
#
module ActiveModel
  module SecurePassword
    module InstanceMethodsOnActivation

      def authenticate(unencrypted_password)
        (auth_token == unencrypted_password ||
          BCrypt::Password.new(password_digest) == unencrypted_password) &&
            self
      end

    end
  end
end

ActiveRecord::Base.send :include, CzAuth::RequiresAuthentication
