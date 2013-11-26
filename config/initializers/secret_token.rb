# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
DbServer::Application.config.secret_key_base = 'bdbb64076ab6365fcc91ea40f751dc0670f229d133854575bc284573423572bcd5e8213fbbc16204f22acdde6849cb1ae8dc1fcf3588d275127ae44c0efde607'
