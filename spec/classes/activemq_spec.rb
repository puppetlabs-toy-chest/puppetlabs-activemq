require 'spec_helper'

describe 'activemq' do
  let(:params) do
    {
        'mq_admin_username' => 'admin',
        'mq_admin_password' => 'admin',
    }
  end

  it "should compile" do
    should contain_class('activemq')
  end

  # calling the file activemq.xml will be fragile if this module ever supports
  # debian-style multi-instance configurations
  it { should contain_file('activemq.xml') }


  describe "#webconsole" do
    context "with the default template" do
      describe "true" do
        let(:params) { {'webconsole' => true} }
        it { should contain_file('activemq.xml').with_content(/jetty.xml/) }
        it {
          pending "templates/default/jetty.xml is a tease - we don't actually push it out in any case"
          should contain_file('jetty.xml')
        }
      end

      describe "false" do
        let(:params) { {'webconsole' => false} }
        it { should_not contain_file('activemq.xml').with_content(/jetty.xml/) }
        it { should_not contain_file('jetty.xml') }
      end
    end
  end


  describe '#packages'do

    context "#install_from_source = false (default)" do
      it { should contain_package('activemq') }

      context "/etc/init.d/activemq" do
        it { should_not contain_file('/etc/init.d/activemq') }

        context "RedHat" do
          let(:facts) { {:osfamily => 'RedHat'} }
          it { should contain_file('/etc/init.d/activemq') }
        end

        context 'RedHat version <= 5.9' do
          let(:facts) { {:osfamily => 'RedHat'} }
          let(:params) { {:version => '5.8.5'} }
          it { should contain_file('/etc/init.d/activemq') }
        end

        context 'RedHat version >= 5.9' do
          let(:facts) { {:osfamily => 'RedHat'} }
          let(:params) { {:version => '5.9'} }
          it { should_not contain_file('/etc/init.d/activemq') }
        end
      end
    end


    context "#install_from_source = true" do
      let(:params) do
        {
            :install_from_source => true,
            :package => 'http://download.nextag.com/apache/activemq/' \
                '5.11.1/apache-activemq-5.11.1-bin.tar.gz',
            :user => 'activemq1',
            :group => 'activemq2',
            :home => '/tmp/activemq'
        }
      end

      it { should_not contain_package('activemq') }
      it { should contain_file('/etc/init.d/activemq') }
      it { should contain_user(params[:user]).with_system(true) }
      it { should contain_group(params[:group]).with_system(true) }
      it { should contain_file(params[:home]).with_ensure('directory').with_owner(params[:user]) }
      it { should contain_staging__file('apache-activemq-5.11.1-bin.tar.gz').with_source(params[:package]) }
      it { should contain_staging__extract('apache-activemq-5.11.1-bin.tar.gz').with_target(params[:home])}

    end

  end


  describe '#config' do
    context "#install_from_source = false (default)" do

    end

    context "#install_from_source = true" do
      let(:params) do
        {
            :install_from_source => true,
            :package => 'http://download.nextag.com/apache/activemq/' \
                '5.11.1/apache-activemq-5.11.1-bin.tar.gz',
            :home => '/var/tmp/activemq'
        }
      end

      it { should contain_file('activemq.xml').with_path("#{params[:home]}/conf/activemq.xml") }
    end
  end


  describe "#instance" do
    context "Debian" do
      let(:facts) { {:osfamily => 'Debian'} }
      context "default" do
        it { should contain_file('activemq.xml').with_path('/etc/activemq/instances-available/activemq/activemq.xml') }
        it { should contain_file('/etc/activemq/instances-enabled/activemq') }
        it { should contain_file('/etc/activemq/instances-enabled/activemq').with_ensure('link') }
        it { should contain_file('/etc/activemq/instances-enabled/activemq').with_target('/etc/activemq/instances-available/activemq') }
      end

      context "pies" do
        let(:params) { {:instance => 'pies'} }
        it { should contain_file('activemq.xml').with_path('/etc/activemq/instances-available/pies/activemq.xml') }
        it { should contain_file('/etc/activemq/instances-enabled/pies') }
        it { should contain_file('/etc/activemq/instances-enabled/pies').with_ensure('link') }
        it { should contain_file('/etc/activemq/instances-enabled/pies').with_target('/etc/activemq/instances-available/pies') }
      end
    end

    context "everywhere else" do
      context "default" do
        it { should contain_file('activemq.xml').with_path('/etc/activemq/activemq.xml') }
      end

      context "pies" do
        let(:params) { {:instance => 'pies'} }
        it { should contain_file('activemq.xml').with_path('/etc/activemq/activemq.xml') }
      end
    end
  end
end
