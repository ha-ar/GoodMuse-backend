class Song < ApplicationRecord
	has_and_belongs_to_many :playlists
	has_and_belongs_to_many :tags
end