require 'rails/generators'
require 'rails/generators/migration'

class CzAuth::InstallGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  desc "Installs CZAuth Required Files/Lines."

  def injections
    [
      {
        file:   "app/controllers/application_controller.rb",
        line:   "\n\tinclude CzAuth::Concerns::Authentication",
        after:  "ActionController::Base"
      },
      {
        file:   "config/routes.rb",
        line:   "\n\tmount CzAuth::Engine => '/'",
        after:  "routes.draw do"
      }
    ].each do |injection|
      inject_into_file injection[:file], after: injection[:after] do
        injection[:line]
      end
    end
  end

end