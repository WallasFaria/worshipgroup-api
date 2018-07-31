json.data do
  json.array! @songs, partial: 'song', as: :song
end

json.links do
  json.pages! @songs, url: api_v1_songs_url , query_parameters: { }
end
