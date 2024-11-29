#
# Copyright:: 2015, Hardening Framework Team
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe 'postgres-hardening::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postgresql']['version'] = '9.3'
    end.converge(described_recipe)
  end

  before do
    @postgres_version = '9.3'
    stub_command("ls /var/lib/postgresql/#{@postgres_version}/main/recovery.conf").and_return(true)
    stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.crt |grep /etc/ssl/certs/ssl-cert-snakeoil.pem").and_return(true)
    stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.key |grep /etc/ssl/private/ssl-cert-snakeoil.key").and_return(true)
  end

  it 'includes postgres-hardening::hardening recipe' do
    expect(chef_run).to include_recipe('postgres-hardening::hardening')
  end
end
