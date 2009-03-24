class FixtureManifest
  def self.template
    @@fixtures ||= {
      :users => 1
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