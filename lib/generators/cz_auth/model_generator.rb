require 'rails/generators'
require 'rails/generators/migration'

class CzAuth::ModelGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  desc "Installs the CzAuth Models, Migrations."

  argument :user_model, :type => :string, :required => false, :default => "User", :desc => "Your user model name."

  def create_models
    model = user_model.singularize
    generate("model", "#{model} email password_digest auth_token password_reset_token")
    inject_into_file "app/models/#{user_model}.rb", after: "ActiveRecord::Base" do
      "\n\trequires_authentication"
    end
  end
end