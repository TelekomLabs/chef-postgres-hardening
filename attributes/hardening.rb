#
# Cookbook:: postgres-hardening
# Attributes:: default
#
# Copyright:: 2014, Christoph Hartmann
# Copyright:: 2014, Deutsche Telekom AG
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

# security options

default['postgresql']['config']['logging_collector'] = true

default['postgresql']['config']['log_duration'] = true

default['postgresql']['config']['log_disconnections'] = true

default['postgresql']['config']['log_connections'] = true

default['postgresql']['config']['log_hostname'] = true

default['postgresql']['config']['log_line_prefix'] = '%t %u %d %h'

default['postgresql']['config']['log_directory'] = 'pg_log'

default['postgresql']['config']['password_encryption'] = true

default['postgresql']['config']['ssl'] = false

default['postgresql']['config']['ssl_ciphers'] = 'ALL:!ADH:!LOW:!EXP:!MD5:@STRENGTH'

default['postgresql']['pg_hba'] = [

  # violating req to be able to set password
  { type: 'local', db: 'all', user: 'postgres', addr: nil, method: 'ident' },
  # all others are md5 now
  { type: 'local', db: 'all', user: 'all', addr: nil, method: 'md5' },
  { type: 'host', db: 'all', user: 'all', addr: '127.0.0.1/32', method: 'md5' },
  { type: 'host', db: 'all', user: 'all', addr: '::1/128', method: 'md5' },
]
