## source2epub

[![Gem Version](https://badge.fury.io/rb/source2epub.svg)][gem]
[![Dependency Status](https://gemnasium.com/agilecreativity/source2epub.png)][gemnasium]
[![Code Climate](https://codeclimate.com/github/agilecreativity/source2epub.png)][codeclimate]

[gem]: http://badge.fury.io/rb/source2epub
[gemnasium]: https://gemnasium.com/agilecreativity/source2epub
[codeclimate]: https://codeclimate.com/github/agilecreativity/source2epub

- Export/print content of any git repositores (or local project directory) to single epub file for quick review offline.

- Work with [Github][] or [BitBucket][] project or your own git servers

- Thanks to the power of [eeepub gem][] and `:TOhtml` feature of [Vim][].

- Support by your favourite reading devices that support 'epub' format (computer, phone, tablet, etc) that

- Support unlimited color scheme as it is based on output from [Vim][] editor

- Here is the [sample epub file](/samples/source2epub_default_colorscheme.epub) of [source2epub][] produced by `source2epub`

### Related projects

- [source2pdf][] generate the output of the git or local project to a pdf file
- [code_rippa][] gererate pdf file with the help of LaTeX

### Requirements

- Valid installation of [Vim][] required by [vim_printer][] gem

### Installation

```
gem install source2epub
```

### Synopsis/Usage

```

Usage:

  $source2epub -e, --exts=EXT1 EXT2 EXT3 -u, --url=URL -theme=theme_name

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

Export a given github URL or local project directory to an epub file"

```

### Sample Usage:

```shell
source2epub -u https://github.com/agilecreativity/source2epub.git -e rb
```

Should result in something similar to this in the console

```
FYI: list of extensions: ["gem", "gemspec", "lock", "md", "rb"]
FYI: list of all files : ["./config/initializers/source2epub.rb", "./lib/source2epub.rb", "./lib/source2epub/cli.rb", "./lib/source2epub/configuration.rb", "./lib/source2epub/exporter.rb", "./lib/source2epub/logger.rb", "./lib/source2epub/source2epub.rb", "./lib/source2epub/version.rb", "./test/lib/source2epub/test_source2epub.rb", "./test/test_helper.rb"]
FYI: process file 1 of 10 : ./config/initializers/source2epub.rb
FYI: process file 2 of 10 : ./lib/source2epub.rb
FYI: process file 3 of 10 : ./lib/source2epub/cli.rb
FYI: process file 4 of 10 : ./lib/source2epub/configuration.rb
FYI: process file 5 of 10 : ./lib/source2epub/exporter.rb
FYI: process file 6 of 10 : ./lib/source2epub/logger.rb
FYI: process file 7 of 10 : ./lib/source2epub/source2epub.rb
FYI: process file 8 of 10 : ./lib/source2epub/version.rb
FYI: process file 9 of 10 : ./test/lib/source2epub/test_source2epub.rb
FYI: process file 10 of 10 : ./test/test_helper.rb
Your output file is './source2epub/vim_printer_source2epub.tar.gz'
Your final output is ./source2epub.epub
```

### Sample Output

#### Using the 'default' theme/colorscheme for Vim

```shell
source2epub -u https://github.com/agilecreativity/code2epub.git --exts rb
```

Which generated the following [epub output file](/samples/source2epub_default_colorscheme.epub)

The example screenshot:

![](/samples/source2epub_default_colorscheme.png)

#### Use non-default colorscheme/theme for Vim

Use my personal favourite [seoul256][] colorscheme

```shell
source2epub -u https://github.com/agilecreativity/source2epub.git --exts rb --theme seoul256
```

Which generated the following [pdf output file](/samples/source2epub_seoul256_colorscheme.epub)

The example screenshot:

![](/samples/source2epub_seoul256_colorscheme.png)

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[thor]: https://github.com/erikhuda/thor
[minitest]: https://github.com/seattlerb/minitest
[yard]: https://github.com/lsegal/yard
[pry]: https://github.com/pry/pry
[rubocop]: https://github.com/bbatsov/rubocop
[grit]: https://github.com/mojombo/grit
[Ghostscript]: http://todo.com/
[Wkhtmltopdf]: http://todo.com/
[Vim]: http://www.vim.org
[vim_printer]: https://github.com/agilecreativity/vim_printer
[pdfs2pdf]: https://github.com/agilecreativity/pdfs2pdf
[html2pdf]: https://github.com/agilecreativity/html2pdf
[monokai]: https://github.com/lsdr/monokai
[seoul256]: https://github.com/junegunn/seoul256.vim
[Github]: http://www.github.com
[BitBucket]: http://www.bitbucket.org
[source2pdf]: https://github.com/agilecreativity/source2pdf
[source2epub]: https://github.com/agilecreativity/source2epub
[code_rippa]: https://github.com/benjamintanweihao/code_rippa
