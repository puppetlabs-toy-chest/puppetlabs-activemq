require 'spec_helper'

describe 'activemq' do
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
