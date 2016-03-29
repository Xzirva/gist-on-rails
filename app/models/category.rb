class Category < ActiveRecord::Base

  has_many :gists_by_categories,dependent: :destroy

  accepts_nested_attributes_for :gists_by_categories, allow_destroy: true

  validates_presence_of :title
  validates_uniqueness_of :title
end
