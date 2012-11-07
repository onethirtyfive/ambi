Given /^a file containing:$/ do |source|
  @source = source
end

When /^I parse the file with Ambi$/ do
  Ambi.parse!(@source)
end

Then /^Ambi should be aware of the following domains:$/ do |table|
  table.rows.collect(&:first).collect(&:to_sym).sort.should == Ambi.domains.keys.sort
end
