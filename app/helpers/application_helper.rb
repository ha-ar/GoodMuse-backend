module ApplicationHelper

	def going_status(event_id, user_id)
		status = GoingStatus.where(event_id: event_id,user_id: user_id).first
		if status.present?
			status.going_status
		else
			false
		end
	end

	def current_user_event_going_status(event_id)
		if current_user.present?
			status = GoingStatus.where(event_id: event_id,user_id: current_user.id).first
			if status.present?
				return status.going_status
			end
		end
		false
	end


	def is_following(dj_id)
		if current_user.present?
			following = Following.find_by(user_id: dj_id, follower_id: current_user.id)
			if following.present?
				return true
			end
		end
		return false
	end

	def percentage_value(user_song_count,event)
		if event.present? && event.playlists.present? && user_song_count.present?
			playlist_song_ids = event.playlists.first.songs.pluck(:id)
			hash_value = (playlist_song_ids & @song_ids).length
			percentage_value = ((hash_value.to_f / user_song_count.to_f) * 100).round(1)
		else
			percentage_value = nil
		end
	end


end
