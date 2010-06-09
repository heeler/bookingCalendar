class Message < ActiveRecord::Base
  belongs_to :instrument
  belongs_to :user
end
