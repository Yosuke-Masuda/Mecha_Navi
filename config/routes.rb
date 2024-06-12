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


  scope module: :company do
      devise_for :companies, skip: [:passwords,] ,controllers: {
          sessions: 'company/sessions',
          registrations: 'company/registrations'
        }
  end

  scope module: :company do
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


   scope module: :employee do
  devise_for :employees, skip: [:registrations] ,controllers: {
    sessions: 'employee/sessions',
  }
  end

  scope module: :employee do
   root :to => "homes#top"
   get 'employees/mypage' => 'employees#show', as: 'mypage'
   get 'employees/mypage/edit', to: 'employees#edit', as: 'edit_mypage'
   patch 'employees/mypage', to: 'employees#update'
   resources :posts do
       resource :favorites, only: [:create, :destroy]
       resources :post_comments, only: [:create, :destroy] do
           resource :likes, only: [:create, :destroy]
       end
   end
   resources :employees, except: [:new, :create, :index, :show, :edit, :update, :destroy] do
      member do
        get :favorites
        get :history
     end
     get "about" => "homes#about"
     resources :tasks, only: [:index]
     resources :daily_tasks, only: [:new, :create]

   end

   end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
