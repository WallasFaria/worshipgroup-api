json.data do
  json.extract! @member, :id, :rule
  json.name @member.user.name
  json.email @member.user.email
  json.telephone @member.user.telephone
end
