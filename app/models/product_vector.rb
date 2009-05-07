class ProductVector < ActiveRecord::Base
  belongs_to :product
  after_destroy :update_tsearch_vector
  
  self.acts_as_tsearch :vectors => {
    :fields => {
      'a' => {:columns => ['products.name'], :weight => 1}
    },
    :tables => {
      :products => {
        :from => 'product_vectors pv1 inner join products on pv1.product_id = products.id',
        :where => 'pv1.id = product_vectors.id'
      }
    }
  }

  def update_tsearch_vector
    self.class.update_vectors
  end
  
end
