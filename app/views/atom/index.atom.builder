atom_feed language: I18n.locale do |feed|
  feed.title t('default_title')
  feed.updated @products.max_by(&:id).created_at

  @products.each do |product|
    feed.entry product, published: product.created_at, updated: product.updated_at, url: category_product_url(product.category, product) do |entry|
      entry.title product.name
      entry.content product.description unless product.description.blank?
      entry.author do |author|
        author.name SecureSettings.contacts.author
        author.email SecureSettings.contacts.email
      end
    end
  end
end