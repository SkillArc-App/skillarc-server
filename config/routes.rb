require 'resque/server'

Rails.application.routes.draw do
  get 'employers/jobs' => 'employers/jobs#index'
  put 'employers/applicants/:id' => 'employers/applicants#update'
  resources :employers

  mount Resque::Server.new, at: "/resque"

  resources :job_matches
  resources :master_certifications
  resources :master_skills
  resources :one_user
  resources :onboarding_sessions
  resources :profiles do
    resources :stories
    resources :skills
    resources :education_experiences
    resources :personal_experiences
  end
  resources :programs do
    scope module: 'programs' do
      resources :students
    end
  end
  resources :references
  resources :students

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

  resources :seekers do
    resources :training_providers, controller: 'seeker_training_providers'
  end

  resources :seeker_invites
  resources :employer_invites
  resources :training_provider_invites

  if Rails.env.test?
    post '/reset_test_database' => 'test#reset_test_database'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "main#index"

  get '/auth/auth0/callback' => 'auth0#callback'
  get '/auth/failure' => 'auth0#failure'
  get '/auth/logout' => 'auth0#logout'
end
