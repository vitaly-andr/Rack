# frozen_string_literal: true

class TimeFormatter

  TIME_FORMAT_MAP = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze
  def self.format(formats, time = Time.now)


    format_string = formats.map { |format| TIME_FORMAT_MAP[format] }.join('-')
    puts format_string
    time.strftime(format_string)
  end
end
