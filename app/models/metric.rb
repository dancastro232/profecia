class Metric < ApplicationRecord
  belongs_to :agent
  has_one :varbind

  def parse_response(response, agent_id)
    #@version      = response.version
    self.community    = response.community
    self.error_status = response.error_status
    self.error_index  = response.error_index
    self.type         = response.type
    self.request_id   = response.request_id
    self.agent_id     = agent_id
    self.varbind_id   = create_varbind(response.varbinds[0].value,
                                   response.varbinds[0].type,
                                   response.varbinds[0].oid
                                   )
  end

  def create_varbind(value, varbind_type, oid)
    mib_id  = find_mib(oid).id
    varbind = Varbind.new(value: value, varbind_type: varbind_type, mib_id: mib_id)
    varbind.save
    varbind.id
  end


  def find_mib(oid)
    Mib.where(oid: oid).first
  end

end
