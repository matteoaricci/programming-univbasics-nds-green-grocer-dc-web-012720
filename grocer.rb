def find_item_by_name_in_collection(name, collection)
  i = 0
  while i < collection.length do
    if name == collection[i][:item]
      return collection[i]
    end
    i += 1
  end 
end

def consolidate_cart(cart)
    arr = []

    i = 0
    while i < cart.length do
      item = cart[i]
      found_item = find_item_by_name_in_collection(item[:item], arr)
      
      if found_item
        found_item[:count] += 1
      else
        item[:count] = 1
        arr << item
      end
      i += 1
    end
    arr
  end

def apply_coupons(cart, coupons)
    i = 0
    while i < coupons.length
        cart_item = find_item_by_name_in_collection(coupons[i][:item], cart)
        couponed_item_name = "#{coupons[i][:item]} W/COUPON"
        cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, cart)
        if cart_item && cart_item[:count] >= coupons[i][:num]
            if cart_item_with_coupon
                cart_item_with_coupon[:count] += coupons[i][:num]
                cart_item[:count] -= coupons[i][:num]
            else
                cart_item_with_coupon = {
                    :item => couponed_item_name,
                    :price => coupons[i][:cost] / coupons[i][:num],
                    :count => coupons[i][:num],
                    :clearance => cart_item[:clearance]
                }
                cart << cart_item_with_coupon
                cart_item[:count] -= coupons[i][:num]
            end
        end
        i += 1
    end
     cart
end

def apply_clearance(cart)
  new_cart = cart[0..-1]
  i = 0
  while i < cart.length
    if cart[i][:clearance]
      new_cart[i][:price] = (new_cart[i][:price] * 0.8).round(2)
    end
    i += 1
  end
  new_cart
end

def checkout(cart, coupons)
  
  cons_cart = consolidate_cart(cart)
  coup_cart = apply_coupons(cons_cart, coupons)
  clear_cart = apply_clearance(coup_cart)
  
  total = 0 
  i = 0 
  
    while i < clear_cart.length
      total += clear_cart[i][:price] * clear_cart[i][:count]
      i += 1 
    end
    
  if total > 100
    total = total * 0.9
  end
  total
end
