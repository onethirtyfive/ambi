Given /^a file containing:$/ do |source|
  @source = source
end

When /^I call Ambi\#parse, passing the file's contents$/ do
  @tree = Ambi.parse(@source)
end

When /^I access the resulting build for "(.*?)" via Ambi\#\[\]$/ do |domain|
  @build = Ambi[eval(domain)]
end

Then /^the resulting build should have the following attributes:$/ do |attributes|
  pending
end
