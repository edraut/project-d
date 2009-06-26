class AddPayPalInfo < ActiveRecord::Migration
  def self.up
    add_column :orders, :paypal_transactionid, :string
    add_column :orders, :paypal_paymentstatus, :string
  end

  def self.down
    remove_column :orders, :paypal_paymentstatus
    remove_column :orders, :paypal_transactionid
  end
end
