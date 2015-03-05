class Parser
  def initialize(file_name)
    @file = File.open(file_name, 'r+')
    @configuration = {}
    parse_file
  end

  def get_string(section, key)
    get_value(section, key).to_s
  end

  def get_integer(section, key)
    Integer(get_value(section, key))
  end

  def get_float(section, key)
    Float(get_value(section, key))
  end

  def set_string(section, key, value)
    set_value(section, key, value.to_s)
  end

  def set_integer(section, key, value)
    set_value(section, key, Integer(value))
  end

  def set_float(section, key, value)
    set_value(section, key, Float(value))
  end

  private

  def get_value(section, key)
    @configuration[section][key]
  end

  def set_value(section, key, value)
    # @configuration[section] ||= {}
    @configuration[section][key] = value
  end

  def parse_file
    @file.readlines.each_with_index do |line, index|
      if match = check_section(line)
        set_section(match)
      elsif match = check_key_value(line)
        set_key_value(match)
      elsif match = check_value_continuation(line)
        set_value_continuation(match)
      end
    end
  end

  def check_section(line)
    line.match /^\[((\s*\S)+)\s*\]\s*$/
  end

  def check_key_value(line)
    line.match /^(?<key>(\w+\s*)+)\s*:\s*(?<value>(\S+\s*)+)\s*$/
  end

  def check_value_continuation(line)
    line.match /^\s+(?<value>(\S+\s*)+)\s*$/
  end

  def check_blank_line(line)
    line.match /^\s*$/
  end

  def set_section(match)
    @current_section = match[1].strip
    @configuration[@current_section] = {}
  end

  def set_key_value(match)
    if @current_section
      @current_key = match[:key].strip
      @configuration[@current_section][@current_key] = match[:value].strip
    end
  end

  def set_value_continuation(match)
    if @current_key
      @configuration[@current_section][@current_key] += " #{match[:value].strip}"
    end
  end

end

sd = Parser.new("sample_data.txt")
# p sd
# puts "*"*50
p sd.get_string("header", "project")
p sd.get_float("header", "budget")
p sd.get_integer("header", "accessed")
