module InstrumentsHelper
  
  def img_name(inst)
    (inst.working) ? "green.png" : "red.png"
  end
end
