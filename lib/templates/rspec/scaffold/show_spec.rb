require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= ns_table_name %>/show" do
  let(:<%= ns_file_name %>) { create(:<%= ns_file_name %>) }
  before(:each) do
    assign(:<%= ns_file_name %>, <%= ns_file_name %>)
  end

  it "renders attributes in <p>" do
    render
<% unless webrat? -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% for attribute in output_attributes -%>
<% if webrat? -%>
    rendered.should contain(<%= value_for(attribute) %>.to_s)
<% else -%>
    rendered.should match <%= ns_file_name %>.<%= attribute.name %>.to_s
<% end -%>
<% end -%>
  end
end
