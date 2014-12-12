# encoding: utf-8

require 'spec_helper'

describe 'postgres-hardening::hardening' do

  context 'with platform_family debian' do

    platforms = [
      { os_name: 'ubuntu', os_version: '12.04', postgres_version: '9.1' },
      { os_name: 'ubuntu', os_version: '14.04', postgres_version: '9.3' },
      { os_name: 'debian', os_version: '6.0.5', postgres_version: '8.4' },
      { os_name: 'debian', os_version: '7.5', postgres_version: '9.1' }
    ]

    platforms.each do |platform|

      context "operating system #{platform[:os_name]} #{platform[:os_version]}" do

        let(:chef_run) do
          ChefSpec::ServerRunner.new(
            platform: platform[:os_name], version: platform[:os_version]
          ).converge('postgresql::server', 'postgres-hardening::hardening')
        end

        before do
          @postgres_version = platform[:postgres_version]
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