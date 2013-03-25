module OrderExamples
  shared_examples "associated_with_products" do
    let(:category) { create(:category) }
    let(:product1) { create(:product, category: category) }
    let(:product2) { create(:product, category: category) }

    it "set and get associated products" do
      order.product_ids = [product1.id, product2.id]
      order.products.should include(product1, product2)
    end
  end

  shared_examples "sequenced_states" do
    it "confirmed before processing" do
      order.state = 'confirmed'
      order.next_state.should eq('processing')
    end

    it "processing before completed" do
      order.state = 'processing'
      order.next_state.should eq('completed')
    end

    it "nil after completed" do
      order.state = 'completed'
      order.next_state.should be_nil
    end

    it "nil after canceled" do
      order.state = 'canceled'
      order.next_state.should be_nil
    end
  end
end