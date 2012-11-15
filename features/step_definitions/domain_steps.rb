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
  @build.routes.count.should == count.to_i
end

When /^I call \#to_app on the resulting build for (.*)$/ do |domain|
  self.app = Ambi[eval(domain)].to_app
end

When /^I issue a ([A-Z]+) on "(.*?)"$/ do |method, path|
  self.send method.downcase.to_sym, path
end

Then /^the response status should be (\d+)$/ do |status|
  pending
  last_response.status.should == status.to_i
end

