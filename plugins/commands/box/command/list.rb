require 'optparse'

module VagrantPlugins
  module CommandBox
    module Command
      class List < Vagrant.plugin("2", :command)
        def execute
          options = {}

          opts = OptionParser.new do |opts|
            opts.banner = "Usage: vagrant box list"
          end

          # Parse the options
          argv = parse_options(opts)
          return if !argv

          boxes = @env.boxes.all.sort
          if boxes.empty?
            return @env.ui.warn(I18n.t("vagrant.commands.box.no_installed_boxes"), :prefix => false)
          end

          # Find the longest box name
          longest_box = boxes.max_by { |x| x[0].length }
          longest_box_length = longest_box[0].length

          # Find the longest provider name
          longest_provider = boxes.max_by { |x| x[1].length }
          longest_provider_length = longest_provider[1].length

          # Go through each box and output the information about it. We
          # ignore the "v1" param for now since I'm not yet sure if its
          # important for the user to know what boxes need to be upgraded
          # and which don't, since we plan on doing that transparently.
          boxes.each do |name, provider, _v1|
            name     = name.ljust(longest_box_length)
            provider = "(#{provider})".ljust(longest_provider_length + 2) # 2 -> parenthesis
            box_info = "#{name} #{provider}"

            @env.ui.info(box_info, :prefix => false)
          end

          # Success, exit status 0
          0
        end
      end
    end
  end
end
