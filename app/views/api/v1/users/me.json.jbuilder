json.data do
  json.extract! @user, :id, :name, :email, :created_at, :updated_at

  json.instruments @user.instruments do |instrument|
    json.name instrument.name
    json.icon instrument.icon
  end
end
