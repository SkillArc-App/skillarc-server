require 'resque/server'

Rails.application.routes.draw do
  get 'employers/jobs' => 'employers/jobs#index'
  put 'employers/applicants/:id' => 'employers/applicants#update', as: 'employers_applicant'

  scope module: 'coaches', path: 'coaches' do
    resources :seekers do
      resources :notes, only: [:create, :update, :destroy]
      post 'skill-levels' => 'seekers#update_skill_level'
      post 'assign_coach' => 'seekers#assign'
    end
    resources :leads, only: [:create, :index]
  end
  resources :coaches

  scope module: 'employers', path: 'employers' do
    resources :chats do
      post 'send_message' => 'chats#send_message', on: :collection
      post 'mark_read' => 'chats#mark_read', on: :collection
    end
  end

  resources :employers

  post 'hooks/:id' => 'hooks#event', as: 'hooks_event'

  post 'notifications/mark_read' => 'notifications#mark_read'

  mount Resque::Server.new, at: "/resque"

  get 'job_matches' => 'job_matches#index'
  resources :master_certifications
  resources :master_skills

  put 'one_user' => 'one_user#update'
  resources :one_user

  resources :pass_reasons

  resources :onboarding_sessions

  resources :users
  resources :profiles do
    resources :stories
    resources :skills
    resources :education_experiences
    resources :personal_experiences
    resources :other_experiences
  end
  resources :programs do
    scope module: 'programs' do
      resources :students
    end
  end
  resources :references
  resources :students

  resources :user_events

  resources :jobs do
    post 'apply' => 'jobs#apply'
    resources :career_paths do
      put 'up' => 'career_paths#up'
      put 'down' => 'career_paths#down'
    end
    resources :desired_skills
    resources :learned_skills
    resources :desired_certifications
    resources :testimonials
    resources :job_photos
    resources :job_tags
  end

  get 'training_providers/programs' => 'training_providers/programs#index'
  post 'training_providers/invites' => 'training_providers/invites#create'
  resources :training_providers do
    scope module: 'training_providers' do
      resources :programs
    end
  end

  scope module: 'seekers', path: 'seekers' do
    resources :jobs do
      post 'save' => 'jobs#save'
      post 'unsave' => 'jobs#unsave'
    end

    resources :chats do
      post 'send_message' => 'chats#send_message', on: :collection
      post 'mark_read' => 'chats#mark_read', on: :collection
    end
  end

  scope module: 'admin', path: 'admin' do
    resources :users
    resources :application_analytics
  end

  resources :seekers do
    resources :training_providers, controller: 'seeker_training_providers'
  end

  resources :seeker_invites
  resources :employer_invites do
    put 'used' => 'employer_invites#used'
  end
  resources :training_provider_invites do
    post 'accept', on: :member
  end

  if Rails.env.test? || Rails.env.development?
    resource :test do
      post '/reset_database' => 'test#reset_test_database'
      post '/create_user' => 'test#create_test_user'
      post '/create_coach' => 'test#create_coach'
      post '/create_seeker' => 'test#create_seeker'
      post '/create_seeker_lead' => 'test#create_seeker_lead'
      post '/create_active_seeker' => 'test#create_active_seeker'
      post '/create_recruiter_with_applicant' => 'test#create_test_recruiter_with_applicant'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "main#index"

  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
end
