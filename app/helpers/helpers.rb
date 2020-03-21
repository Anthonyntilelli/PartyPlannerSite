# frozen_string_literal: true

require 'sendgrid-ruby'

# Send email via helper
module SendEmailUtil
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

# helpers SendEmailUtil
