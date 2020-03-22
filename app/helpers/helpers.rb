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
      Content.new(type: 'text/plain', value: body) # Email Body
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
  # args_hash to be added to query string
  # return url with hmac
  def self.gen_url(path, args_hash)
    # Sorting arg hash by key (hmacs are order sensative)
    raise 'args_hash cannot have salt key' if args_hash['salt'] || args_hash[:salt]
    raise 'args_hash cannot have hmac key' if args_hash['hmac'] || args_hash[:hmac]

    salt = SecureRandom.urlsafe_base64(5)
    url = make_sorted_query_string(path, args_hash, salt)
    # append hmac to url
    url + '&' + URI.encode_www_form({ 'hmac' => gen_hmac(url, salt) })
  end

  # path - request.path
  # params_hash to be added to query string
  # def self.valid_url?(path, params_hash)
  #  raise 'params_hash missing salt key' unless args_hash['salt']
  #  raise 'params_hash missing hmac key' unless args_hash['hmac']
  #   # TODO:
  # end

  private_class_method def self.make_sorted_query_string(path, args_hash, salt)
    args_hash['salt'] = salt
    # Sorting arg hash by key (hmacs are order sensative)
    path + '?' + URI.encode_www_form(args_hash.sort_by { |k, _v| k }.to_h)
  end

  private_class_method def self.gen_hmac(url, salt)
    salted_key = salt + HMAC_KEY
    OpenSSL::HMAC.hexdigest(DIGEST, salted_key, url)
  end
end
