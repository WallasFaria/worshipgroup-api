json.extract! group, :id, :name, :created_at
json.is_admin group.user == current_api_v1_user
json.url api_v1_group_url(group, format: :json)
