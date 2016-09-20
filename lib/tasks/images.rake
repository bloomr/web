require 'sprite_factory'

namespace :images do
  def root_folder_path
    /.*web/.match(File.dirname(__FILE__))[0]
  end

  def style_folder_path
    File.join(root_folder_path, 'app/assets/stylesheets')
  end

  desc 'make sprite, usage: rake images:sprite path=.'
  task sprite: :environment do
    image_file_path = File.join(Dir.pwd, ENV['path'])
    unless File.exist?(image_file_path)
      puts "Directory not found: #{image_file_path}"
      next
    end

    image_dir_path = File.directory?(image_file_path) ? image_file_path : File.dirname(image_file_path)
    puts image_dir_path
    image_basename = File.basename(image_dir_path)
    sprite_style_path = File.join(style_folder_path, image_basename + '-sprite.css')
    SpriteFactory.cssurl = "image-url('#{image_basename}/$IMAGE')"

    SpriteFactory.run!(image_dir_path, output_style: sprite_style_path,
                                       output_image: "#{image_dir_path}/sprite.png",
                                       glob: '*_in',
                                       nocomments: true,
                                       selector: '.',
                                       sanitizer: lambda { |name| name.gsub(/_in$/, '') })

    puts `pngquant -s1 -f #{image_dir_path}/sprite.png --out #{image_dir_path}/sprite.png`

    application2_path = File.join(style_folder_path, 'application2.css.scss')

    unless File.readlines(application2_path).any?{ |l| l == "@import '#{image_basename}-sprite';\n" }
      File.open(application2_path, 'a') { |f| f.puts "@import '#{image_basename}-sprite';" }
    end
  end
end
