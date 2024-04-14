Rails.application.routes.draw do


  get "search" => "searches#search"


  devise_for :admins, path: "/admin", skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions',

  }

  namespace :admin do
   get 'top' => 'homes#top', as: 'top'
   resources :stores, only: [:index, :create, :edit, :update]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update], param: :id
   resources :tasks, except: [:new, :show]
   get 'admin/sign_out' => 'admin/sessions#destroy'
   resources :companies, only: [:index, :show, :edit, :update, :destroy] do
       resources :employees, only: [:index, :show, :edit, :update] do
         resources :posts,  except: [:new, :create] do
             member do
                 get :history
             end
             resources :post_comments, only: [:create, :destroy]
         end
         resources :tasks, only: [:show]
       end
   end
  end


  scope module: :public do
      devise_for :companies, skip: [:passwords,] ,controllers: {
          sessions: 'public/sessions',
          registrations: 'public/registrations'
        }
  end

  scope module: :public do
    get 'top' => 'homes#top', as: 'top'
    get "about" => "homes#about"
    resources :companies, only: [:show, :edit, :update] do
        member do
            get "unsubscribe"
            patch "withdraw"
        end
      resources :tasks, except: [:new, :show]
      resources :employees, only: [:new, :create, :index, :show, :edit, :update] do
          resources :posts, except: [:new]
          resources :tasks, only: [:show]
      end
      resources :daily_tasks, only: [:new, :create]
    end

   resources :stores, only: [:index, :create, :show, :edit, :update]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update]

   end


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
       resources :post_comments, only: [:create, :destroy] do
           resource :likes, only: [:create, :destroy]
       end
     end
       resources :employees, except: [:index] do
          member do
            get :favorites
            get :history
         end
         resources :tasks, shallow: true, only: [:index, :new, :create, :show], path: 'employees/tasks' # タスクのルーティングを追

       end

   end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
