Rails.application.routes.draw do


  devise_for :admins, path: "/admin", skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions',

  }
  
  scope module: :user do
  devise_for :employees, skip: [:passwords, :registrations] ,controllers: {
    sessions: 'user/sessions',
  }
  end
  
  scope module: :user do
   root :to => "homes#top"
   get "about" => "homes#about"
   get 'employees/mypage' => 'employees#show', as: 'mypage'
   get 'employees/information/edit' => 'employees#edit', as: 'edit_information'
   patch 'employees/information' => 'employees#update', as: 'update_information'
   put 'employees/information' => 'employees#update'
   get 'employees/unsubscribe' => 'employees#unsubscribe', as: 'confirm_unsubscribe'
   patch 'employees/withdraw' => 'employees#withdraw', as: 'withdraw_employee'
   put 'employees/withdraw' => 'employees#withdraw'
   resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
       resource :favorites, only: [:create, :destroy]
       resources :post_comments, only: [:create, :destroy]
     end
   resources :employees do
      member do
        get :favorites
     end
   end
   
   end

  
  namespace :admin do
   get 'top' => 'homes#top', as: 'top'
   resources :genres, only: [:index, :create, :edit, :update]
   #resources :car_names, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update], param: :id
   get 'admin/sign_out' => 'admin/sessions#destroy'
   resources :companies, only: [:index, :show, :edit, :update]

  end
  
  scope module: :public do
   get 'top' => 'homes#top', as: 'top'      
   get "about" => "homes#about"
   resource :companies, only: [:show, :edit, :update]
   get "companies/unsubscribe" => "companies#unsubscribe"
   patch "companies/withdraw" => "companies#withdraw"
   resources :employees, only: [:new, :create, :index, :show, :edit, :update]
   get 'companies/employees/index' => 'employees#index', as: 'public_index_employees'
   get 'companies/employees/show/:id' => 'employees#show', as: 'public_show_employees'
   get "employees/unsubscribe" => "employees#unsubscribe"
   patch "employees/withdraw" => "employees#withdraw"
   resources :stores, only: [:index, :create, :edit, :update]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update], param: :id
   get 'companies/posts/new' => 'posts#new', as: 'public_new_posts'
   post 'companies/posts' => 'posts#create', as: 'public_posts'
   post 'companies/post/:id' => 'posts#update', as: 'public_post'
   get 'companies/posts/index' => 'posts#index', as: 'public_index_posts'
   get 'companies/posts/edit/:id' => 'posts#edit', as: 'public_edit_posts'
   get 'companies/posts/show/:id' => 'posts#show', as: 'public_show_post'
   patch 'companies/posts' => 'posts#update', as: 'public_update_posts'
   put 'companies/posts' => 'posts#update', as: 'public_update_post'
   delete 'companies/posts' => 'posts#destroy', as: 'destroy_public_posts'


   end
   
   devise_for :companies, skip: [:passwords,] ,controllers: {
      sessions: 'public/sessions',
      registrations: 'public/registrations'
    }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
