json.data do
  json.array! @musics, partial: 'music', as: :music
end

json.links do
  json.pages! @musics, url: api_v1_musics_url , query_parameters: { }
end
