class UserMailer < ApplicationMailer
	default from: 'admin@goodmuse.com'

	def forgot_password(user, token)
		@user = user
		@token = token
		mail(to: @user.email, 
			subject: 'Forgot Password Email.'
			)
	end

	def sign_up(user)
		@user = user
		mail(to: @user.email, 
			subject: 'Signup Email'
			)
	end

end
