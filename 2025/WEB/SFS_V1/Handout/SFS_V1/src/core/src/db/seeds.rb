# db/seeds.rb

User.find_or_create_by!(username: 'admin') do |user|
  user.url = 'http://localhost:3000/admin'
  user.validated = true
end

Legacy.find_or_create_by!(legacy_secret: 'fake_secret')