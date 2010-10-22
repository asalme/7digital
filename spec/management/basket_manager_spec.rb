require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "BasketManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @basket_manager = Sevendigital::BasketManager.new(@client)
  end

  it "get should call basket api method and return digested basket" do
    a_basket_id = "00000000-0000-0000-0000-000000000001"
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/index")

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.operator.should_receive(:call_api) { |api_request|
      api_request.api_method.should == "basket"
      api_request.parameters[:basketId].should  == a_basket_id
      an_api_response
    }

    basket = @basket_manager.get(a_basket_id)
    basket.should == a_basket
  end

  it "create should call basket/create api method and return digested created basket" do
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/create")

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.operator.should_receive(:call_api) { |api_request|
      api_request.api_method.should == "basket/create"
      an_api_response
    }

    basket = @basket_manager.create
    basket.should == a_basket
  end

  it "add_item should call basket/addItem api method and return digested basket" do
    a_basket_id = "00000000-0000-0000-0000-000000000001"
    a_release_id = 123
    a_track_id = 456
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/additem")

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.operator.should_receive(:call_api) { |api_request|
      api_request.api_method.should == "basket/addItem"
      api_request.parameters[:basketId].should  == a_basket_id
      api_request.parameters[:releaseId].should  == a_release_id
      api_request.parameters[:trackId].should  == a_track_id
      an_api_response
    }

    basket = @basket_manager.add_item(a_basket_id, a_release_id, a_track_id)
    basket.should == a_basket
  end

  it "remove_item should call basket/removeItem api method and return digested basket" do
    a_basket_id = "00000000-0000-0000-0000-000000000001"
    an_item_id = 123456
    a_basket = Sevendigital::Basket.new(@client)
    an_api_response = fake_api_response("basket/removeitem")

    mock_client_digestor(@client, :basket_digestor) \
          .should_receive(:from_xml).with(an_api_response.content.basket).and_return(a_basket)

    @client.operator.should_receive(:call_api) { |api_request|
      api_request.api_method.should == "basket/removeItem"
      api_request.parameters[:basketId].should  == a_basket_id
      api_request.parameters[:itemId].should  == an_item_id
      an_api_response
    }

    basket = @basket_manager.remove_item(a_basket_id, an_item_id)
    basket.should == a_basket
  end


end