
json.going_status  do
	json.id                 @going_status.id
	json.user_id         	@going_status.user_id
	json.event_id        	@going_status.event_id
	json.going_status       @going_status.going_status
end

json.success true

