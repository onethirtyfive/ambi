Given /^a domain definition:$/ do |definition|
  @definition = definition
end

Given /^a call to Ambi\#parse on this domain definition$/ do
  Ambi.parse(@definition)
end

When /^I access the new (.*) build via Ambi\#\[\]$/ do |domain|
  @build = Ambi[eval(domain)]
end

Then /^it should have (\d+) routes$/ do |count|
  @build.routes.size.should == count.to_i
end

When /^I call \#to_app on the resulting build for (.*)$/ do |domain|
  self.app = Ambi[eval(domain)].to_app
end

When /^I issue a ([A-Z]+) on "(.*?)"$/ do |method, path|
  self.send(method.downcase.to_sym, path)
end

Then /^the response status should be (\d+)$/ do |status|
  last_response.status.should == status.to_i
end

Then /^the response should have the following headers:$/ do |headers|
  headers.hashes.each do |header|
    last_response.should include(header['name'])
    last_response[header['name']].should == header['value']
  end
end

Then /^the response body should be:$/ do |string|
  last_response.body.should == string.strip
end