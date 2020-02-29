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
sl_venue = Venue.create!(
  name: 'Sad Land',
  zipcode: 12_346,
  state: 'ny',
  city: 'New York',
  street_addr: '1234 My Other Street',
  active: false
)
sp_theme = Theme.create!(name: 'Space', active: true)
na_theme = Theme.create!(name: 'Nature', active: false)
tom_user = User.create!(
  name: 'Tom Smith',
  birthday: '2001-02-28', # yyyy-mm-dd
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
tm_party = Party.create!(
  name: "Tom party",
  user: tom_user,
  venue: fl_venue,
  theme: sp_theme,
  event_date: '2020-05-02', # yyyy-mm-dd
  time_slot: 4
)
tm_invit = Invite.create!(user: amy_user, party: tm_party, accepted: true)
tom_gift = Gift.create!(user:  amy_user, party: tm_party, name: "Toy Plane")
tom_gift = Gift.create!(party: tm_party, name: "Toy Plane")
