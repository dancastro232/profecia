class Agent < ApplicationRecord
  has_many :metrics


  def show_metric
    agent = find_agent
    connection = start_connection(agent)
    metric = get_metric(connection, '1.3.6.1.2.1.1.1.0', agent.id)
  end


  def find_agent(ip = nil)
    if ip != nil
      Agent.where(ip_address: ip)
    else
      Agent.first
    end
  end

  def start_connection(agent)
    CommunicationSocket.new(host: agent.ip_address, port: agent.port, version: agent.version)
  end

  def get_metric(connection, oid, id_agent)
    connection.get(oid: oid)
    metric = Metric.new
    metric.parse_response(connection.get(oid: oid),id_agent)
    byebug
    metric.save
    connection.close
    metric
  end
end
