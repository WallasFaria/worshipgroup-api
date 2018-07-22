json.data do
  json.array! @groups, partial: 'group', as: :group
end
