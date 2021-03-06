#
# Copyright:: 2020, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe RuboCop::Cop::Chef::ChefModernize::WindowsRegistryUAC, :config do
  subject(:cop) { described_class.new(config) }

  it 'registers an offense when a sets UAC config via registry_key' do
    expect_offense(<<~RUBY)
      registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Chef Infra Client 15.0 and later includes a windows_uac resource that should be used to set Windows UAC values instead of setting registry keys directly.
        values [{ name: 'EnableLUA', type: :dword, data: 0 }]
        action :create
      end
    RUBY
  end

  it 'registers an offense when a sets UAC config via registry_key using the key property' do
    expect_offense(<<~RUBY)
      registry_key 'Set UAC values' do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Chef Infra Client 15.0 and later includes a windows_uac resource that should be used to set Windows UAC values instead of setting registry keys directly.
        key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System'
        values [{ name: 'EnableLUA', type: :dword, data: 0 }]
        action :create
      end
    RUBY
  end

  it 'registers an offense when a sets UAC config via registry_key using a lowercase key' do
    expect_offense(<<~RUBY)
      registry_key 'hkey_local_machine\\software\\microsoft\\windows\\currentversion\\policies\\system' do
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Chef Infra Client 15.0 and later includes a windows_uac resource that should be used to set Windows UAC values instead of setting registry keys directly.
        values [{ name: 'EnableLUA', type: :dword, data: 0 }]
        action :create
      end
    RUBY
  end

  context 'with TargetChefVersion set to 14' do
    let(:config) { target_chef_version(14) }

    it "doesn't register an offense" do
      expect_no_offenses(<<~RUBY)
        registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System' do
          values [{ name: 'EnableLUA', type: :dword, data: 0 }]
          action :create
        end
      RUBY
    end
  end
end
