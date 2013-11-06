require File.expand_path(File.dirname(__FILE__)+"/../" )+'/lib/rwebat'

describe "Assert on the Google search home page" do
  
  before do
    $option = "ie" #firefox ie
  end

  it "All below items should be display" do
    open_browser("http://www.google.com/ncr",$option)
    enter_text_with_name("q","watir")
    enter_text("name","q","watir2")
    assert_title_equals("Google")
    assert_button_present_with_name("btnG")
    assert_text_present("Go")
    assert_text_not_present("Go")
    assert_link_present_with_exact_text("Advertising Programs")
    assert_link_not_present_with_exact_text("China")
  end

  after do
    close_browser
  end

end





