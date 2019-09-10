#
# Copyright:: 2019, Chef Software, Inc.
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

describe RuboCop::Cop::Chef::ChefModernize::SysctlParamResource, :config do
  subject(:cop) { described_class.new(config) }

  it 'registers an offense when using the sysctl_param resource' do
    expect_offense(<<~RUBY)
    sysctl_param 'fs.aio-max-nr' do
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ The sysctl_param resource was renamed to sysctl when it was added to Chef Infra Client 14.0. The new resource name should be used.
      value '1048576'
    end
    RUBY
  end

  it "doesn't register an offense when using the sysctl resource" do
    expect_no_offenses(<<~RUBY)
    sysctl 'fs.aio-max-nr' do
      value '1048576'
    end
    RUBY
  end
end