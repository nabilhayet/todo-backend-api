class User < ApplicationRecord
    has_secure_password 
    has_many :todos

    accepts_nested_attributes_for :todos

   # validates :email, { with: /^(.+)@(.+)$/ }
   validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

    validates :email, presence: true 
    validates :email, uniqueness: true

    validates :password, presence: true
    validates(:password, { :length => { :in => 4..16 } })
end
