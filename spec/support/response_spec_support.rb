module ResponseSpecSupport
  def json_body
    @json_body ||= JSON.parse(response.body, object_class: OpenStruct)
  end
end
