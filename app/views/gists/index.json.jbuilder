json.array!(@gists) do |gist|
  json.extract! gist, :id
  json.url gist_url(gist, format: :json)
end
