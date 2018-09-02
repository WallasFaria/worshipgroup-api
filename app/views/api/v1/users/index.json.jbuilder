json.data do
  json.array! @users do |user|
    json.extract! user, :id, :name

    json.roles user.roles do |role|
      json.id role.id
      json.name role.name
      json.icon role.icon
    end
  end
end
