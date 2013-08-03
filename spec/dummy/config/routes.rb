Rails.application.routes.draw do
  mount CzAuth::Engine => "/cz_auth"
end
