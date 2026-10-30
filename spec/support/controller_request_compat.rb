module ControllerRequestCompat
  LEGACY_OPTION_KEYS = %i[format session flash xhr body as method].freeze

  %w[get post put patch delete head].each do |verb|
    define_method(verb) do |action, *args, **kwargs|
      options = kwargs.dup
      options.update(args.pop) if args.last.is_a?(Hash)
      options = normalize_legacy_request_args(options)
      process(action, method: verb.upcase, **options)
    end
  end

  private

  def normalize_legacy_request_args(args)
    return args if args.empty? || args.key?(:params)

    options = args.slice(*LEGACY_OPTION_KEYS)
    params = args.except(*LEGACY_OPTION_KEYS)
    options[:params] = params unless params.empty?
    options
  end
end

ActionController::TestCase::Behavior.prepend(ControllerRequestCompat)
