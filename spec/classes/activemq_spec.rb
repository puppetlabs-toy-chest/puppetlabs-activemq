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
        let(:params) { { 'webconsole' => true } }
        it { should contain_file('activemq.xml').with_content(/jetty.xml/) }
        it {
          pending "templates/default/jetty.xml is a tease - we don't actually push it out in any case"
          should contain_file('jetty.xml')
        }
      end

      describe "false" do
        let(:params) { { 'webconsole' => false } }
        it { should_not contain_file('activemq.xml').with_content(/jetty.xml/) }
        it { should_not contain_file('jetty.xml') }
      end
    end
  end

  context "/etc/init.d/activemq" do
    it { should_not contain_file('/etc/init.d/activemq') }

    context "RedHat" do
      let(:facts) { { :osfamily => 'RedHat' } }
      it { should contain_file('/etc/init.d/activemq') }
    end
  end
end
