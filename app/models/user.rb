class User < ActiveRecord::Base

  has_many :nodes
  validates_uniqueness_of :name

end
