require 'spec_helper'

module Genetics
  describe Algorithm do
    describe "#init_population" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should populate with citizens" do
        output.should_receive(:puts).with(2048)
        algorithm.init_population
      end
    end
    
    describe "#calc_fitness" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should populate with citizens" do
        output.should_receive(:puts).with(2048)
        algorithm.init_population
        algorithm.calc_fitness
      end
    end
  end
end