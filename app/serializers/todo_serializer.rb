class TodoSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id
  belongs_to :user 
end
