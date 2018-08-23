json.extract! presentation, :id, :date, :description, :group_id, :created_at, :updated_at

json.members presentation.members do |member|
  json.id member.id
  json.name member.name
end

json.songs presentation.songs do |song|
  json.id song.id
  json.name song.name
  json.artist song.artist
  json.tone song.tone
  json.url_youtube song.url_youtube
  json.url_cipher song.url_cipher
end

json.rehearsals presentation.rehearsals do |rehearsal|
  json.id rehearsal.id
  json.date rehearsal.date
  json.created_at rehearsal.created_at
  json.updated_at rehearsal.updated_at
end
