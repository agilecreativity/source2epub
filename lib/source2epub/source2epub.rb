require "git"
require "code_lister"
require_relative "./configuration"
module Source2Epub
  CustomError = Class.new(StandardError)
  class << self

    # Clone the given repository from github
    #
    # @param [String] url the github repository url like 'https://github.com/schacon/ruby-git.git'
    # @param [String] name the output name to be used
    # @param [String] path the output directory
    def clone_repository(url, name, path)
      puts "git clone #{url} #{File.expand_path(path)}/#{name}"
      Git.clone url, name, path: File.expand_path(path)
    end

    def list_extensions(base_dir = ".")
      extensions = Dir.glob(File.join(File.expand_path(base_dir), "**/*")).reduce([]) do |exts, file|
        exts << File.extname(file)
      end
      extensions.sort.uniq.delete_if { |e| e == "" }
    end

    def list_files(options = {})
      CodeLister.files(options)
    end

    def files_to_htmls(opts)
      base_dir = base_dir(opts[:base_dir])
      unless File.exist?(base_dir) && File.directory?(base_dir)
        fail "Starting directory must be valid, and exist"
      end

      exts     = opts[:exts]     || []
      non_exts = opts[:non_exts] || []
      theme    = opts.fetch(:theme, "default")
      command  = opts[:command]

      if command
        args = [
          "print",
          "--base-dir",
          base_dir,
          "--command",
          command,
          "--theme",
          theme
        ]
      else
        args = [
          "print",
          "--base-dir",
          base_dir,
          "--exts",
          exts,
          "--theme",
          theme,
          "--recursive"
        ]
        args.concat(["--non-exts"]).concat(non_exts) unless non_exts.empty?
      end
      # puts "FYI: input options for vim_printer #{args}"
      VimPrinter::CLI.start(args)
    end

  private

    # Always expand the directory name so that '~' or '.' is expanded correctly
    def base_dir(dir_name)
      File.expand_path(dir_name)
    end
  end
end
