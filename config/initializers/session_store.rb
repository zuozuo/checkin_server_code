# Be sure to restart your server when you modify this file.

Pengpeng::Application.config.session_store :cookie_store, key: '_pengpeng_session',  domain: '.pengpeng.com'
# MyApp::Application.config.session_store :cookie_store, key: '_my_app_session', domain: '.example.com'


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Pengpeng::Application.config.session_store :active_record_store
