CzAuth::Engine.routes.draw do
  post    '/:resource/authentication', to: 'cz_auth/authentication#create', as: :login
  delete  '/:resource/authentication', to: 'cz_auth/authentication#destroy', as: :logout
end