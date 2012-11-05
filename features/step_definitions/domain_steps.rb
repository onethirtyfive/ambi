Given /^a file "(.*?)" with:$/ do |title, source|
  @files ||= {}
  @files[title] = @source = source
end

When /^I parse it with:$/ do |source|
  File.stub!(:read).and_return(@source)
  eval(source)
end

When /^I obtain a result with:$/ do |ruby|
  @result = eval(ruby)
end

Then /^result should be a hash containing the following keys:$/ do |table|
  table.rows.collect(&:first).sort.should == Ambi::Domain.all.keys.sort
end
