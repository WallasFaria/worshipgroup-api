class ApiVersionConstraint
  def initialize(version: nil, default: nil)
    @version = version
    @default = default
  end

  def matches?(req)
    @default || req.headers['Accept'].include?("application/wf.worshipgroup.v#{@version}")
  end
end
