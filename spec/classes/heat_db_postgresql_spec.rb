require 'spec_helper'

describe 'heat::db::postgresql' do
  shared_examples_for 'heat::db::postgresql' do
    let :req_params do
      { :password => 'pw' }
    end

    let :pre_condition do
      "include ::postgresql::server
       class { '::heat::keystone::authtoken':
         password => 'password',
       }
       include ::heat"
    end

    context 'with only required parameters' do
      let :params do
        req_params
      end

      it { is_expected.to contain_postgresql__server__db('heat').with(
        :user     => 'heat',
        :password => 'md5fd5c4fca491370aab732f903e2fb7c99'
      )}
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_behaves_like 'heat::db::postgresql'
    end
  end

end
