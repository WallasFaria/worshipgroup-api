json.data do
  json.extract! @member, :id, :permission
  json.name @member.user.name
  json.email @member.user.email
  json.telephone @member.user.telephone
end
