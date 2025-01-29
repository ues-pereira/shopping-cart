set :environment, "development"

every 3.hours do
  rake 'carts:abandoned'
end

every 7.days do
  rake 'carts:abandoned:remove'
end
