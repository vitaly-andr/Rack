require 'rack'

class TimeApp
  VALID_FORMATS = %w[year month day hour minute second].freeze
  def call(env)
    request = Rack::Request.new(env)

    if request.path_info == '/time'
      handle_time_request(request)
    else
      [404, { 'Content-Type' => 'text/plain' }, ['Not Found']]
    end
  end
  private
  def handle_time_request(request)
    format_param = request.params['format']
    return respond_with_missing_format_error unless format_param

    formats = format_param.split(',')
    unknown_formats = formats - VALID_FORMATS
    return respond_with_error(unknown_formats) if unknown_formats.any?

    respond_with_formatted_time(formats)
  end

  def respond_with_missing_format_error
    [400, { 'Content-Type' => 'text/plain' }, ['Format parameter is required']]
  end

  def respond_with_error(unknown_formats)
    [400, { 'Content-Type' => 'text/plain' }, ["Unknown time format [#{unknown_formats.join(', ')}]"]]
  end

  def respond_with_formatted_time(formats)
    formatted_time = formats.map { |format| format_time(format) }.join('-')
    [200, { 'Content-Type' => 'text/plain' }, [formatted_time]]
  end

    # if unknown_formats.any?
    #     [400, { 'Content-Type' => 'text/plain' }, ["Unknown time format [#{unknown_formats.join(', ')}]"]]
    #   else
    #     formatted_time = formats.map { |format| format_time(format) }.join('-')
    #     [200, { 'Content-Type' => 'text/plain' }, [formatted_time]]
    #   end
    # else
    #   [400, { 'Content-Type' => 'text/plain' }, ['Format parameter is required']]
    # end
  # end

  def format_time(format)
    current_time = Time.now
    case format
    when 'year'
      current_time.year.to_s
    when 'month'
      current_time.month.to_s.rjust(2, '0') # rjust добавляет ведущий ноль для месяцев с одной цифрой
    when 'day'
      current_time.day.to_s.rjust(2, '0')   # rjust добавляет ведущий ноль для дней с одной цифрой
    when 'hour'
      current_time.hour.to_s.rjust(2, '0')
    when 'minute'
      current_time.min.to_s.rjust(2, '0')
    when 'second'
      current_time.sec.to_s.rjust(2, '0')
    end
  end

end
