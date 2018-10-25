# Language: Ruby, Level: Level 3
require 'pry'

# def count_uniq_items(items_arr)
#   unique_cart_items = Hash.new(0)
#   for each_item in items_arr
#     unique_cart_items[each_item]+=1
#   end
#   return unique_cart_items
# end

# def consolidate_cart(cart)
#   cart_hash = Hash.new(0)
#   unique_cart_items = Hash.new(0)
#   cart_items =[]
#   updated_cart=[]
#
#   cart.each do |item|
#     item.each do |item_name, item_detail|
#       cart_items << item_name
#
#     end
#       # if updated_cart.has_key?(item_name)
#       #   item_detail[:count]+=1
#       #   updated_cart[item_name]=item_detail
#       # else
#       #   item_detail[:count]=1
#       #   updated_cart << {item_name => item_detail}
#       # end
#
#   end
#
#   for each_item in cart_items
#     unique_cart_items[each_item]+=1
#   end
#
#   cart_items.uniq.each do |uniq_item|
#     cart.each do |item|
#       item.each do |item_name, item_detail|
#         if uniq_item == item_name
#           item_detail[:count]=unique_cart_items[item_name]
#           updated_cart << {unique_cart_items => item_detail}
#           binding.pry
#         end
#       end
#     end
#   end
#
# end

def consolidate_cart(cart)

  unique_cart_items = Hash.new(0)
  cart_items_all =[]
  updated_cart={}


  cart.each do |item|
    item.each do |item_name, item_detail|
      cart_items_all << item_name
    end
  end


  for each_item in cart_items_all
    unique_cart_items[each_item]+=1
  end

  unique_cart_items.each do |name, qty|
    cart.each do |item|
        if item.has_key?(name)
          item[name][:count]=qty
          updated_cart[name]=item[name]
          break
        end
    end
  end
  return updated_cart
end




def apply_coupons(cart, coupons)
  if coupons.empty?
    return cart
  end

  cart_w_coupons = {}
  cart.each do |item_name, item_detail|
    coupon_found = false
    new_item_detail = item_detail.dup
    extra_item = item_detail.dup
    coupons.each do |coupon|

      if item_name ==coupon[:item] && new_item_detail[:count]>=coupon[:num]
        new_item_detail[:count]=new_item_detail[:count]/coupon[:num]
        new_item_detail[:price]=coupon[:cost]
        cart_w_coupons[(item_name + " W/COUPON")] = new_item_detail
        # binding.pry
        if extra_item[:count]>=coupon[:num] && extra_item[:count]%coupon[:num]>=0
          extra_item[:count]=extra_item[:count]%coupon[:num]
          cart_w_coupons[item_name]=extra_item
          # binding.pry
        end
        coupon_found = true
        break
      end

    end
    if coupon_found == false
      cart_w_coupons[item_name]=item_detail
    end
  end
  cart_w_coupons
end

def apply_clearance(cart)
  clearance_cart = {}
  cart.each do |item_name, item_detail|
    if item_detail[:clearance] == true
      item_detail[:price]=item_detail[:price]-(0.2*item_detail[:price])
      clearance_cart[item_name]=item_detail
    else
      clearance_cart[item_name]=item_detail
    end
  end
  clearance_cart
end

def checkout(cart, coupons)
  total_price = 0
  # if coupons.empty? && cart.length  == 1
  #   return cart[0].first.last[:price]
  # end
  cart_consld = consolidate_cart(cart)
  checkout_coupons_applied = apply_coupons(cart_consld, coupons)
  checkout_clearance_applied =  apply_clearance(checkout_coupons_applied)
  checkout_clearance_applied.each do |item_name, item_detail|
      total_price += item_detail[:price]*item_detail[:count]
    end
    if total_price > 100
      return total_price - (total_price*0.1)
    else
      return total_price
    end
end
