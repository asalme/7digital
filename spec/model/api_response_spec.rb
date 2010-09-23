require "spec"
require 'sevendigital'

describe "ApiResponse" do

  it "should be ok if error code is 0 and content is not empty" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.content = '<xml></xml>'
    response.ok?.should == true

  end

  it "should not be ok if error code is not 0" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 5
    response.content = '<xml></xml>'
    response.ok?.should == false

    end

  it "should not be ok if response content is nil" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.ok?.should == false

  end

  it "should be serializable" do
    original_response = Sevendigital::ApiResponseDigestor.new(@client).from_xml("<response status='ok'><test /></response>")
    original_response.error_code = 99

    tmp = Marshal.dump(original_response)
    restored_response = Marshal.load(tmp)

    restored_response.error_code.should == original_response.error_code
    restored_response.content.should == original_response.content

  end

end