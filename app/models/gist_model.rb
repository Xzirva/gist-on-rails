require 'gists_from_github'
class GistModel
  include ActiveModel::Model

  def self.all
    GistsFromGitHub.gists_with_details
  end

  def self.find(id)
    GistsFromGitHub.find({:id=>id})
  end

  def owner

  end

  def self.is_fork_of?(gist)
    gist[:fork_of].nil? || gist[:fork_of].size == 0
  end

  def self.has_forks?(gist)
    gist[:forks].nil? || gist[:forks].size == 0
  end

  def self.is_commented?(gist)
    gist[:comments].nil? || gist[:comments] == 0
  end

  def self.pluck(_column)
    if _column!= :id && _column!=:description
      raise 'Cant proceed this operation: supported column: id, description'
    else
      GistsFromGitHub.gists_by_ids if _column== :id
      GistsFromGitHub.gists_by_description if _column== :description
    end
  end

  def self.categories(gist)
    my_categories = Array.new
    categories_ids = GistsByCategory.where(gist_id: gist[:id]).pluck(:category_id)
    categories_ids.each { |v|
      my_categories[my_categories.size] = Category.find(v)
    }
    my_categories
  end
#def self.new

#end

#def destroy

#end

#def update

#end

end
