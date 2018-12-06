Rails.application.routes.draw do
    post '/data', to: 'goods_data#new'
    get '/get_url_list', to:'goods_data#show'
    get 'sessions/new'
    get 'users/new'
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    #
    get '/token', to: 'sessions#token'
    # get '/login', to: 'sessions#new'
    post '/login', to:'sessions#create'
    get '/logout', to: 'sessions#destroy'

    post '/update', to: 'goods_data#update'

end
