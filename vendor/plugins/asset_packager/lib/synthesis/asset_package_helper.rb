module Synthesis
  module AssetPackageHelper

    def should_merge?
      AssetPackage.merge_environments.include?(RAILS_ENV)
    end

    def javascript_include_merged(*sources)
      options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
      params = options.delete("params") || {}

      if sources.include?(:defaults)
        sources = sources[0..(sources.index(:defaults))] +
          ['prototype', 'effects', 'dragdrop', 'controls'] +
          (File.exists?("#{RAILS_ROOT}/public/javascripts/application.js") ? ['application'] : []) +
          sources[(sources.index(:defaults) + 1)..sources.length]
        sources.delete(:defaults)
      end

      sources.collect!{|s| s.to_s}
      sources = (should_merge? ?
        AssetPackage.targets_from_sources("javascripts", sources, params) :
        AssetPackage.sources_from_targets("javascripts", sources, params))

      sources.collect {|source| javascript_include_tag(params.empty? ? source : prepare_path(source, params), options) }.join("\n")
    end

    def stylesheet_link_merged(*sources)
      options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }

      sources.collect!{|s| s.to_s}
      sources = (should_merge? ?
        AssetPackage.targets_from_sources("stylesheets", sources) :
        AssetPackage.sources_from_targets("stylesheets", sources))

      sources.collect { |source| stylesheet_link_tag(source, options) }.join("\n")
    end

    def prepare_path(path, params)
      path.gsub(/#\{(.+)\}/) {|s| params[$1]}
    end
  end
end

