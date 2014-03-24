module ProductsGenerator
  module_function

  def render_colors(num_of_colors)
    @colors_values ||= Color.all.map(&:value)
    num = 0
    while num < num_of_colors do
      color = ''
      3.times { color << rand(255).to_s(16) }
      next if @colors_values.include?(color)
      Color.create(name: color, value: color)
      @colors_values << color
      num += 1
    end
  end

  def random_color
    @colors ||= Color.all
    @colors.sample
  end

  def random_tag
    %w(
      вкусная нежная пленная хитрость добрая волшебная конфетная лакомая
      прелестная стайл далёкая музыкальная лёгкая вольная безумие тень
      смотрящая недоступная чарующая летящая желанная довольная тайна
      внезапность застенчивость нерельный достижимый стимулятор пряность
      космос душа сознание единение связность информация выраженность
    ).sample
  end

  def render_image
    @pathes ||= []
    path = ''
    loop do
      path = Dir['/supply/Images/**/*.jpg'].sample
      break unless @pathes.include?(path)
    end
    @pathes << path
    ProductImage.create(
      image: Rack::Test::UploadedFile.new(path, 'image/jpg')
    )
  end

  def render_name
    first_words = %w(
      Беленький Великолепный Добрый Нежный Незыблемый Пушистый
      Лакомый Броский Заботливый Купатный Челобитный Кровельный
      Кричащий Карамельный Крутой Колокольный Пещерестый Кромешный
      Помпезный Благополучный Правдивый Предельный Кармический
      Полосатый Сахарный Сочный Спелый Малый Коний Челябинский
    )
    second_words = %w(
      чай пчёлка клевер кофейник полисадник пупочек тигр Волька
      мамай кронштат кукух бормотун полоскун енот слон кавай
      мармезон Люк колос ариец подражатель мудрец коное жук пульсар
      стакан Зорро пруша огурец молодец подельник ржец колун молотун
      Соломон провидец крот беглец отец месседж кореец чугун калий
    )

    @names ||= []
    name = ''
    loop do
      name = "#{first_words.sample} #{second_words.sample}"
      break unless @names.include?(name)
    end
    @names << name
    name
  end

  def render_product(category_id)
    image = render_image
    product_hash = {
      category_id: category_id,
      cover_id: image.id,
      name: render_name,
      tag_list: 3.times.map { random_tag }.join(', '),
      price: rand(3000) + 500
    }
    product_hash[:old_price] = rand(5000) + 1000 if rand < 0.127
    product = Product.create(product_hash)
    product.product_images << image
    3.times { product.colors << random_color }
    product
  end

  def render_products(num_of_products, category_id)
    num_of_products.times { render_product(category_id) }
  end
end
