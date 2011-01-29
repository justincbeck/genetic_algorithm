module Genetics
  class Citizen
    attr_accessor :fitness, :string
  end
  
  class Algorithm
    @@GA_POP_SIZE = 2048
    @@GA_MAX_ITERATIONS = 16384
    @@RAND_MAX = 32767
    @@GA_ELITISM_RATE = 0.10
    @@GA_MUTATION_RATE = 0.25
    @@GA_MUTATION = @@RAND_MAX * @@GA_MUTATION_RATE
    @@GA_TARGET = "Hello World!"
    
    def initialize(output)
      @output = output
      @population = Array.new
    end
    
    def execute
      init_population
      
      # @@GA_MAX_ITERATIONS.times do
      20.times do
        calc_fitness
        sort_by_fitness
        print_best
        
        if @population[0].fitness == 0
          break
        end
        
        mate
        swap
      end
    end
    
    private
    
    def init_population
      target_size = @@GA_TARGET.length

      @@GA_POP_SIZE.times do
        citizen = Citizen.new
        citizen.fitness = 0
        citizen.string = @@GA_TARGET.length.times.map { 48.+( rand(74) ).chr }.join

        @population << citizen
      end
      
      @buffer = Array.new(@population.length, Citizen.new)
    end
    
    def calc_fitness
      target_size = @@GA_TARGET.length
      
      @@GA_POP_SIZE.times do |i|
        fitness = 0
        target_size.times do |j|
          x = @population[i].string.getbyte(j)
          y = @@GA_TARGET.getbyte(j)
          fitness += (x - y).abs
        end
        
        @population[i].fitness = fitness
      end
    end
    
    def sort_by_fitness
      @population.sort { |x, y| x.fitness <=> y.fitness }
    end
    
    def print_best
      @output.puts("Best: #{@population[0].string} (#{@population[0].fitness})")
    end
    
    def mate
      esize = @@GA_POP_SIZE * @@GA_ELITISM_RATE
      tsize = @@GA_TARGET.length
      
      elitism(esize - 1)
      
      (esize.to_i..(@@GA_POP_SIZE - 1)).each do |i|
        i1 = rand(@@RAND_MAX) % (@@GA_POP_SIZE / 2)
        i2 = rand(@@RAND_MAX) % (@@GA_POP_SIZE / 2)
        
        spos = rand(@@RAND_MAX) % tsize
        
        @buffer[i].string = @population[i1].string[0, spos] + @population[i2].string[spos, esize - spos]
        
        if rand(@@RAND_MAX) < @@GA_MUTATION
          mutate(@buffer[i])
        end
      end
    end
    
    def elitism(esize)
      (0..esize).each do |i|
        @buffer[i].string = @population[i].string
        @buffer[i].fitness = @population[i].fitness
      end
    end
    
    def mutate(citizen)
      tsize = @@GA_TARGET.length
      ipos = rand(@@RAND_MAX) % tsize
      delta = 48.+( rand(74) )
      
      citizen.string[ipos] = (citizen.string[ipos] + delta.to_i.to_s) % 74
    end
    
    def swap
      temp = @population
      @population = @buffer
      @buffer = temp
    end
  end
end