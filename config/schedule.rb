set :environment, "development"

every 1.minute do
  rake 'carts:abandoned'
end

every 7.days do
  rake 'carts:abandoned:remove'
end
