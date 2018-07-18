json.data do
  json.array! @instruments do |instrument|
    json.name instrument.name
    json.icon request.base_url + instrument.icon
  end
end
