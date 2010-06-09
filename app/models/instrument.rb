class Instrument < ActiveRecord::Base
  has_many :messages
  has_many :events
  has_many :users, :through => :events
  
  def quota(multiplier)
    ans = multiplier * self.quota_hours
    puts "Quota: #{ans} hours"
    ans
  end
  
  def orbitrap
    return (self.model =~ /Orbitrap/i) 
  end
  
  def sname 
    insts = Instrument.find(:all)
    insts.sort! {|a,b| a.created_at <=> b.created_at}
    insts.each_with_index do |inst,i|
      return "ms-#{i+1}" if self.id == inst.id
    end
    return "ms-0"
  end
  
end