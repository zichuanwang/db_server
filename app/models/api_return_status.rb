# encoding: utf-8
class ApiReturnStatus
  attr_reader :Id, :Memo

  STATUS = {
    "000" => "Succeed",
    "999" => "Unknown Failure"
  }
  
  def initialize(id) 
    @Id = id
    @Memo = STATUS[id]
  end
  
end
