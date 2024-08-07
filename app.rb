# frozen_string_literal: true

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
    format_params = request.params['format']

    if format_params.nil? || format_params.empty?
      return build_response(400, 'Format parameter is required')
    end

    tf = TimeFormatter.new(format_params)
    tf.call

    if tf.valid?
      build_response(200, tf.time_string)
    else
      build_response(400, "Unknown time format [#{tf.wrong_formats.join(', ')}]")
    end
  end

  def build_response(status, body)
    response = Rack::Response.new
    response.status = status
    response['Content-Type'] = 'text/plain'
    response.write(body)
    response.finish
  end
end
