json.data do
  json.array! @presentations, partial: 'presentation', as: :presentation
end
