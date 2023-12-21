Rails.application.routes.draw do

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: 'admin/sessions'
}

  devise_for :users,skip: [:passwords], controllers: {
  registrations: 'public/registrations',
  sessions: 'public/sessions'
}

  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  root to: 'public/homes#top'

  get 'about'=>'public/homes#about'

  namespace :admin do
    root 'homes#top'
    resources :users,    only:[:index, :show, :edit, :update]
    resources :posts,    only:[:index, :show, :destroy]
    resources :comments, only:[:index, :show] do
      member do
        delete 'destroy_index' => 'comments#destroy_index'
        delete 'destroy_modal' => 'comments#destroy_modal'
      end
    end
    get 'search' => 'searches#search'
  end

  scope module: :public do
    resources :users, only: [:show, :edit, :update] do
      member do
        get   'favorites' => 'users#favorites'
        get   'confirm'   => 'users#confirm'
        patch 'withdraw'  => 'users#withdraw'
        resource :relationship, only: [:create, :destroy] do
          member do
            get :followings, :followers
          end
        end
      end
    end

    resources   :posts,    only: [:index, :show, :create, :edit, :update, :destroy] do
      resource  :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end

    resources   :children, only: [:new, :create, :edit, :update] do
      resources :posts,    only: :index, controller: 'children/posts'
    end

    get 'search' => 'searches#search'
    
    # お子様情報新規い登録失敗後の画面でのリロード対策
    get 'children' => redirect('children/new')

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end