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

#def self.new

#end

#def destroy

#end

#def update

#end

end
