Given /^a file containing:$/ do |source|
  @source = source
end

When /^I call Ambi\#parse, passing the file's contents$/ do
  @tree = Ambi.parse(@source)
end
