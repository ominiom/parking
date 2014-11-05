Rails.application.routes.draw do

  resource :crimes, only: :score do
    collection do
      get :score
    end
  end

  resource :spaces, only: [:create, :index]

end
