class Role < ActiveRecord::Base
  #has_and_belongs_to_many :users
  has_many :roles_users
  has_many :users
  validates_presence_of :name, :on => :create, :message => "can't be blank"
end