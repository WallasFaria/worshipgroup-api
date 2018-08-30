json.extract! song, :id, :name, :artist, :url_youtube, :url_cipher, :group_id
json.url api_v1_group_song_url(group, song, format: :json)
