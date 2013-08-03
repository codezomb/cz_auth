CzAuth::Engine.routes.draw do

  scope ':resource', module: 'cz_auth', as: :resource do
    resources :sessions, only: [:new, :create, :destroy]
  end

end