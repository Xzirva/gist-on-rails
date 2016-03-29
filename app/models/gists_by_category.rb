class ExistingGistsValidator < ActiveModel::Validator
  def validate(record)
    gists = GistModel.all
    exist = false
    gists.each { |g|
      if g[:id] == record.gist_id
        exist = true
      end
    }
    unless exist
      record.errors[:base] << "There isn't a gist with the id #{record.gist_id}"
    end
  end
end

class GistsByCategory < ActiveRecord::Base

  validates_presence_of :gist_id
  validates_with ExistingGistsValidator
  validates :gist_id, :uniqueness => {scope: :category_id}
  belongs_to :category

end


