require 'test_helper'

require 'd2s3/patch/integer'

class IntegerTest < ActiveSupport::TestCase
  
  def setup
    @num, @cnt = [1732584193, 5]
  end
  
  test "js_shl" do
    assert_equal -391880672, (@num.js_shl(@cnt))
  end
  
  test "js_shr_zf" do
    assert_equal 12, (@num.js_shr_zf(32 - @cnt))
  end
  
end
