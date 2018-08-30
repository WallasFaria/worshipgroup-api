json.data do
  json.array! @songs, partial: 'song', as: :song, locals: { group: @group }
end

json.links do
  json.pages! @songs, url: api_v1_group_songs_url(@group) , query_parameters: { }
end
