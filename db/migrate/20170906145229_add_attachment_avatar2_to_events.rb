class AddAttachmentAvatar2ToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.attachment :avatar2
    end
  end

  def self.down
    remove_attachment :events, :avatar2
  end
end
