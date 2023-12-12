Rails.application.routes.draw do

  devise_for :users,skip: [:passwords], controllers: {
  registrations: 'public/registrations',
  sessions: 'public/sessions'
}

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: 'admin/sessions'
}

  root to: 'public/homes#top'

  get 'about'=>'public/homes#about'

  namespace :admin do
    root 'homes#top'
    resources :users,    only:[:index, :show, :edit, :update]
    resources :posts,    only:[:show] do
      resources :comments, only:[:index, :destroy]
    end
    get 'search' => 'searches#search'
  end

  scope module: :public do
    resources :users, only: [:show, :edit, :update] do
      member do
        get   'favorites' => 'users#favorites'
        get   'confirm'   => 'users#confirm'
        patch 'withdraw'  => 'users#withdraw'
        resource :relationship, only: [:create, :destroy]
      end
    end

    resources   :posts,    only: [:index, :show, :create, :edit, :update, :destroy] do
      resource  :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources :children, only: [:new, :create, :edit, :update]
    
    get 'search' => 'searches#search'
    
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
