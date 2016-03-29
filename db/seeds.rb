# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create(title: '1st Category', description:'1st Category')
Category.create(title: 'Ruby', description:'Gists about ruby')

Category.create(title: 'PHP', description:'Gists about PHP')

Category.create(title: 'C++', description:'Gists about C++')

Category.create(title: 'SQL', description:'Gists about SQL')


gists = GistModel.all
GistsByCategory.create(gist_id: gists[0][:id], category_id: 1)