
namespace :images do
  def root_folder_path
    /.*web/.match(File.dirname(__FILE__))[0]
  end

  def style_folder_path
    File.join(root_folder_path, 'app/assets/stylesheets')
  end

  desc 'make sprite, usage: rake images:sprite path=.'
  task sprite: :environment do
    # lazy load sprite_factory to avoid pb in heroku
    require 'sprite_factory'

    image_file_path = File.join(Dir.pwd, ENV['path'])
    unless File.exist?(image_file_path)
      puts "Directory not found: #{image_file_path}"
      next
    end

    image_dir_path =
      File.directory?(image_file_path) ? image_file_path : File.dirname(image_file_path)
    basename = File.basename(image_dir_path)
    style_path = File.join(style_folder_path, basename + '-sprite.css')

    SpriteFactory.cssurl = "image-url('#{basename}/$IMAGE')"

    SpriteFactory.run!(image_dir_path, output_style: style_path,
                                       output_image: "#{image_dir_path}/sprite.png",
                                       glob: '*_in',
                                       nocomments: true,
                                       selector: ".#{basename}-",
                                       sanitizer: lambda { |name| name.gsub(/_in$/, '') })

    puts `pngquant -s1 -f #{image_dir_path}/sprite.png --out #{image_dir_path}/sprite.png`

    application_path = File.join(style_folder_path, 'application.css.scss')

    unless File.readlines(application_path).any?{ |l| l == "@import '#{basename}-sprite';\n" }
      File.open(application_path, 'a') { |f| f.puts "@import '#{basename}-sprite';" }
    end
  end
end
