# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_transparencia_cliente_session',
  :secret      => 'fe4a1594bfdd56fee897f5f2d5bec3c753cbaed5e882274b37282e84898173885227967ce793a72dbccf3692073d720bb46087a0265f192d326df31f655c230d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
