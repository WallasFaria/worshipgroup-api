json.data do
  json.partial! "song", locals: { song: @song, group: @group }
end
