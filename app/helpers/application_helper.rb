module ApplicationHelper

	def going_status(event_id, user_id)
		status = GoingStatus.where(event_id: event_id,user_id: user_id).first
		if status.present?
			status.going_status
		else
			false
		end
	end


end
