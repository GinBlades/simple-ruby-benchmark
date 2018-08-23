require "json"
require "sequel"
require "sinatra"

DB = Sequel.connect("sqlite://sample.db")

DB.drop_table?(:items)

DB.create_table :items do
  primary_key :id
  String :name
  Float :price
  String :description
end

items_table = DB[:items]

100.times do |i|
  items_table.insert(
    name: "Item #{i}",
    price: i,
    description: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
  )
end

get "/" do
  items = items_table.where { price > 50 }
  slim :home, locals: { items: items }
end

post "/" do
  request.body.rewind
  item = JSON.parse(request.body.read)
  id = items_table.insert(item)
  items = items_table.where(id: id)
  puts items.inspect
  slim :home, locals: { items: items }
end
