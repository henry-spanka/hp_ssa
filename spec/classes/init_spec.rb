require 'spec_helper'
describe 'hp_ssa' do
  context 'with default values for all parameters' do
    it { should contain_class('hp_ssa') }
  end
end
