MoneyRails.configure do |config|
  config.default_currency = :rub
  config.include_validations = false
end

Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.locale_backend = :i18n
Money.default_currency = "RUB"
