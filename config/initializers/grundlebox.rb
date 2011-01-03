require "grundlebox"
require "config/grundlebox"

# Stub remote tests
if Rails.env=="test"
  require "test_stub"
end