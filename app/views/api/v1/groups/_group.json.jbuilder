json.extract! group, :id, :name, :created_at
json.members group.members do |member|
  json.id member.id
  json.name member.user.name
  json.permission member.permission
  json.added_at member.created_at
  json.user_id member.user.id
end
json.url api_v1_group_url(group, format: :json)
