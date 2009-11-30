class ClipSlot < LiveObject
  
  attr_accessor :track_id, :order
  
  def self.all
    @@objects.select { |o| o.kind_of? ClipSlot }
  end
  
  # ToDo: This is not prepared to handle nil
  def clip
    existing = @@objects.select { |o| o.kind_of? Clip and o.clip_slot_id == id}
    if existing.empty? 
      clip_id = @@connection.live_path("goto live_set tracks #{track_id} clip_slots #{order} clip")[0][1][1]
      LiveSet.add_object(Clip.new({:id => clip_id, :clip_slot_id => id}))
      clip
    else
      existing[0]
    end
  end
  
end