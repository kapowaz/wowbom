module Wowbom
  
  def item(item_id)
    # TODO: fetch a given item using Wowget::Item; if it exists, update its record otherwise save it
    item = Wowget::Item.new(item_id)
    existing_items = Item.all :item_id => item_id
  end

end