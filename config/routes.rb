Rails.application.routes.draw do
	devise_for :users
	root 'home#index'
	resources :events do
		collection do
			get :my_events
		end
	end
	resources :playlists

	namespace :api, defaults: {format: :json} do
		scope module: :v1 do

			resources :users, :except => [:create,  :update] do
				collection do
					get :user_detail
					post :sign_up
					get  :sign_user
					post :update_user
					post :forgot_password
					post :rating
					post :social_login
					post :user_login
					post :update_role
					post :set_fcm_key
				end
			end

			resources :events do 
				collection do
					get :my_events
					get :view_event
					get :upcoming_events
					post :update_event
					post :delete_event
					get :going_to_events
				end
			end
			resources :searches do 
				collection do
					get :find_nearby_events
					get :find_nearby_going_events
					get :search_songs
					get :search_djs
					get :match_playlist_event
					get :events_search
				end
			end
			resources :playlists do
				collection do
					post :add_song_to_playlist
					get :view_playlist
					get :playlist_matching
					get :user_playlists
					post :delete_playlist
					post :update_playlist

				end
			end
			
			resources :songs 
			resources :questions do
				collection do
					get :view_question
				end
			end
			resources :going_statuses do
				collection do
					get :is_going
				end
			end


		end

	end

end