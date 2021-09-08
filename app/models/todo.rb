class Todo < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :name, uniqueness: true 

  validates :user_id, presence: true
end
