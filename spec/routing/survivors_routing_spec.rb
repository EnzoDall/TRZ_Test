# spec/routing/survivors_routing_spec.rb

require 'rails_helper'

RSpec.describe 'Survivors', type: :routing do
  it 'routes to #index' do
    expect(get: '/survivors').to route_to(controller: 'survivors', action: 'index')
  end

  it 'routes to #create' do
    expect(post: '/survivors').to route_to('survivors#create')
  end

  it 'routes to #update' do
    expect(put: '/survivors/1').to route_to('survivors#update', id: '1')
  end
end
