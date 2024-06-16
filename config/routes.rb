Rails.application.routes.draw do


  get "search" => "searches#search"


  devise_for :admins, path: "/admin", skip: [:registrations, :passwords] ,controllers: {
    sessions: 'admin/sessions',

  }

  namespace :admin do
   get 'top' => 'homes#top', as: 'top'
   get 'companies/:company_id/employees/:employee_id/calendar' => 'tasks#calendar', as: 'employee_calendar'
   resources :stores, only: [:index, :create, :edit, :update]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :car_names, only: [:index, :create, :edit, :update], param: :id
   resources :tasks, except: [:new, :show]
   resources :companies, only: [:index, :show, :edit, :update, :destroy] do
       resources :employees, only: [:index, :show, :edit, :update] do
         resources :posts,  except: [:new, :create] do
             member do
                 get :history
             end
             resources :post_comments, only: [:create, :destroy]
         end
         resources :daily_tasks, only: [:index]
       end
   end
  end


  scope module: :company do
      devise_for :companies, skip: [:passwords,] ,controllers: {
          sessions: 'company/sessions',
          registrations: 'company/registrations'
        }
      devise_scope :company do
        post 'companies/guest_sign_in', to: 'sessions#guest_sign_in'
      end
  end

  scope module: :company do
    get 'top' => 'homes#top', as: 'top'
    get "about" => "homes#about"
    get 'companies/:company_id/employees/:employee_id/calendar' => 'tasks#calendar', as: 'company_employee_calendar'
    resources :companies, only: [:show, :edit, :update] do
        member do
            get "unsubscribe"
            patch "withdraw"
        end
      resources :tasks, except: [:new, :show]
      resources :employees, only: [:new, :create, :index, :show, :edit, :update] do
          resources :posts, except: [:new, :create]
          resources :daily_tasks, only: [:index]
      end
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
