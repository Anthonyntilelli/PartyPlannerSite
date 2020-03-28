# frozen_string_literal: true

# Send email using sendgrid
module EmailUtil
  include SendGrid
  SG = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  # to_address string email address
  # subject string
  # content string
  # returns { status code, headers }
  def self.send_email(to_address, subject, body)
    mail = Mail.new(
      Email.new(email: 'no_reply@test_email.tilelli.me'), # From
      subject,
      Email.new(email: to_address), # TO
      Content.new(type: 'text/html', value: body) # Email Body
    )
    response = SG.client.mail._('send').post(request_body: mail.to_json)
    { status_code: response.status_code, body: response.body, headers: response.headers }
  end
end

# Create and verift hmac url
module HmacUtils
  HMAC_KEY = ENV['HMAC_URl_KEY']
  DIGEST = OpenSSL::Digest.new('sha256')

  # path - request.path
  # args_hash - to be added to query string
  # expire_min (integer) - number minutes from now link is valid for
  # return url with hmac
  def self.gen_url(path, args_hash, expire_min)
    # Sorting arg hash by key (hmacs are order sensative)
    raise 'args_hash cannot have salt key' if args_hash['salt']
    raise 'args_hash cannot have hmac key' if args_hash['hmac']
    raise 'args_hash cannot have expire key' if args_hash['expires']

    salt = SecureRandom.urlsafe_base64(5)
    url = make_sorted_query_string(path, args_hash, salt, expire_min)
    # append hmac to url
    url + '&' + URI.encode_www_form({ 'hmac' => gen_hmac(url, salt) })
  end

  # path - request.path
  # params_hash to be added to query string
  # return false if salt, expire or hmac parms are missing
  # returns if hmac matches path + params and link has not expired
  def self.valid_url?(path, params_hash)
    # Must be false if salt or hmac are missing
    return false unless params_hash['salt']
    return false unless params_hash['hmac']
    return false unless params_hash['expire']

    claimed_hmac = params_hash.delete('hmac') # cannot hmac url with hmac in it.
    salt = params_hash['salt']
    url = make_sorted_query_string(path, params_hash, salt)
    calculated_hmac = gen_hmac(url, salt)
    claimed_hmac == calculated_hmac && Time.now.utc <= Time.parse(params_hash['expire'])
  end

  private_class_method def self.make_sorted_query_string(path, args_hash, salt, expire_min = nil)
    args_hash['salt'] = salt
    # skip hmac on validate
    args_hash['expire'] = (Time.now.utc + expire_min.minutes).to_s if expire_min
    # Sorting arg hash by key (hmacs are order sensative)
    path + '?' + URI.encode_www_form(args_hash.sort_by { |k, _v| k }.to_h)
  end

  private_class_method def self.gen_hmac(url, salt)
    salted_key = salt + HMAC_KEY
    OpenSSL::HMAC.hexdigest(DIGEST, salted_key, url)
  end
end
