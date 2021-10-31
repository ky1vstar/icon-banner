require 'icon_banner/process'

require 'fastlane_core'
require 'mini_magick'

module IconBanner
  class AppIconSet < Process
    BASE_ICON_PATH = '/**/*.appiconset/*.png'
    PLATFORM = 'iOS'
    PLATFORM_CODE = 'ios'

    def generate_banner(path, label, color, background_color, font)
      MiniMagick::Tool::Convert.new do |convert|
        convert.size '1024x1024'
        convert << 'xc:transparent'
        convert << path
      end

      banner = MiniMagick::Image.new path

      banner.combine_options do |combine|
        combine.fill 'rgba(0,0,0,0.25)'
        combine.draw 'polygon 1024,434 1024,718 718,1024 434,1024'
        combine.blur '0x10'
      end

      banner.combine_options do |combine|
        combine.fill background_color
        combine.draw 'polygon 1024,434 1024,718 718,1024 434,1024'
      end

      banner.combine_options do |combine|
        combine.font font
        combine.fill color
        combine.gravity 'Center'
        combine.pointsize 150 - ([label.length - 8, 0].max * 8)
        combine.draw "affine 0.5,-0.5,0.5,0.5,286,286 text 0,0 \"#{label}\""
      end
    end

    def backup_path(path)
      ext = File.extname path
      path.gsub(ext, BACKUP_EXTENSION + ext)
    end

    def should_ignore_icon(icon)
      icon[/\/Carthage\//] || icon[/\/Pods\//] || icon[/\/Releases\//]
    end
  end
end
