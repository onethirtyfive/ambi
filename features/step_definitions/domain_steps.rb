Given /^a file containing:$/ do |source|
  @source = source
end

When /^Ambi parses the file into a Rack\-compatible app$/ do
  Ambi.parse!(@source)
end

Then /^Ambi should be aware of the following domains:$/ do |table|
  table.rows.collect(&:first).collect(&:to_sym).sort.should == Ambi::Domain.all.keys.sort
end
