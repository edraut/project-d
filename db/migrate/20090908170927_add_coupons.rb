class AddCoupons < ActiveRecord::Migration
  def self.up
    create_table :coupons, :force => true do |t|
      t.integer   :flat_amount
      t.integer   :percent_off
      t.boolean   :single_use
      t.boolean   :active
      t.string    :coupon_code
      t.timestamps
    end
    add_column :orders, :coupon_id, :string
  end

  def self.down
    remove_column :orders, :coupon_id
    drop_table :coupons
  end
end
