require 'spec_helper'

describe 'activemq' do
  it "should compile" do
    should contain_class('activemq')
  end
end
