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

describe 'postgres-hardening::hardening' do
  context 'with platform_family debian' do
    platforms = [
      { os_name: 'ubuntu', os_version: '12.04', postgres_version: '9.3' },
      { os_name: 'ubuntu', os_version: '14.04', postgres_version: '9.3' },
      { os_name: 'debian', os_version: '6.0.5', postgres_version: '9.3' },
      { os_name: 'debian', os_version: '7.5', postgres_version: '9.3' },
    ]

    platforms.each do |platform|
      context "operating system #{platform[:os_name]} #{platform[:os_version]}" do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform[:os_name], version: platform[:os_version]
          ) do |node|
            node.set['postgresql']['version'] = '9.3'
          end.converge('postgresql::server', 'postgres-hardening::hardening')
        end

        before do
          @postgres_version = platform[:postgres_version]
          stub_command("ls /var/lib/postgresql/#{@postgres_version}/main/recovery.conf").and_return(true)
        end

        it 'creates necessary directories with correct mode' do
          stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.crt |grep /etc/ssl/certs/ssl-cert-snakeoil.pem").and_return(true)
          stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.key |grep /etc/ssl/private/ssl-cert-snakeoil.key").and_return(true)

          expect(chef_run).to create_directory('/var/lib/postgresql/')
            .with(mode: '0700')

          expect(chef_run).to create_directory("/var/lib/postgresql/#{@postgres_version}")
            .with(mode: '0700')
        end

        it 'deletes links if commands return true' do
          stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.crt |grep /etc/ssl/certs/ssl-cert-snakeoil.pem").and_return(true)
          stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.key |grep /etc/ssl/private/ssl-cert-snakeoil.key").and_return(true)

          expect(chef_run).to delete_link("/var/lib/postgresql/#{@postgres_version}/main/server.crt")
          expect(chef_run).to delete_link("/var/lib/postgresql/#{@postgres_version}/main/server.key")
        end

        it 'does not delete links if commands return false' do
          stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.crt |grep /etc/ssl/certs/ssl-cert-snakeoil.pem").and_return(false)
          stub_command("ls -l /var/lib/postgresql/#{@postgres_version}/main/server.key |grep /etc/ssl/private/ssl-cert-snakeoil.key").and_return(false)

          expect(chef_run).to_not delete_link("/var/lib/postgresql/#{@postgres_version}/main/server.crt")
          expect(chef_run).to_not delete_link("/var/lib/postgresql/#{@postgres_version}/main/server.key")
        end
      end
    end
  end
end
