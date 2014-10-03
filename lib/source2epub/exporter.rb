module Source2Epub
  TMP_DIR = "source2epub_tmp"
  class Exporter
    attr_reader :url,
                :exts,
                :non_exts,
                :theme,
                :command,
                :epub_title

    attr_reader :base_dir,
                :repo_name,
                :output_path

    # Constructor for Executor
    #
    # @param [String] url the input URL like
    #        https://github.com/opal/opal.git or just the immediat folder name
    # @param [Hash<Symbol,Object>] opts the option hash
    #
    # @option opts [Array<String>] :exts the list of file extension to be used
    # @option opts [Array<String>] :non_exts the list of file without extension to be used
    # @option opts [String]        :theme the theme to use for `vim_printer` (optional)
    # @option opts [String]        :command the shell command to be used if any (optional)
    # @option opts [String]        :epub_title the title for the output (optional)
    def initialize(url, opts = {})
      @url         = url
      @base_dir    = Dir.pwd
      @exts        = opts[:exts]     || []
      @non_exts    = opts[:non_exts] || []
      @theme       = opts[:theme]    || "default"
      @command     = opts[:command]
      @repo_name   = project_name(url)
      @epub_title  = opts[:epub_title] || @repo_name
      @output_path = File.expand_path([base_dir, repo_name].join(File::SEPARATOR))
    end

    # Print and export the source from a given URL to an epub file
    def export
      clone
      puts "FYI: list of extensions: #{all_extensions}"
      # Note: if we are using the '--command', it will be empty list by default
      puts "FYI: list of all files : #{all_files}" unless all_files.empty?
      files2htmls
      htmls2epub
      copy_output
      cleanup
    end

    private

    def clone
      if File.exist?(output_path)
        puts "The project #{output_path} already exist, no git clone needed!"
        return
      end
      Source2Epub.clone_repository(url, repo_name, base_dir)
    end

    # List all extensions
    def all_extensions
      all_exts = Source2Epub.list_extensions(output_path)
      # Strip off the '.' in the output if any.
      all_exts.map! { |e| e.gsub(/^\./, "") }
      all_exts
    end

    # List all files base on simple criteria
    def all_files
      files = []
      if input_available?
        files = Source2Epub.list_files base_dir:  output_path,
                                       exts:      exts,
                                       non_exts:  non_exts,
                                       recursive: true
      end
      files
    end

    # Convert files to htmls
    def files2htmls
      # get input from the shell command if one is specified
      if command
        Source2Epub.files_to_htmls base_dir: output_path,
                                   theme:    theme,
                                   command:  command
      elsif input_available?
        Source2Epub.files_to_htmls base_dir: output_path,
                                   exts:     exts,
                                   non_exts: non_exts,
                                   theme:    theme
      end
    end

    # Convert list of html to list of epub file
    def htmls2epub
      input_file = File.expand_path("#{output_path}/vim_printer_#{repo_name}.tar.gz")
      if File.exist?(input_file)
        FileUtils.mkdir_p(output_dir)
        AgileUtils::FileUtil.gunzip(input_file, output_dir)
        xhtml_files = CodeLister.files base_dir:  output_dir,
                                       recursive: true,
                                       exts:      %w[xhtml],
                                       non_exts:  []
        project_dir = File.expand_path(File.dirname(output_dir) + "../../#{Source2Epub::TMP_DIR}/#{repo_name}")
        xhtml_files.map! do |f|
          File.expand_path(f.gsub(/^\./, project_dir))
        end
        nav_list = nav_index(xhtml_files, project_dir)
        create_epub(xhtml_files, nav_list)
      end
    end

    # Create the navigation list from list of file
    #
    # @param [Array<String>] files list of input file
    # @param [String] prefix_dir the prefix directory
    # @return [List<Hash<Symbol, String>>] list of navigation content hash
    def nav_index(files = [], prefix_dir)
      nav_list = []
      padding = files.size.to_s.length
      files.each_with_index do |file, index|
        # still we have "somfile.ext.xhtml" at this point
        formatted_name = file.gsub("#{prefix_dir}/", "")
        nav_list << {
          label:   format("%0#{padding}d : %s", index + 1, File.basename(formatted_name, ".*")),
          content: File.basename(file)
        }
      end
      nav_list
    end

    def output_dir
      File.expand_path("#{base_dir}/#{Source2Epub::TMP_DIR}/#{repo_name}")
    end

    def output_filename
      File.expand_path([File.dirname(output_dir), "#{repo_name}.epub"].join(File::SEPARATOR))
    end

    def input_available?
      (exts && !exts.empty?) || (non_exts && !non_exts.empty?)
    end

    # Extract project name from a given URL
    #
    # @param [String] uri input uri
    #  e.g.
    #  project_name('https://github.com/erikhuda/thor.git') #=> 'thor'
    #  project_name('https://github.com/erikhuda/thor')     #=> 'thor'
    def project_name(uri)
      if uri
        name = URI(uri).path.split(File::SEPARATOR).last
        # strip the '.' if any
        File.basename(name, ".*") if name
      end
    end

    def copy_output
      if File.exist?(output_filename)
        destination_file = File.expand_path(File.dirname(output_dir) + "../../#{repo_name}.epub")
        FileUtils.mv output_filename, destination_file
        puts "Your final output is #{File.expand_path(destination_file)}"
      end
    end

    def cleanup
      FileUtils.rm_rf File.expand_path(File.dirname(output_dir) + "../../#{Source2Epub::TMP_DIR}")
      # Also remove the 'vim_printer_#{repo_name}.tar.gz' if we have one
      FileUtils.rm_rf File.expand_path(File.dirname(output_dir) + "../../#{repo_name}/vim_printer_#{repo_name}.tar.gz")
    end

    def create_epub(xhtml_files, nav_list)
      # Note: need to assign the local varaiable for this to work
      title = epub_title
      epub = EeePub.make do
        title title
        creator Source2Epub.configuration.creator
        publisher Source2Epub.configuration.publisher
        date Source2Epub.configuration.published_date
        identifier Source2Epub.configuration.identifier, scheme: "URL"
        files(xhtml_files)
        nav nav_list
      end
      epub.save(output_filename)
    end
  end
end
