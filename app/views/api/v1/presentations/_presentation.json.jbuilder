json.extract! presentation, :id, :date, :group_id, :members, :created_at, :updated_at
json.songs presentation.songs do |song|
  json.name song.name
  json.artist song.artist
  json.tone song.tone
  json.url_youtube song.url_youtube
  json.url_cipher song.url_cipher
end
