module ResponseSpecSupport
  def json_body
    @json_body ||= JSON.parse(response.body, object_class: OpenStruct)
  end

  def body_as_hash
    @json_body ||= JSON.parse(response.body, symbolize_names: true)
  end
end
