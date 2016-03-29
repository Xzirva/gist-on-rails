class Category < ActiveRecord::Base

  has_many :gists_by_categories
  validates_presence_of :title
  validates_uniqueness_of :title

end
