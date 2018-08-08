json.data do
  json.id @presentations_member.id
  json.name @presentations_member.name
  json.roles @presentations_member.roles do |role|
    json.id role.id
    json.name role.name
    json.icon role.icon
  end
end
