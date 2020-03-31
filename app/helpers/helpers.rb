# frozen_string_literal: true

# Send email using sendgrid
module EmailUtil
  include SendGrid
  SG = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  # to_address string email address
  # subject string
  # content string (HTML Status)
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

  # validates full url (avoids extra params added by sinatra)
  # url_no_query - url
  # query_string - request.query_string
  # return false if salt, expire or hmac query_string are missing
  # returns if hmac matches url_no_query + query_string and not expired
  def self.valid_hmac_url?(url_no_query, query_string)
    # Sinatra sometime has unique params
    parameters = Rack::Utils.parse_nested_query(query_string)
    return false unless parameters['salt']
    return false unless parameters['hmac']
    return false unless parameters['expire']

    # cannot hmac url with hmac in it.
    claimed_hmac = parameters.delete('hmac')
    salt = parameters['salt']
    url = make_sorted_query_string(url_no_query, parameters, salt)
    calculated_hmac = gen_hmac(url, salt)
    claimed_hmac == calculated_hmac && Time.now.utc <= Time.parse(parameters['expire'])
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

# Escapes html in a Hash
module SanitizeUtils
  # escape_html of provided hash
  def self.sanitize_hash(hash)
    hash.map { |k, v| [k, Rack::Utils.escape_html(v)] }.to_h
  end
end
