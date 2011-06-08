module Ezcript
  module ApplicationHelperExtension
    def self.included(base)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods

      # yield for content_for, but will display default contents if content_for is not given
      def yield_or_inline(yield_name, partial_name = nil, &block)
        if @_content_for[yield_name] && !@_content_for[yield_name].empty?
          @_content_for[yield_name]
        else
          if block_given?
            render :inline => capture(&block)
          else
            render :partial => partial_name if partial_name
          end
        end
      end

      #If declared will include "controller#scripts and controller#action_scripts to the layout"
      def yield_local_scripts
        scripts = []
        if "production".eql?(Rails.env)
          js_cache_dir = File.join(Rails.root, "tmp", "cache", "js")
          FileUtils.mkdir_p(js_cache_dir) unless File.exist?(js_cache_dir)
        end

        ["scripts", "#{action_name}_scripts"].each do |f|
          partial_src = File.join(Rails.root, "app", "views", controller_name, "_#{f}.js.erb")
          if File.exist?(partial_src)
            
            src = render(:partial => "#{controller_name}/#{f}.js")

            if "production".eql?(Rails.env)
              js_src = File.join(js_cache_dir, "#{controller_name}_#{File.basename(f, ".erb")}.min.js")
              unless File.exist?(js_src)
                File.open(js_src, "w") {|js_f| js_f.puts(JSMin.minify(src))}
              end
              src = render(:file => js_src)
            end
            scripts << src
          end
        end
        render :inline => scripts.join("\n")
      end

      def yield_local_styles
        scripts = []
        ["styles", "#{action_name}_styles"].each do |f|
          scripts << render(:partial => "#{controller_name}/#{f}.css") if File.exist?(File.join(Rails.root, "app", "views", controller_name, "_#{f}.css.erb"))
        end
        render :inline => scripts.join("\n")
      end

=begin 
      def render_minified_style(source, opt={})
        options = {:type => "text/css"}.merge(opt)
        source = "#{Rails.root}/public/assets/stylesheets/#{source}"     
        source << ".css" unless source.end_with?(".css")           
        if ["staging","production"].include?(Rails.env)
          css_cache_dir = File.join(Rails.root, "tmp", "cache", "css")
          FileUtils.mkdir_p(css_cache_dir) unless File.exist?(css_cache_dir)
          src = File.join(css_cache_dir, File.basename(source))
          unless File.exist?(src)
            File.open(src, "w") {|f| f.puts(R3xt::Minifier::Stylesheet.new(source, true).minified) }
          end
        else
          src = source
        end
        c = render(:file => src)
        content_tag(:style, c.gsub("../images/", "#{Compass::Info.asset_dir}/images/"), options)
      end

      def render_minified_script(source, opt={})
        options = {:type => "text/javascript"}.merge(opt)
        source = "#{Rails.root}/public/assets/javascripts/#{source}"     
        source << ".js" unless source.end_with?(".js")           
        if ["staging","production"].include?(Rails.env)
          js_cache_dir = File.join(Rails.root, "tmp", "cache", "js")
          FileUtils.mkdir_p(js_cache_dir) unless File.exist?(js_cache_dir)
          src = File.join(js_cache_dir, File.basename(source))
          unless File.exist?(src)
            c = ""
            File.open(source, "r") {|f| c = f.read}
            File.open(src, "w") {|f| f.puts(JSMin.minify(c)) }
          end
        else
          src = source
        end
        c = render(:file => src)
        content_tag(:script, c, options)
      end
=end

    end
  end
end

module ActionView
  module Helpers
    module AssetTagHelper

        def stylesheet_tag(source, options)
          s= "#{Compass::Info.asset_dir}/stylesheets/#{source}"
          tag("link", { "rel" => "stylesheet", "type" => Mime::CSS, "media" => "screen", "href" => html_escape(path_to_stylesheet(s)) }.merge(options), false, false)
        end

        def javascript_src_tag(source, options)
          s= "#{Compass::Info.asset_dir}/javascripts/#{source}"
          s << ".js" unless s.end_with?(".js")
          content_tag("script", "", { "type" => Mime::JS, "src" => path_to_javascript(s) }.merge(options))
        end

      def image_tag(source, options = {})
        options.symbolize_keys!

        src = options[:src] = "#{Compass::Info.asset_dir}#{path_to_image(source)}"

        unless src =~ /^cid:/
          options[:alt] = options.fetch(:alt){ File.basename(src, '.*').capitalize }
        end

        if size = options.delete(:size)
          options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
        end

        if mouseover = options.delete(:mouseover)
          options[:onmouseover] = "this.src='#{path_to_image(mouseover)}'"
          options[:onmouseout]  = "this.src='#{src}'"
        end

        tag("img", options)
      end

      def complete_link_to(*args, &block)
        if block_given?
          options      = args.first || {}
          html_options = args.second
          link_to(capture(&block), options, html_options)
        else
          name         = args[0]
          options      = args[1] || {}
          html_options = args[2]

          html_options = convert_options_to_data_attributes(options, html_options)
          url = url_for(options)
          url = File.join(Compass::Info.app_host, url).to_s unless url.downcase.starts_with?("http")

          if html_options
            html_options = html_options.stringify_keys
            href = html_options['href']
            tag_options = tag_options(html_options)
          else
            tag_options = nil
          end

          href_attr = "href=\"#{html_escape(url)}\"" unless href
          "<a #{href_attr}#{tag_options}>#{(name || url)}</a>".html_safe
        end
      end

    end
  end
end
