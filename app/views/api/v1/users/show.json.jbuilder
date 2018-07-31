json.data do
  json.extract! @user, :id, :name, :email, :created_at, :updated_at

  json.roles @user.roles do |role|
    json.name role.name
    json.icon role.icon
  end
end
