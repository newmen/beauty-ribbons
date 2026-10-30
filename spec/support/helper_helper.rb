module HelperHelper
  %w(show edit destroy go_back).each do |btn_type|
    RSpec::Matchers.define "have_#{btn_type}_button" do
      match do |actual|
        Capybara.string(actual).all('a[href]').any? do |link|
          link.has_text?(I18n.t("actions.#{btn_type}"))
        end
      end
    end
  end

  RSpec::Matchers.define 'have_add_button' do |model_class_or_title|
    define_method :title do
      if model_class_or_title.is_a? String
        model_class_or_title
      else
        I18n.t('actions.add', model: I18n.t("activerecord.models.#{model_class_or_title.to_s.underscore}"))
      end
    end

    match do |actual|
      Capybara.string(actual).all('a[href]').any? do |link|
        link.has_text?(title) && link.has_selector?('i[class]')
      end
    end
  end
end
