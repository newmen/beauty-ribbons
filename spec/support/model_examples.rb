module ModelExamples
  shared_examples "emailable" do |email_field_name|
    %w(123@keks.ru asd.b@mama.pro aa22@god.com 22-aa@mod.edu).each do |value|
      it { should allow_value(value).for(email_field_name) }
    end

    %w(1+1@ya.ru -i-@mu.mu uhi@d_b.org ne@be.a .riba@metch. kuku 11111 йоу@da.net).each do |value|
      it { should_not allow_value(value).for(email_field_name) }
    end
  end

  shared_examples "colorable" do |color_field_name|
    %w(123456 abcdef).each do |value|
      it { should allow_value(value).for(color_field_name) }
    end

    %w(asdfasbasd 01231021023 ffff asdfff).each do |value|
      it { should_not allow_value(value).for(color_field_name) }
    end
  end

  shared_examples "priceable" do |price_field_name|
    it { should allow_value('10000').for(price_field_name) }
    it { should_not allow_value('asdf').for(price_field_name) }
  end

  # because "it { should validate_uniqueness_of(:field) }" does not always work die not null db field
  shared_examples "validate_uniqueness" do |field_name|
    it "validate uniqueness of #{field_name}" do
      target_symbol = described_class.to_s.downcase.to_sym
      value = 'abc123'
      create(target_symbol, field_name => value)

      target = build(target_symbol, field_name => value)
      target.should_not be_valid
      target.errors[field_name].should_not be_nil
    end
  end
end