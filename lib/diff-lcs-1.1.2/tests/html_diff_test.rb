#! /usr/bin/env ruby
#
$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib") if __FILE__ == $0
require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../lib/diff/html_diff'

class HtmlDiffTest < Test::Unit::TestCase

  def test_insert
    a = 'I am the man'
    b = 'I am the super man'
    assert_equal( 'I am the <ins>super</ins> man', html_diff( a, b ) )
  end

  def test_delete
    a = 'I am the super man'
    b = 'I am the man'
    assert_equal( 'I am the <del>super</del> man', html_diff( a, b ) )
  end

  def test_change
    a = 'I am the super man'
    b = 'I am the wonderful man'
    assert_equal( 'I am the <del>super</del> <ins>wonderful</ins> man', html_diff( a, b ) )
  end

  def test_multi_word_insert
    a = 'I am the man'
    b = 'I am the super duper man'
    assert_equal( 'I am the <ins>super duper</ins> man', html_diff( a, b ) )
  end

  def test_multi_word_delete
    a = 'I am the super duper man'
    b = 'I am the man'
    assert_equal( 'I am the <del>super duper</del> man', html_diff( a, b ) )
  end

  def test_multi_word_changes
    a = 'I walk down the street'
    b = 'I talk in the street'
    assert_equal( 'I <del>walk down</del> <ins>talk in</ins> the street', html_diff( a, b ) )
  end

  def test_insert_delete_change
    a = 'I am the man'
    b = 'I the woman yo'
    assert_equal( 'I <del>am</del> the <del>man</del> <ins>woman yo</ins>', html_diff( a, b ) )
  end

  def test_overlapping_insert_change
    a = "Everything you say you won't"
    b = "Everything you have ever said I won't"
    assert_equal( "Everything you <del>say you</del> <ins>have ever said I</ins> won't", html_diff( a, b ) )
  end

  def test_overlapping_delete_change
    a = "Everything you have ever said I won't"
    b = "Everything you say you won't"
    assert_equal( "Everything you <ins>say you</ins> <del>have ever said I</del> won't", html_diff( a, b ) )
  end

  def test_alternate_html_tags
    a = 'I am man yo'
    b = 'I am woman'
    diff = html_diff( a, b, 'span', 'span', 'diff_delete', 'diff_insert' )
    assert_equal( 'I am <span class="diff_insert">woman</span> <span class="diff_delete">man yo</span>', diff )
  end

  def test_newlines_remain_intact_no_content_change
    a = "I \n am \n man yo"
    b = "I \n am \n man yo"
    diff = html_diff( a, b )
    assert_equal( "I\nam\nman yo", diff )
  end
  
  def test_newlines_remain_intact_and_get_spaces_around_them
    a = "I\nam\nman yo"
    b = "I\nam\nman yo"
    diff = html_diff( a, b )
    assert_equal( "I\nam\nman yo", diff )
  end
  
  def test_newlines_remain_intact
    a = "I\nam\nman yo"
    b = "I\nam\nwoman"
    diff = html_diff( a, b )
    assert_equal( "I\nam\n<ins>woman</ins> <del>man yo</del>", diff )
  end

  def test_html_formatting_tags_next_to_words
    a = 'ratings</li> <li>Define a "microformat"</li> <li>this'
    b = 'ratings</li> <li>Create the crawler</li> <li>this'
    diff = html_diff( a, b )
    assert_equal( 'ratings</li> <li><del>Define a "microformat"</del> <ins>Create the crawler</ins></li> <li>this', diff )
  end

end
