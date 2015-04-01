module OpalHelper
  def opal_tag(&block)
    opal_code = capture(&block)
    js_code = Opal.compile(opal_code)
    javascript_tag js_code
  end

  def javascript_include_tag(*sources)
    options = sources.extract_options!.stringify_keys
    sprockets = Rails.application.assets

    script_tags = []

    sources.map do |source|
      script_tags << super(source, options)
      loading_code = Opal::Processor.load_asset_code(sprockets, source)
      script_tags << javascript_tag(loading_code) if loading_code.present?
    end
    script_tags.inject(:<<)
  end
end
