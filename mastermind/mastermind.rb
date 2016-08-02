class Mastermind
  COLORS = %w{red blue green yellow orange purple}
  attr_accessor :guess
  def initialize
    @mode = 0
    @guess = []
    @hint = []
    @code = []
    @human = Human.new
    @computer = Computer.new
  end

  def game
  #S  `clear`
    @human.get_name
    play_mode
    if @mode == 1
      codebreaker
    elsif @mode == 2
      codemaker
    end
  end

  def play_mode
    valid = false
    while valid == false
      puts "Hey #{@human.name}! Do you want to make the color code or"
      puts "break the color code?"
      puts "Select 1 for making or Select 2 for breaking: "
      @mode = gets.chomp.to_i

      if @mode > 0 && @mode <= 2
      valid = true
      else
    #  `clear`
        puts "Invalid selection, please choose either option 1 or 2."
      end
    end
  end

  def codemaker
  #  `clear`
    puts "Colors to choose from: #{COLORS.inspect}"
    print "Please enter your guess for the four color code: "
    @code = @human.enter_code

    puts
    attempts = 1
    while attempts < 11
      if attempts == 1
        @guess = @computer.first_guess
      else
        @guess = @computer.final_array
        @computer.temp = []
      end
      puts "Guess Number: #{attempts}"
      get_results

      puts "The computer is guessing #{attempts}"
      3.times do
        print (".")
        sleep(1)
      end
      show_result
      @computer.logic(@hint, @guess)
      @computer.any_nil?
      @computer.final_array

      if win?
          puts "The computer has won!"
          play_again?
      end

      attempts += 1
    end

    puts "You have won!"
    play_again?
  end

  def get_results
    correct = 0
    while correct < @guess.length
      if @guess[correct] == @code[correct]
        @hint[correct] = "Exact"
      elsif @code.include?(@guess[correct])
        @hint[correct] = "Close"
      else
        @hint[correct] = "Nada"
      end
      correct += 1
    end
    return @hint
  end

  def show_result
    puts "Choice 1, Choice 2, Choice 3, Choice 4"
    puts "-" * 70
    puts "Guess | #{@guess[0]} #{@guess[1]} #{@guess[2]} #{@guess[3]}"
    puts "Result | #{@hint[0]} #{@hint[1]} #{@hint[2]} #{@hint[3]}"
  end

  def codebreaker
  #  `clear`
    attempt = 1
    @code = @computer.generate_code
    while attempt < 11
      puts "Colors to choose from: #{COLORS}"
      print "Please enter your guess for the color code."
      show_result

      if win?
        puts "You Won!"
        play_again?
      end
      attempt += 1
    end
    puts "You have lost."
    play_again?
  end
  def win?
		@hint.all? {|a| a == "Exact"}
	end
  def play_again?
    again = false
    while again == false
      print "Want to play again? (y/n): "
      input = gets.chomp.downcase
      if input == "y"
        again = true
        load './mastermind.rb'
      #  `clear`
        set_up_game
      elsif input == "n"
        again = true
        exit
      else
        puts "Invalid input, Please enter either 'y' or 'n'."
      end
    end
  end

  class Human
    attr_accessor :name
    def initialize
      @name = nil
    end

    def get_name #consider condesing this into just initialize
      print "What's your name? "
      @name = gets.chomp
    end

    def enter_guess
      guess = []
      choice = 0
      while choice < 4
        print "Color #{choice + 1 }: "
        guess[choice] = gets.chomp.upcase
        if COLORS.include?(guess[choice])
          choice += 1
        else
          puts "Invalid color, try another."
        end
      end
      return guess
    end

    def enter_code
      code = []
      choice = 0

      while choice < 4
        print "Color #{i + 1}: "
        code[choice] = gets.chomp.upcase
        if COLORS.include?(code[choice])
          choice += 1
        else
          puts "Invalid color, try another."
        end
      end
      return code
    end
  end

  class Computer
    attr_accessor :final_array, :temp, :possible_letters

    def initialize
      @temp=Array.new(4)
      @first_guess = []
      @free_indexes = []
      @final_array = []
      @possible_colors = COLORS
    end

    def generate_code
      COLORS.sample(4)
    end

    def first_guess
      while @first_guess.size < 4
        @first_guess << COLORS[rand(COLORS.size)]
        @first_guess.uniq!
      end
      return @first_guess
    end


    def logic(hint, guess)
      i = 0
      while i < hint.size
        if hint[i] == "Exact"
          @temp[i] = guess[i]
          @possible_colors.delete(guess[i])
        elsif hint[i] == "Near"
          if @temp.count(guess[i]) > 1 || @final_array.count(guess[i]) > 1
            find_empty_indexes
            @temp[@new_index] = choose_random_color(guess[i])
          else
            find_empty_indexes
            @temp[@new_index] = guess[i]
          end
        elsif hint[i] == "Nada"
          @possible_colors.delete(guess[i])
          @temp[i] = @possible_colors[rand(@possible_colors.size)]
        end
        i += 1
      end
      @final_array = @temp
      return @final_array
    end

    def any_nil?
      i = 0
      while i < 4
        if @temp[i] == nil
          @temp[i] = @possible_colors[rand(@possible_colors.length)]
        end
        i += 1
      end
      @final_array = @temp
      return @final_array
    end

    def choose_random_color(color)
      new_color = color

      while new_color == color
        new_color = @possible_colors[rand(@possible_color.size)]
      end
      return new_color
    end

    def find_empty_indexes
      i = 0
      @free_indexes.clear
      while i < 4
        if @temp[i] == nil
          @free_indexes << i
        end
          i += 1
        end
        @new_index = @free_indexes[rand(@free_indexes.size)]
        return @new_index
      end
    end

  end

  newgame = Mastermind.new
  newgame.game
