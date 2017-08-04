Rails.application.routes.draw do
	devise_for :users
	root 'home#index'

	namespace :api, defaults: {format: :json} do
		scope module: :v1 do

			resources :users, :except => [:create,  :update] do
				collection do
					post :sign_up
					get  :sign_user
					post :update
					post :reset_password
					post :rating
				end
			end

			resources :events
			resources :playlists do
				collection do
					post :add_song_to_playlist
					get :view_playlist
				end
			end

		end

	end

end