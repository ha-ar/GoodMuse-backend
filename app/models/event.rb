class Event < ApplicationRecord
	has_attached_file :avatar, :styles => {logo: "195x54", large: "600x600", medium: "300x300>", thumb: "100x100>" }
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
	has_and_belongs_to_many :playlists
	belongs_to :user
end
