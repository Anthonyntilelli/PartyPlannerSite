# frozen_string_literal: true

User.destroy_all
Venue.destroy_all
Theme.destroy_all
Party.destroy_all
Invite.destroy_all
Gift.destroy_all

fl_venue = Venue.create!(
  name: 'Fun Land',
  zipcode: 12_345,
  state: 'ny',
  city: 'New York',
  street_addr: '1234 My Street',
  active: true
)
sp_theme = Theme.create!(name: 'Space', active: true)
na_thean = Theme.create!(name: 'Nature', active: false)
tom_user = User.create!(
  name: 'Tom Smith',
  birthday: '05-01-2001',
  email: 'tom@example.com',
  email_confirmation: 'tom@example.com',
  password: 'pw123456',
  password_confirmation: 'pw123456',
  valid_email: false,
  locked: false,
  admin: true
)
amy_user = User.create!(
  name: 'Amy Smith',
  email: 'amy@example.com',
  email_confirmation: 'amy@example.com',
  password: 'pw123456',
  password_confirmation: 'pw123456',
  valid_email: true,
  locked: false,
  admin: false
)
# tm_party = Party.create!(user_id:tom_user.id, venue_id: fl_venue.id, theme_id: sp_theme.id, start_datetime: "05-01-2001", end_datetime: "05-01-2001")
# tm_invit = Invite.create!(user_id:amy_user.id, party_id:tm_party.id, accepted: true)
# tom_gift = Gift.create!(user_id:amy_user.id, party_id:tm_party.id, name: "Toy Plane")
