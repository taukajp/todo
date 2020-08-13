# frozen_string_literal: true

require "test_helper"

class StringTest < Minitest::Test
  def test_ljust_ja
    assert_equal("test      ", "test".ljust_ja(10))
  end

  def test_ljust_ja_ja
    assert_equal("テスト    ", "テスト".ljust_ja(10))
  end

  def test_rjust_ja
    assert_equal("      test", "test".rjust_ja(10))
  end

  def test_rjust_ja_ja
    assert_equal("    テスト", "テスト".rjust_ja(10))
  end

  def test_center_ja
    assert_equal("   test   ", "test".center_ja(10))
  end

  def test_center_ja_ja
    assert_equal("  テスト  ", "テスト".center_ja(10))
  end
end
