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

  # path - with out http or https
  # arg_hash to be added to query string
  # return url with hmac
  def self.gen_url(path, arg_hash)
    # Sorting arg hash by key (hmacs are order sensative)
    raise 'arg_hash cannot have salt key' unless arg_hash['salt'].nil? && arg_hash[:salt].nil?
    raise 'arg_hash cannot have hmac key' unless arg_hash['hmac'].nil? && arg_hash[:hmac].nil?

    arg_hash['salt'] = SecureRandom.urlsafe_base64(5)
    url = path + '?' + URI.encode_www_form(arg_hash.sort_by { |k, _v| k }.to_h)
    # append hmac to url
    hmac = OpenSSL::HMAC.hexdigest(DIGEST, arg_hash['salt'] + HMAC_KEY, url)
    url + '&' + URI.encode_www_form({ 'hmac' => hmac })
  end

  def self.verify_url(url)
  end
end
