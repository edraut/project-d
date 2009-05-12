namespace :utils do
  task (:clean_up_old_carts => :environment) do
    Order.carts.find(:all, :conditions => ["created_at < (current_timestamp - interval '1 day')"]).each do |cart|
      cart.destroy
    end
  end
  task (:generate_google_sitemap => :environment) do
    include ActionController::UrlWriter  
    default_url_options[:host] = 'madracingmx.com'  
      
    filename = "#{RAILS_ROOT}/public/sitemap.xml"  
    File.open(filename, "w") do |file|  
      xml = Builder::XmlMarkup.new(:target => file, :indent => 2)  
      xml.instruct!  
      xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do  
        xml.url do
          xml.loc root_url
          xml.lastmod Time.local(Time.now.year,Time.now.month,Time.now.day).xmlschema
          xml.changefreq "weekly"
          xml.priority 0.95
        end
        Product.all.each do |product|
          xml.url do
            xml.loc product_url(product)
            xml.lastmod product.updated_at.xmlschema
            xml.changefreq "monthly"
            xml.priority 0.9
          end
        end
      end  
    end    
  end
end