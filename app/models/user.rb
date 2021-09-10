class User < ApplicationRecord
    has_secure_password 
    has_many :todos

    accepts_nested_attributes_for :todos

    validates :email, 
    format: { with: /^(.+)@(.+)$/, message: "Email invalid"  },
            uniqueness: { case_sensitive: false },
            length: { maximum: 50 },
            presence: true

    validates :password, presence: true
    validates(:password, { :length => { :in => 4..16 } })
end
