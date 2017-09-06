class Event < ApplicationRecord
	
	has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
	:default_url => "/images/:style/missing.png",         
	:storage => :s3,                    
	:url => 's3_domain_url',            
	:s3_host_alias => 'goodmuse.s3-website-us-east-1.amazonaws.com',  
	:path => "/:class/:attachment/:id_partition/:style/:filename"
	
	validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

	has_and_belongs_to_many :playlists
	belongs_to :user
	has_many :going_statuses


	def image_url    
		if self.avatar.present?    
			image_url = self.avatar    
			path = URI.parse(URI.encode(self.avatar.url.to_s))
			path = "http://" + path.host + path.path
		else
			""
		end 
	end


end
