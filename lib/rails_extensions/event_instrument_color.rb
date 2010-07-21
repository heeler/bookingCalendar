module RailsExtensions
  
  module  EventInstrumentColor
  
    #Instance Method to override color
    def color
      n_of_i = Instrument.n_of_instruments + 2
      x = instrument.id + 1
      h = x.to_f / n_of_i.to_f
      Colors.hsv_to_hex(h, 0.8, 0.6)
    end
    
    def name
      "#{project}/#{instrument.name}"
    end
  
  end
  
  module Colors

    def self.hsv_to_rgb(h, s, v)
      # h = [0,1)  s = [0,1]  v = [0,1]
      c, ht = v*s, 6*h
      x = c*(1.0 - ((ht%2)-1).abs )
      m = v - c
      
      ro,go,bo = case 
      when 0 <= ht && ht < 1.0 then [c,x,0]
      when 1 <= ht && ht < 2 then [x,c,0]
      when 2 <= ht && ht < 3 then [0,c,x]
      when 3 <= ht && ht < 4 then [0,x,c]
      when 4 <= ht && ht < 5 then [x,0,c]
      when 5 <= ht && ht < 6 then [c,0,x]
      else [0,0,0]
      end

      [ro+m, go+m, bo+m].inject([]) {|res,a| (a > 1) ? res << 1.0 : res << a}
    end

    def self.hsv_to_hex(h,s,v)
      rgb = self.hsv_to_rgb(h,s,v)
        
      ms = rgb.inject("\#") do |str, x|
        y=(x*255).to_i.to_s(16)
        y = "0" + y if y.length == 1 
        y = "00" if y.length == 0
        str + y  
      end
      ms
    end

  end

end