json.extract! music, :id, :name, :artist, :url_youtube, :url_cipher, :group_id
json.url api_v1_music_url(music, format: :json)
