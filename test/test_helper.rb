require 'rubygems'

begin
  gem "test-unit"
rescue LoadError
end
require 'test/unit'

require 'active_support'
require 'active_support/test_case'