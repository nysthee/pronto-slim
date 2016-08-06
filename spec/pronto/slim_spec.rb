require 'spec_helper'

module Pronto
  describe Slim do
    let(:slim) { Slim.new(patches) }
    let(:patches) { nil }

    describe '#run' do
      subject { slim.run }

      context 'patches are nil' do
        it { should == [] }
      end

      context 'patches are empty' do
        let(:patches) { [] }
        it { should == [] }
      end
    end

    context 'private instance methods' do
      describe '#slim_file?' do
        subject { slim.send(:slim_file?, path) }

        context 'with slim format' do
          let(:path) { 'bar/foo.html.slim' }
          it { should == true }
        end

        context 'with other file format' do
          let(:path) { 'bar/foo.erb' }
          it { should == false }
        end
      end
    end
  end
end
