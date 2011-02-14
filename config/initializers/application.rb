# This initializer loads code specific to running the Grundlebox application
# rather than when it's used as an engine
if defined?( Grundlebox::Application )
  Grundlebox::Application.config.secret_token = '71cea82cd22eb3888f790a213b95a56d5f3c7bcb8055ec83db6cda0f72f1de174793f72df4965eb1741363205ca5e390284a0be14d60370b9d39622a8ccca406'
  Grundlebox::Application.config.session_store :cookie_store, :key => '_grundlebox_session'
end