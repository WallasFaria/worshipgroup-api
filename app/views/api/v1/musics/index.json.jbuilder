json.data do
  json.array! @musics, partial: 'music', as: :music
end
