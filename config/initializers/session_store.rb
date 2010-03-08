# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_AgileTool_session',
  :secret      => 'ed0f42c2905ed53cc7aa966bed56ea4b7ac687021a3dfdf8ae1ef99e73884279437e230432c41a86cc18ab321e1d9e3a953024e95cdbf13e592bcc5eb389fd8f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
