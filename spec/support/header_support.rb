module HeaderSupport
  def headers_with_auth
    user = create :user
    auth_data = user.create_new_auth_token

    headers = {
      'Accept': 'application/wf.worshipgroup.v1',
      'Content-Type': Mime[:json].to_s,
      'access-token': auth_data['access-token'],
      'uid': auth_data['uid'],
      'client': auth_data['client'],
    }
  end
end
