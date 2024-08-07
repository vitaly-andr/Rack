require 'rack'
require './time_formatter'
class TimeApp
  VALID_FORMATS = %w[year month day hour minute second].freeze
  def call(env)
    request = Rack::Request.new(env)

    if request.path_info == '/time'
      handle_time_request(request)
    else
      build_response(404, 'Not Found')
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
    build_response(400, 'Format parameter is required')
  end

  def respond_with_error(unknown_formats)
    build_response(400, "Unknown time format [#{unknown_formats.join(', ')}]")
  end

  def respond_with_formatted_time(formats)
    formatted_time = TimeFormatter.format(formats)
    build_response(200, formatted_time)
  end

  def build_response(status, body)
    response = Rack::Response.new
    response.status = status
    response['Content-Type'] = 'text/plain'
    response.write(body)
    response.finish
  end

end
