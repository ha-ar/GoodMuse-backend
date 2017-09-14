class User < ApplicationRecord
	rolify

  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :styles => {logo: "195x54", large: "600x600", medium: "300x300>", thumb: "100x100>" },
  :path => "/files/:style/:id_:filename",
  :default_url => "/images/:style/missing.png",
  :storage => :s3,
  :url => 's3_domain_url',
  :s3_host_alias => 'goodmuse.s3-website-us-east-1.amazonaws.com'

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  has_many :playlists
  has_many :events
  has_many :going_statuses


  def email_required?
  	false
  end

  def image_url    
    if self.avatar.present?    
      path = URI.parse(URI.encode(self.avatar.url.to_s))
      path = "http:" + path.to_s
    else
      ""
    end 
  end

end