require 'spec_helper'

<% output_attributes = attributes.reject{ |attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= ns_table_name %>/index" do
  let(:<%= ns_file_name %>) { stub_model(<%= class_name %>, attributes_for(:<%= ns_file_name %>)) }

  before(:each) do
    assign(:<%= table_name %>, [<%= ns_file_name %>, <%= ns_file_name %>])
  end

  it "renders a list of <%= ns_table_name %>" do
    render
<% unless webrat? -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
<% end -%>
<% for attribute in output_attributes -%>
<% if webrat? -%>
    rendered.should have_selector("tr>td", :content => <%= ns_file_name %>.<%= attribute %>.to_s, :count => 2)
<% else -%>
    assert_select "tr>td", :text => <%= ns_file_name %>.<%= attribute %>.to_s, :count => 2
<% end -%>
<% end -%>
  end
end
