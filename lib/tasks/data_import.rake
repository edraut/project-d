require 'hpricot'
namespace :db do
  task :import_mountain => :environment do
    # for filename in ['Body_-_Body_Parts_-_Machine_Specific.html','Engine_-_Clutch.html','Engine_-_Clutch_Covers.html','Engine_-_Cooling_System_Parts.html','Engine_-_Crankshaft.html','Engine_-_Engine.html','Engine_-_Filler_Caps_&_Drain_Plugs.html','Engine_-_Flywheels.html','Engine_-_Gaskets.html','Engine_-_Ignition_Covers.html','Engine_-_Oil_Filters.html','Engine_-_Piston.html','Engine_-_Spark_Plugs.html','Engine_-_Valves.html','Engine_-_Water_Pump_Covers.html','Exhaust_-_Exhaust_Accessories.html','Exhaust_-_Exhaust_Collars-Banshee.html','Exhaust_-_Exhaust_Springs_&_O-Rings.html','Exhaust_-_Exhaust-4-Stroke.html','Exhaust_-_Street_Exhaust.html','Exhaust_-_Exhaust-2-Stroke_Pipes.html','Exhaust_-_Exhaust-2-Stroke_Silencers.html','ATV_Parts_-_A-Arms.html','ATV_Parts_-_Axle.html','ATV_Parts_-_Bumpers.html','ATV_Parts_-_Covers.html','ATV_Parts_-_Engine_Skid_Plates.html','ATV_Parts_-_Flags_and_Flag_Holders.html','ATV_Parts_-_Foot_Pegs_Heel_Guards.html','ATV_Parts_-_Nerf_Bars.html','ATV_Parts_-_Rack_Accessories.html','ATV_Parts_-_Racks.html','ATV_Parts_-_Gas_Caps.html','ATV_Parts_-_Grab_Bars.html','ATV_Parts_-_Hitches.html','ATV_Parts_-_Hitches_(Receiver).html','Engine_-_Camshafts.html','Street_Bike_Accessories_-_Boots_(Street).html','Street_Bike_Accessories_-_Eye_Wear.html','Street_Bike_Accessories_-_Face_Mask.html','Street_Bike_Accessories_-_Fuel_Intake.html','Street_Bike_Accessories_-_Gloves_(Street).html','Street_Bike_Accessories_-_Head_Wraps.html','Street_Bike_Accessories_-_Helmets_(Street).html','Street_Bike_Accessories_-_Jacket_(Street).html','Street_Bike_Accessories_-_Maps.html','Street_Bike_Accessories_-_Pants_(Street).html','Street_Bike_Accessories_-_Street_Exhaust.html','Street_Bike_Accessories_-_Tires-Street_Motorcycle.html','Street_Bike_Accessories_-_Vest_(Street).html','Drive_-_Chains.html','Tires_and_Wheels_-_ATV_Tire_Chains.html','Tires_and_Wheels_-_Tire_Accessories.html','Tires_and_Wheels_-_Tires-Dirt_Bike.html','Tires_and_Wheels_-_Tires-Dual_Sport_Motorcycle.html','Tires_and_Wheels_-_Tires-Street_Motorcycle.html','Tires_and_Wheels_-_Track_Systems.html','Tires_and_Wheels_-_Tubes.html','Tires_and_Wheels_-_Wheels-Dirt_Bike.html']
       for filename in ['ATV_Parts_-_A-Arms.html']
      File.open(File.join(RAILS_ROOT,'doc','mountain_data','files',filename)) do |file|
        top_category_name, category_name = filename.match(/(.*)_-_(.*).html/).captures
        top_category_name.gsub!(/_/,' ')
        category_name.gsub!(/_/,' ')
        top_category = Category.find_by_sql(["select * from categories where parent_id is null and lower(name) = lower(?)",top_category_name]).first
        top_category ||= Category.create(:name => top_category_name)
        category = Category.find_by_sql(["select * from categories where parent_id = :parent_id and lower(name) = lower(:name)",{:parent_id => top_category.id, :name => category_name}]).first
        category ||= Category.create(:parent_id => top_category.id, :name => category_name)
        puts top_category.name
        puts category.name
        if top_category.name.match(/atv|ATV|Atv/) or category.name.match(/atv|ATV|Atv/)
          vehicle_type_id = 2
        elsif top_category.name.match(/dirt|DIRT|Dirt/) or category.name.match(/dirt|DIRT|Dirt/)
          vehicle_type_id = 1
        elsif top_category.name.match(/street|STREET|Street/) or category.name.match(/street|STREET|Street/)
          vehicle_type_id = 3
        else
          vehicle_type_id = 2
        end
        products = {}
        doc = Hpricot(file.read, 'ForceArray' => false)
        (doc/"table/tr").each do |row|
          cells = row.search("td")
          if cells.any?
            name = cells[1].inner_html
            number = cells[0].inner_html
            vehicle_info = cells[2].inner_html
            # puts "NAME: #{name}"
            # puts "NUM: #{number}"
            # puts "VEH: #{vehicle_info}"
            if vehicle_info.blank?
              make = model = begin_year = end_year = nil
            else
              vehicle_info.gsub!(/\xAE/,'')
              vehicle_info.gsub!(/\xA0/,' ')
              if vehicle_info.match(/&ndash;/)
                if vehicle_info.match(/ARCTIC CAT/)
                  make, model, begin_year, end_year = vehicle_info.match(/(ARCTIC CAT) (.*) (\d\d\d\d)&ndash;(\d\d\d\d)$/).captures
                else
                  make, model, begin_year, end_year = vehicle_info.match(/([^ ]*) (.*) (\d\d\d\d)&ndash;(\d\d\d\d)$/).captures
                end
              else
                if vehicle_info.match(/ARCTIC CAT/)
                  make, model, begin_year = vehicle_info.match(/(ARCTIC CAT) (.*) (\d\d\d\d)/).captures
                else
                  make, model, begin_year = vehicle_info.match(/([^ ]*) (.*) (\d\d\d\d)/).captures
                end
                end_year = nil
              end
            end
            # puts "MAKE: #{make}" if make
            # puts "MODEL: #{model}" if model
            # puts "BEG: #{begin_year}" if begin_year
            # puts "END: #{end_year}" if end_year
            picture_url = cells[4].search('img').first['src']
            # puts "PICT: #{picture_url}"
            products[name] ||= {}
            products[name][:picture_url] = picture_url
            products[name][:options] ||= {}
            products[name][:options][number] ||= {}
            if make
              products[name][:options][number][make] ||= {}
              if model
                products[name][:options][number][make][model] = {:begin_year => begin_year, :end_year => end_year}
              end
            end
          end
        end
        for name, product_hash in products
          product = Product.find_by_sql(["select * from products where lower(name) = lower(?)",name]).first
          product ||= Product.create(:name => name, :category_id => category.id, :ground_price => Money.new(0), :second_day_price => Money.new(0), :overnight_price => Money.new(0), :international_price => Money.new(0))
          product_image = product.product_images.first
          product_image ||= ProductImage.create(:image_url => product_hash[:picture_url], :product_id => product.id)
          puts "PROD NAME: #{name}"
          # puts name
          # puts "\tpict url:#{product_hash[:picture_url]}"
          # puts "\toption:"
          for number, vehicle_hash in product_hash[:options]
            product_option = ProductOption.find_by_sql(["select * from product_options where product_id = :product_id and sku = :sku",{:product_id => product.id, :sku => number}]).first
            product_option ||= ProductOption.create(:product_id => product.id,:sku => number,:price => Money.new(0))
            # puts "\t\t#{number}"
            # product.publish unless product.state == :published
            for make_name, model_hash in vehicle_hash
              make = VehicleMake.find_by_sql(["select * from vehicle_makes where lower(name) = lower(?)",make_name]).first
              make ||= VehicleMake.create(:name => make_name)
              povma = ProductOptionVehicleMake.find_by_sql(["select * from product_option_vehicle_makes where vehicle_make_id = :vehicle_make_id and product_option_id = :product_option_id",{:vehicle_make_id => make.id, :product_option_id => product_option.id}]).first
              povma ||= ProductOptionVehicleMake.create(:vehicle_make_id => make.id, :product_option_id => product_option.id)
              # puts "\t\t\t#{make}"
              for model_name, year_hash in model_hash
                model = VehicleModel.find_by_sql(["select * from vehicle_models where vehicle_make_id = :vehicle_make_id and name = :name",{:vehicle_make_id => make.id,:name => model_name}]).first
                if model and vehicle_type_id != 2 and model.vehicle_type_id != 2
                  model.vehicle_type_id = 2
                  model.save
                end
                model ||= VehicleModel.create(:name => model_name, :vehicle_make_id => make.id, :vehicle_type_id => vehicle_type_id)
                povm = ProductOptionVehicleModel.create(:vehicle_model_id => model.id, :product_option_id => product_option.id, :year_begin => year_hash[:begin_year], :year_end => year_hash[:end_year])
                # puts "\t\t\t\t#{model} #{year_hash[:begin_year]} -> #{year_hash[:end_year]}"
              end
            end
          end
        end
      end
    end
  end
end
