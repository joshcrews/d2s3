require 'test_helper'

require 'd2s3/patch/integer'
require 'd2s3/signature'

class SignatureTest < ActiveSupport::TestCase
  include D2S3::Signature
  
  def setup
    @num, @cnt = [1732584193, 5]
  end
  
  test "str2binb" do
    assert_equal [1718578976, 1650553376, 1751480608, 1952998770, 1694498816], str2binb('foo bar hey there')
  end
  
  test "core_sha1" do
    assert_equal [-519653305, -1566383753, -2070791546, -753729183, -204968198], core_sha1(str2binb('abc'), 'abc'.length)
  end
  
  test "rol" do
    assert_equal -391880660, rol(@num, @cnt)
  end
  
  test "safe_add" do
    assert_equal -519653305, safe_add(2042729798, @num)
  end
  
  test "sha1_ft" do
    assert_equal -1732584194, sha1_ft(0, -271733879, -1732584194, 271733878)
  end
  
  test "sha1_kt" do
    assert_equal 1518500249, sha1_kt(0)
  end
  
  test "safe_add + sha1_ft + sha1_kt" do
    assert_equal 286718899, safe_add(safe_add(rol(@num, @cnt), sha1_ft(0, -271733879, -1732584194, 271733878)), safe_add(safe_add(-1009589776, 1902273280), sha1_kt(0)))
  end
  
  test "hex_sha1" do
    assert_equal "a9993e364706816aba3e25717850c26c9cd0d89d", hex_sha1("abc")
  end
  
  test "b64_hmac_sha1" do
    assert_equal "frFXMR9cNoJdsSPnjebZpBhUKzI=", b64_hmac_sha1("foo", "abc")
  end
  
end
