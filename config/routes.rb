Rails.application.routes.draw do

  resources :applications

  get '/', to: 'application#welcome'

  get '/shelters', to: 'shelters#index'
  get '/shelters/new', to: 'shelters#new'
  get '/shelters/:id', to: 'shelters#show'
  post '/shelters', to: 'shelters#create'
  get '/shelters/:id/edit', to: 'shelters#edit'
  patch '/shelters/:id', to: 'shelters#update'
  delete '/shelters/:id', to: 'shelters#destroy'

  get '/pets', to: 'pets#index'
  get '/pets/:id', to: 'pets#show'
  get '/pets/:id/edit', to: 'pets#edit'
  patch '/pets/:id', to: 'pets#update'
  delete '/pets/:id', to: 'pets#destroy'

  get '/veterinary_offices', to: 'veterinary_offices#index'
  get '/veterinary_offices/new', to: 'veterinary_offices#new'
  get '/veterinary_offices/:id', to: 'veterinary_offices#show'
  post '/veterinary_offices', to: 'veterinary_offices#create'
  get '/veterinary_offices/:id/edit', to: 'veterinary_offices#edit'
  patch '/veterinary_offices/:id', to: 'veterinary_offices#update'
  delete '/veterinary_offices/:id', to: 'veterinary_offices#destroy'

  get '/veterinarians', to: 'veterinarians#index'
  get '/veterinarians/:id', to: 'veterinarians#show'
  get '/veterinarians/:id/edit', to: 'veterinarians#edit'
  patch '/veterinarians/:id', to: 'veterinarians#update'
  delete '/veterinarians/:id', to: 'veterinarians#destroy'

  get '/admin/applications', to: 'admin#show_pending_applications'
  get '/admin/applications/:id', to: 'admin#show_application'
  get '/admin/shelters', to: 'admin#index'
  get '/admin/shelters/:shelter_id/applications/:application_id', to: 'admin#show_application_for_shelter'
  get '/admin/shelters/:shelter_id/applications/', to: 'admin#show_shelter_applications'

  patch '/admin/applications/:application_id/pets/:id/approve', to: 'admin#approve_pet'
  patch '/admin/applications/:application_id/pets/:id/reject', to: 'admin#reject_pet'
  delete '/admin/applications/:id', to: 'admin#destroy'

  get '/shelters/:id/pets/new', to: 'pets#new'
  get '/shelters/:id/pets', to: 'shelters#pets'
  post '/shelters/:id/pets', to: 'pets#create'

  get '/veterinary_offices/:id/veterinarians/new', to: 'veterinarians#new'
  get '/veterinary_offices/:id/veterinarians', to: 'veterinary_offices#veterinarians'
  post '/veterinary_offices/:id/veterinarians', to: 'veterinarians#create'
end
