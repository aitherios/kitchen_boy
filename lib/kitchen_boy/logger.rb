require 'rainbow'

module KitchenBoy::Logger
  
  def log_success string
    log message: string,
        title:   'hey',
        color:   :green
  end

  def log_warning string
    log message: string,
        title:   'watchout',
        color:   :yellow
  end

  def log_error string
    log message: string,
        title:   'danger',
        color:   :red,
        output:  $stderr
  end
  
  def log options = {}
    options[:output] ||= $stdout

    options[:output].puts(('%10.10s' % options[:title]).foreground(options[:color]) +
                          "  " + options[:message])
  end
end
