Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "sudoku#index"
  post '/', to: 'sudoku#index'

  post 'sudoku', to: 'sudoku#take_params_and_fill'
  get 'sudoku/solve', to: 'sudoku#solve'
  # Defines the root path route ("/")
  # root "articles#index"
end
