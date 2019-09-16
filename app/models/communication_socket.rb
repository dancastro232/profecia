require "timeout"

class CommunicationSocket
  RETRIES = 5

  def initialize(**options)
    version = options[:version]
    version = 1 #Version 2

    @retries = options.fetch(:retries, RETRIES)
    @session = Session.new(options)
    return unless block_given?
    begin
      yield self
    ensure
      close
    end
  end

  def close
    @session.close
  end

  def get(*oid_opts)
    request = @session.build_pdu(:get, *oid_opts)
    response = handle_retries { @session.send(request) }
    yield response if block_given?
    values = response.varbinds.map(&:value)
    values.size > 1 ? values : values.first
    response
  end

  def get_next(*oid_opts)
    request = @session.build_pdu(:getnext, *oid_opts)
    response = handle_retries { @session.send(request) }
    yield response if block_given?
    values = response.varbinds.map { |v| [v.oid, v.value] }
    values.size > 1 ? values : values.first
  end

  def walk(oid:)
    walkoid = oid
    Enumerator.new do |y|
      code = walkoid
      first_response_code = nil
      catch(:walk) do
        loop do
          get_next(oid: code) do |response|
            response.varbinds.each do |varbind|
              code = varbind.oid
              if !OID.parent?(walkoid, code) ||
                  varbind.value.eql?(:endofmibview) ||
                  (code == first_response_code)
                throw(:walk)
              else
                y << [code, varbind.value]
              end
              first_response_code ||= code
            end
          end
        end
      end
    end
  end

  def set(*oid_opts)
    request = @session.build_pdu(:set, *oid_opts)
    response = handle_retries { @session.send(request) }
    yield response if block_given?
    values = response.varbinds.map(&:value)
    values.size > 1 ? values : values.first
  end

  def inform(*oid_opts)
    request = @session.build_pdu(:inform, *oid_opts)
    response = handle_retries { @session.send(request) }
    yield response if block_given?
    values = response.varbinds.map(&:value)
    values.size > 1 ? values : values.first
  end

  private

  def handle_retries
    retries = @retries
    begin
      yield
    rescue Timeout::Error => e
      raise e if retries.zero?
      retries -= 1
      retry
    end
  end
end