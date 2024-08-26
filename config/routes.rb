Rails.application.routes.draw do
  get "search" => "searches#search"

  devise_for :admins, path: "/admin", skip: [:registrations, :passwords], controllers: {
      sessions: "admin/sessions",
  }

  namespace :admin do
    get "top" => "homes#top", as: "top"
    get "companies/:company_id/employees/:employee_id/calendar" => "tasks#calendar", as: "employee_calendar"
    get "companies/:company_id/employees/posts" => "posts#index", as: "company_employee_posts"
    resources :stores, only: [:index, :create, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :car_names, only: [:index, :create, :edit, :update]
    resources :tasks, except: [:new, :show]
    resources :companies, only: [:index, :show, :edit, :update, :destroy] do
      resources :employees, only: [:index, :show, :edit, :update] do
        resources :posts,  except: [:new, :create, :index] do
            collection do
                get :history
              end
            resources :post_comments, only: [:destroy]
          end
        resources :daily_tasks, only: [:index]
      end
    end
  end

  scope module: :company do
    devise_for :companies, skip: [:passwords,], controllers: {
        sessions: "company/sessions",
        registrations: "company/registrations"
    }
    devise_scope :company do
      post "companies/guest_sign_in", to: "sessions#guest_sign_in"
    end
  end

  scope module: :company do
    get "top" => "homes#top", as: "top"
    get "companies/mypage" => "companies#show", as: "companies_mypage"
    get "companies/mypage/edit", to: "companies#edit", as: "edit_company_mypage"
    patch "companies/mypage", to: "companies#update"
    get "companies/:company_id/employees/:employee_id/calendar" => "tasks#calendar", as: "company_employee_calendar"
    get "companies/:company_id/employees/posts" => "posts#index", as: "company_employee_posts"
    resources :companies, except: [:show, :edit, :update] do
      collection do
        get "unsubscribe"
        patch "withdraw"
      end
      resources :stores, only: [:index, :create, :show, :edit, :update]
      resources :genres, only: [:index, :create, :edit, :update]
      resources :car_names, only: [:index, :create, :edit, :update]
      resources :tasks, except: [:new, :show]
      resources :employees, only: [:new, :create, :index, :show, :edit, :update] do
        resources :posts, except: [:new, :create, :index] do
          resources :post_comments, only: [:destroy]
        end
        resources :daily_tasks, only: [:index]
      end
    end
  end

  scope module: :employee do
    devise_for :employees, skip: [:registrations, :passwords], controllers: {
        sessions: "employee/sessions"
    }

    devise_scope :employee do
      post "employees/guest_sign_in", to: "sessions#guest_sign_in"
      get "employees/edit", to: "registrations#edit", as: "edit_employee_registration"
      patch "employees", to: "registrations#update", as: "employee_registration"
    end
  end

  scope module: :employee do
    root to: "homes#top"
    get "about" => "homes#about"
    get "employees/mypage" => "employees#show", as: "mypage"
    get "employees/mypage/edit", to: "employees#edit", as: "edit_mypage"
    patch "employees/mypage", to: "employees#update"
    get "employees/mypage/favorites", to: "employees#favorites", as: "favorites_mypage"
    get "employees/mypage/history", to: "employees#history", as: "history_mypage"
    get "/employees/:employee_id/posts/history", to: "posts#history", as: "history_posts"
    resources :posts do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy] do
        resource :likes, only: [:create, :destroy]
      end
    end
    resources :employees, only: [:index] do
      resources :tasks, only: [:index]
      resources :daily_tasks, only: [:new, :create]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
