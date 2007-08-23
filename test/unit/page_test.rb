require File.dirname(__FILE__) + '/../test_helper'

class PageTest < Test::Unit::TestCase
  fixtures :pages

  def test_fixtures_1
    p = Page.find 1
    assert "MyString", p.title
  end
  
  def test_fixtures_2
    assert "MyString", pages(:one)
  end
end
