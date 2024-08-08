# frozen_string_literal: true

class TimeFormatter
  VALID_FORMATS = %w[year month day hour minute second].freeze

  TIME_FORMAT_MAP = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  attr_reader :formats, :wrong_formats, :time_string

  def initialize(format, time = Time.now)
    @formats = format.split(',')
    @time = time
    @wrong_formats = []
    @time_string = nil
  end

  def call
    @wrong_formats = @formats - VALID_FORMATS
    format_string = formats.map { |format| TIME_FORMAT_MAP[format] }.join('-')
    @time_string = @time.strftime(format_string)
  end

  def valid?
    wrong_formats.empty?
  end
end
