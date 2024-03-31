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
      resources :employees, only: [:new, :create, :index, :show, :edit, :update]
      resources :posts, except: [:new]
      resources :tasks, except: [:new]
      resources :daily_tasks, only: [:new, :create]
    end

   resources :stores, only: [:index, :create, :show, :edit, :update]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update]

   end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
