require 'spec_helper'

module Genetics
  describe Algorithm do
    describe "#init_population" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should populate with citizens" do
        algorithm.init_population
        algorithm.population.size.should eql(2048)
      end
    end
    
    describe "#calc_fitness" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      let(:citizen) { Citizen.new }
      
      it "should set fitness equal to 5 for citizen" do
        citizen.fitness = 0
        citizen.string = "Hfljo wosld\""
        citizen.fitness = algorithm.calc_fitness(citizen)
        citizen.fitness.should eql(5)
      end

      it "should set fitness equal to 152 for citizen" do
        citizen.fitness = 0
        citizen.string = "IQQte=Ygqem#"
        citizen.fitness = algorithm.calc_fitness(citizen)
        citizen.fitness.should eql(152)
      end

      it "should set fitness equal to 378 for citizen" do
        citizen.fitness = 0
        citizen.string = "I+#prA?8dj;G"
        citizen.fitness = algorithm.calc_fitness(citizen)
        citizen.fitness.should eql(378)
      end

      it "should set fitness equal to 0 for citizen" do
        citizen.fitness = 0
        citizen.string = "Hello world!"
        citizen.fitness = algorithm.calc_fitness(citizen)
        citizen.fitness.should eql(0)
      end
    end
    
    describe "#sort_by_fitness" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should sort the array by fitness in ascending order" do
        population = Array.new
        population << Citizen.new("I+#prA?8dj;G", 378)
        population << Citizen.new("Hello world!", 0)
        population << Citizen.new("IQQte=Ygqem#", 152)
        
        population.length.should eql(3)
        sorted_pop = algorithm.sort_by_fitness(population)
        sorted_pop[0].fitness.should eql(0)
        sorted_pop[1].fitness.should eql(152)
        sorted_pop[2].fitness.should eql(378)
      end
    end
    
    describe "#print_best" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      let(:citizen) { Citizen.new("Hello world!", 0) }
      
      it "should print the string and fitness for the best citizen" do
        output.should_receive(:puts).with("Best: Hello world! (0)")
        algorithm.print_best(citizen)
      end
    end
    
    describe "#mate" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }

      it "should 'mate' substrings of population citizen strings for non-elite citizens, add them to the buffer and perhaps mutate" do
        algorithm.init_population
        algorithm.population.each do |citizen|
          citizen.fitness = algorithm.calc_fitness(citizen)
        end
        
        algorithm.mate
        
      end
    end
    
    describe "#elitism" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should populate the buffer with the top 10% of citizens based on fitness" do
        algorithm.init_population
        algorithm.population.each do |citizen|
          citizen.fitness = algorithm.calc_fitness(citizen)
        end
        
        algorithm.elitism(204)
        algorithm.buffer.size.should eql(204)
        (0..203).each do |i|
          algorithm.buffer[i].string.should eql(algorithm.population[i].string)
          algorithm.buffer[i].fitness.should eql(algorithm.population[i].fitness)
        end
      end
    end
    
    describe "#mutate" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should return a mutated string" do
        algorithm.mutate("Csnqt(xdfoe%").should be_an_instance_of(String)
      end
    end
    
    describe "#swap" do
      let(:output) { double('output').as_null_object }
      let(:algorithm) { Algorithm.new(output) }
      
      it "should swap buffer and population" do
        population = Array.new
        population << Citizen.new("I+#prA?8dj;G", 378)
        population << Citizen.new("Hello world!", 0)
        population << Citizen.new("IQQte=Ygqem#", 152)
        
        buffer = Array.new
        buffer << Citizen.new("Heiru(uoqid%", 33)
        buffer << Citizen.new("I\rtkHoks`i;", 124)
        buffer << Citizen.new("Hemlp woqld", 4)
        
        algorithm.population = population
        algorithm.buffer = buffer
        algorithm.swap
        
        algorithm.population.should eql(buffer)
        algorithm.buffer.should eql(population)
      end
    end
  end
end