require 'gists_from_github'
class Gist
  include ActiveModel::Model

  def self.all
    GistsFromGitHub.gists
  end

  def self.find(id)
    GistsFromGitHub.find({:id=>id})
  end

  def owner

  end


  #def self.new

  #end

  #def destroy

  #end

  #def update

  #end

end
