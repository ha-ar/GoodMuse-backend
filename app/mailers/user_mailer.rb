class UserMailer < ApplicationMailer
	default from: 'admin@goodmuse.com'

	def forgot_password(user,new_password)
		@user = user
		@new_password = new_password
		mail(to: @user.email, 
			subject: 'Forgot Paassword Email.'
			)
	end

	def sign_up(user)
		@user = user
		mail(to: @user.email, 
			subject: 'Signup Email'
			)
	end

end
