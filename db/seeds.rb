User.destroy_all
Venue.destroy_all
Theme.destroy_all
Party.destroy_all
Invite.destroy_all
Gift.destroy_all
fl_venue = Venue.create!(name: 'Fun Land', zipcode: 12345, state: 'ny', city: 'New York', street_addr: '1234 My Street', active: true)
sp_theme = Theme.create!(name: 'Space', active: true)
# tom_user = User.create(first_name: "Tom", last_name:"Smith", birthday: "05-01-2001", email: "tom@example.com", password: "pw12345", locked: false, admin: true)
# amy_user = User.create(first_name: "Amy", last_name:"Smith", birthday: "05-01-2002", email: "amy@example.com", password: "pw12345", locked: false, admin: false)
# tm_party = Party.create(user_id:tom_user.id, venue_id: fl_venue.id, theme_id: sp_theme.id, start_datetime: "05-01-2001", end_datetime: "05-01-2001")
# tm_invit = Invite.create(user_id:amy_user.id, party_id:tm_party.id, accepted: true)
# tom_gift = Gift.create(user_id:amy_user.id, party_id:tm_party.id, name: "Toy Plane")
