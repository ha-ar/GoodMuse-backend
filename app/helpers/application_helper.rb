module ApplicationHelper

	def going_status(event_id, user_id)
		status = GoingStatus.where(event_id: event_id,user_id: user_id).first
		if status.present?
			status.going_status
		else
			false
		end
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

	def percentage_value(user,user_soung_count,latest_event)

		if latest_event.present? && latest_event.playlists.present? && user_soung_count.present?
			playlist_song_ids = latest_event.playlists.first.songs.pluck(:id)
			hash_value = (playlist_song_ids & @song_ids).length
			percentage_value = ((hash_value.to_f / user_soung_count.to_f) * 100).round(1)
		else
			percentage_value = nil
		end

	end


end
