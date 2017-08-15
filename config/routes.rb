Rails.application.routes.draw do
	devise_for :users
	root 'home#index'

	namespace :api, defaults: {format: :json} do
		scope module: :v1 do

			resources :users, :except => [:create,  :update] do
				collection do
					get :user_detail
					post :sign_up
					get  :sign_user
					post :update
					post :forgot_password
					post :rating
					post :social_login
					post :user_login
					post :update_role
				end
			end

			resources :events do 
				collection do
					get :view_event
				end
			end
			resources :playlists do
				collection do
					post :add_song_to_playlist
					get :view_playlist
					get :playlist_matching
				end
			end

		end

	end

end