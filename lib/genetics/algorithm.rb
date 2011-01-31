module Genetics
  class Citizen
    attr_accessor :string, :fitness
    
    def initialize(string = nil)
      self.string = !string.nil? ? string : String.new
      self.fitness = 0
    end
  end
  
  class Algorithm
    attr_accessor :population # For testing
    
    @@GA_POP_SIZE = 2048
    @@GA_MAX_ITERATIONS = 16384
    @@RAND_MAX = 32767
    @@GA_ELITISM_RATE = 0.10
    @@GA_MUTATION_RATE = 0.25
    @@GA_MUTATION = @@RAND_MAX * @@GA_MUTATION_RATE
    @@GA_TARGET = "Hello world!"
    
    def initialize(output)
      @output = output
    end
    
    def init_population # Verified (Sort of)
      @population = Array.new
      @buffer = Array.new
      target_size = @@GA_TARGET.length

      @@GA_POP_SIZE.times do
        citizen = Citizen.new
        
        target_size.times do
          citizen.string += ((rand(@@RAND_MAX) % 90) + 32).chr
        end

        @population << citizen
      end
      
      # @buffer = Array.new(@population.length, Citizen.new) # If I don't do this I get bombarded with NPEs
    end
    
    def calc_fitness(citizen) # Verified and tested
      target = @@GA_TARGET
      target_size = target.length
      fitness = 0

      (0..(target_size - 1)).each do |j|
        fitness += (citizen.string.getbyte(j) - target.getbyte(j)).abs
      end
      
      fitness
    end
    
    def sort_by_fitness(population) # Verified and tested
      population.sort { |x, y| x.fitness <=> y.fitness }
    end
    
    def print_best(citizen) # Verified and tested
      @output.puts("Best: #{citizen.string} (#{citizen.fitness})")
    end
    
    def mate
      esize = (@@GA_POP_SIZE * @@GA_ELITISM_RATE).to_i # Verified
      tsize = @@GA_TARGET.length # Verified
      
      elitism(esize)
      
      (esize..(@@GA_POP_SIZE - 1)).each do |i|
        i1 = rand(@@RAND_MAX) % (@@GA_POP_SIZE / 2)
        i2 = rand(@@RAND_MAX) % (@@GA_POP_SIZE / 2)
        spos = rand(@@RAND_MAX) % tsize
        
        @buffer[i] = Citizen.new if @buffer[i].nil?
        @buffer[i].string = @population[i1].string[0, spos] + @population[i2].string[spos, esize - spos]
        
        if rand(@@RAND_MAX) < @@GA_MUTATION
          mutate(@buffer[i])
        end
      end
    end
    
    def elitism(esize)
      esize.times do |i|
        @buffer[i] = Citizen.new
        @buffer[i].string = @population[i].string
        @buffer[i].fitness = @population[i].fitness
      end
    end
    
    def mutate(citizen)
      tsize = @@GA_TARGET.length
      ipos = rand(@@RAND_MAX) % tsize
      delta = (rand(@@RAND_MAX) % 90) + 32
      
      citizen.string[ipos] = ((citizen.string.getbyte(ipos) + delta) % 122).chr
    end
    
    def swap
      temp = @population
      @population = @buffer
      @buffer = temp
    end

    def execute
      init_population
      
      @@GA_MAX_ITERATIONS.times do
        
        @@GA_POP_SIZE.times do |i|
          @population[i].fitness = calc_fitness(@population[i])
        end
        
        @population = sort_by_fitness(@population)
        print_best(@population[0])
        
        if @population[0].fitness == 0
          break
        end
        
        mate
        swap
      end
    end
  end
end