class CategoriesController < ProductsFilterController
  before_filter :authenticate_user!, except: [:show]

  filter_scopes only: :show

  add_default_breadcrumbs_and_call_filter except: [:show, :destroy]

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /category-slug
  def show
    @category = Category.find(params[:slug])
    if request.path != category_path(@category)
      redirect_to @category, status: :moved_permanently
    end
    @products = @category.products.not_archived
    @title = @category.name
    add_breadcrumb @title, "/#{@category.slug}"
  end

  # GET /categories/new
  def new
    add_create_breadcrumb
    @category = Category.new
  end

  # GET /category-slug/edit
  def edit
    add_edit_breadcrumb
    @category = Category.find(params[:slug])
  end

  # POST /categories
  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to @category,
                  notice: I18n.t('controller.success_create', model: I18n.t('activerecord.models.category'))
    else
      add_create_breadcrumb
      render :new
    end
  end

  # PUT /category-slug
  def update
    @category = Category.find(params[:slug])
    if @category.update_attributes(params[:category])
      redirect_to @category,
                  notice: I18n.t('controller.success_update', model: I18n.t('activerecord.models.category'))
    else
      add_edit_breadcrumb
      render :edit
    end
  end

  # DELETE /category-slug
  def destroy
    @category = Category.find(params[:slug])
    if @category.products.count > 0
      redirect_to @category, alert: I18n.t('controller.category_has_products')
    else
      @category.destroy
      redirect_to control_panel_url,
                  notice: I18n.t('controller.success_destroy', model: I18n.t('activerecord.models.category'))
    end
  end

  private

  def add_breadcrumbs
    add_control_panel_breadcrumb
    add_breadcrumb I18n.t('categories.index.title'), categories_path
  end

  def add_create_breadcrumb
    add_breadcrumb I18n.t('categories.new.title')
  end

  def add_edit_breadcrumb
    add_breadcrumb I18n.t('categories.edit.title')
  end
end
