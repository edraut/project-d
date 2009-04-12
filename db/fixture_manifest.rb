class FixtureManifest
  def self.template
    @@fixtures ||= {
      :users => 1,
      :vehicle_types => 1,
      :vehicle_makes => 1,
      :vehicle_models => 1,
      :categories => 1,
      :products => {
        :product_options => {
          :product_option_vehicle_makes => 1,
          :product_option_vehicle_models => 1
        },
        :product_images => 1
      }
    }
  end
  
  def self.list
    self.extract_keys_recursively self.template
  end
  
  def self.extract_keys_recursively(hash)
    ret = hash.keys
    for key,val in hash
      unless val == 1
        ret = ret + self.extract_keys_recursively(val)
      end
    end
    ret
  end
end