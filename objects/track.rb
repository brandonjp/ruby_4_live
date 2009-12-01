class Track < LiveObject
  
  attr_accessor :order
  
  OBJECT_ATTRIBUTES['track']['properties'].each do |method|
    attr_accessor method
  end
  
  OBJECT_ATTRIBUTES['track']['functions'].each do |method|
    define_method method do
      set_path
      @@connection.live_call(method)
    end
  end
  
  def self.all
    @@objects.select { |o| o.kind_of? Track }
  end
  
  def clip_slots
    @@objects.select { |o| o.kind_of? ClipSlot and o.track_id == id}#.sort_by {|c| c['order'] }
  end
  
  def clip_slot_count
    set_path
    @@connection.live_object("get clip_slots")[0][1][2]
  end
  
  def get_clip_slots
    10.times do |i|
      clip_slot_id = @@connection.live_path("goto live_set tracks #{order} clip_slots #{i}")[0][1][1]
      clip_slot = ClipSlot.new({:id => clip_slot_id, :order => i, :track_id => id})
      LiveSet.add_object(clip_slot)
      if clip_slot.has_clip == 1
        clip_slot.clip
      end
    end
  end
  
  def get_devices
    10.times do |i|
      device_id = @@connection.live_path("goto live_set tracks #{order} devices #{i}")[0][1][1]
      break if device_id == 0
      device = Device.new({:id => device_id, :order => i, :track_id => id})
      LiveSet.add_object(device)
    end
  end
  
end