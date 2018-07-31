json.data do
  json.array! @roles do |role|
    json.name role.name
    json.icon request.base_url + role.icon
  end
end
