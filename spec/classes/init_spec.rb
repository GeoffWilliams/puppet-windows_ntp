require 'spec_helper'
describe 'windows_ntp' do
  context 'with default values for all parameters' do
    it { should contain_class('windows_ntp') }
  end
end
