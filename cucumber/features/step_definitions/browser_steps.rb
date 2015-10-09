
Given /^I open google chrome browser on (.*) host$/ do | type |
    if type == "remote"
        @browser = Watir::Browser.new(:remote, :url => "http://localhost:9515")
    else
        @browser = Watir::Browser.new :chrome
    end
end

Then /^I go to address (.*)$/ do | address |
    @browser.goto address
end

Then /^I close the browser$/ do
    @browser.close
end

Then /^I enter text (.*) into the (.*) field$/ do |input, field|
    @browser.text_field(:name => "entry.1000000").set input
end
