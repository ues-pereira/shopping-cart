set :environment, "development"

every 1.hour do
  rake 'carts:abandoned'
end

every 1.day do
  rake 'carts:abandoned:remove'
end
