Rails.application.routes.draw do

  namespace :public do
    get 'daily_tasks/new'
  end
  get "search" => "searches#search"


  devise_for :admins, path: "/admin", skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions',

  }

  scope module: :user do
  devise_for :employees, skip: [:registrations] ,controllers: {
    sessions: 'user/sessions',
  }
  end

  scope module: :user do
   root :to => "homes#top"
   get "about" => "homes#about"
   get 'employees/mypage/:id' => 'employees#show', as: 'mypage'
   get 'employees/information/edit' => 'employees#edit', as: 'edit_information'
   resources :posts do
       resource :favorites, only: [:create, :destroy]
       resources :post_comments, only: [:create, :destroy]
     end
   resources :employees, except: [:index] do
      member do
        get :favorites
     end
     resources :tasks, shallow: true, only: [:index, :new, :create, :show], path: 'employees/tasks' do # タスクのルーティングを追
       collection do
          post 'confirm'
          get 'complete'
       end
     end
     get 'tasks/complete', to: 'tasks#complete', as: 'tasks_complete'
   end

   patch 'employees/information' => 'employees#update', as: 'update_information'
   put 'employees/information' => 'employees#update'
   get 'employees/unsubscribe' => 'employees#unsubscribe', as: 'confirm_unsubscribe'


   end


  namespace :admin do
   get 'top' => 'homes#top', as: 'top'
   resources :stores, only: [:index, :create, :edit, :update]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update], param: :id
   get 'admin/sign_out' => 'admin/sessions#destroy'
   resources :companies, only: [:index, :show, :edit, :update, :destroy] do
       resources :employees, only: [:index, :show, :edit, :update] do
         resources :posts,  except: [:new, :create] do
             member do
                 get :history
             end
             resources :post_comments, only: [:create, :destroy]
         end
         resources :tasks, only: [:index]
       end
   end
  end

  devise_for :companies, skip: [:passwords,] ,controllers: {
      sessions: 'public/sessions',
      registrations: 'public/registrations'
    }

  scope module: :public do
    get 'top' => 'homes#top', as: 'top'
    get "about" => "homes#about"
    resources :companies, only: [:show, :edit, :update] do
        member do
            get "unsubscribe"
            patch "withdraw"
        end


      resources :tasks
      resources :daily_tasks, only: [:new, :create]
    end

   resources :employees, only: [:create, :index, :show, :edit, :update] do
     resources :tasks, only: [:show]
   end
   patch 'companies/employees/:id' => 'employees#update', as: 'public_update_employee'
   post 'companies/employees' => 'employees#create', as: 'public_employees'
   get 'companies/employees/edit/:id' => 'employees#edit', as: 'public_edit_employees'
   get 'companies/employees/new' => 'employees#new', as: 'public_new_employees'
   get 'companies/employees/index' => 'employees#index', as: 'public_index_employees'
   get 'companies/employees/show/:id' => 'employees#show', as: 'public_show_employees'
   get "employees/unsubscribe" => "employees#unsubscribe"
   patch "employees/withdraw" => "employees#withdraw"
   resources :stores, only: [:index, :create, :show, :edit, :update]
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
   delete 'companies/posts/:id' => 'posts#destroy', as: 'destroy_public_posts'


   end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
