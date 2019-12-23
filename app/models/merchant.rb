class Merchant <ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def orders_info
    #each order
    #date
    #total quantity of items
    #total value


    # can I query where on multiple params?
    # ItemOrder.select('order_id, orders.created_at, SUM(item_orders.quantity) AS total_quantity, SUM(item_orders.price) AS total_price').joins(:orders).where("item_orders.id = #{ids}").group('item_orders.order_id')


    item_orders.select('order_id, SUM(item_orders.quantity) AS quantity, SUM(item_orders.price) AS price').group(:order_id)


    # SELECT orders.created_at, SUM(item_orders.quantity) AS total_quantity, SUM(item_orders.price) AS total_price FROM item_orders JOIN orders ON item_orders.order_id = orders.id GROUP BY orders.id;
  end

  def order_price(order_id)
    orders = item_orders.where(order_id: order_id)
      orders.sum do |order|
        order.subtotal
      end
  end

end
