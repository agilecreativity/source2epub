require "thor"
require "vim_printer"
require_relative "source2epub"

module Source2Epub
  class CLI < Thor
    desc "export", "Export a given github URL or local project directory to an epub file"
    method_option "url",
                  aliases:  "-u",
                  desc:     "The full url of the github project to be cloned or a directory name (mandtory)",
                  required: true
    method_option "exts",
                  type:     :array,
                  aliases:  "-e",
                  desc:     "The list of file extension to be exported",
                  default: []
    method_option "non_exts",
                  type:     :array,
                  aliases:  "-f",
                  desc:     "The list of file without extension to be exported",
                  default: []
    method_option "theme",
                  aliases:  "-t",
                  desc:     "The theme to be used with vim_printer",
                  default:  "default"
    method_option "command",
                  aliases: "-s",
                  desc: "Use input file list from the result of the given shell command"
    method_option "epub_title",
                  aliases: "-p",
                  desc: "Title to be used for output epub (default to project_name)"
    def export
      exporter = Source2Epub::Exporter.new options[:url],
                                           exts:       options[:exts],
                                           non_exts:   options[:non_exts],
                                           theme:      options[:theme],
                                           command:    options[:command],
                                           epub_title: options[:epub_title]
      exporter.export
    end

    desc "usage", "Display help screen"
    def usage
      puts <<-EOS
Usage:

  $source2epub -u, --url=URL -e, --exts=EXT1 EXT2 EXT3 -t, -theme=theme_name

Example:

  # Export the *.rb from the given repository

  $source2epub -u https://github.com/agilecreativity/source2epub.git -e rb

  # Export the *.rb and also 'Gemfile' from a local directory 'source2epub'
  # Note: must be one directory directly above the current directory

  $source2epub -u source2epub -e rb -f Gemfile

  # Export the *.rb and also 'Gemfile' from a given directory 'source2epub'
  # using 'solarized' theme
  # Note: 'source2epub' must be exactly one level above current directory

  $source2epub -u source2epub -e rb -f Gemfile -t solarized

Options:

  -u, --url=URL                   # The full url of the github project to be cloned or local directory name (mandatory)
                                  # e.g. -u https://github.com/agilecreativity/source2epub
                                  # Or if used with the project already exist locally
                                  #      -u source2epub

  -e, --exts=EXT1 EXT2 EXT3 ..    # The list of extension names to be exported (mandatory)
                                  # e.g. -e md rb

  -f, [--non-exts=one two three]  # The list of file without extension to be exported (optional)
                                  # e.g. -f Gemfile LICENSE

  -t, [--theme=theme_name]        # The theme to be used with vim_printer see :help :colorscheme from inside Vim
                                  # default: 'default'
                                  # e.g. -t solarized

  -p, [--epub-title=title]        # The title of the epub output, if not specified the project_name will be used
                                  # e.g. -p 'My Cool Project'
                                  #
  -s, [--command]                 # Use the input file list from the result of the given shell command
                                  # Note: the command must return the list of file to be valid
                                  # e.g. --command 'find . -type f -iname "*.rb" | grep -v test | grep -v _spec'

Export a given git URL or local project directory to an epub file"

      EOS
    end

    default_task :usage
  end
end
