require_relative "dictionary.rb"

class Board

  attr_accessor :secret_word, :good_guesses, :bad_guesses, :player_name

  def initialize(starting_range, ending_range)
    Dictionary.get_dictionary("dictionary.txt")
    @secret_word = Dictionary.get_random_word(starting_range, ending_range).downcase.chomp.split("")
    @good_guesses = []
    @secret_word.length.times do
      @good_guesses << "_"
    end
    @bad_guesses = []
  end

  def draw_board
    case @bad_guesses.length
    when 0
      puts "  ____________  "
  		puts "  |   \\|"
  		puts "       |"
  		puts "       |"
  		puts "       |"
  		puts "       |"
      puts "-------^-------"
    when 1
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts "       |"
      puts "       |"
      puts "       |"
      puts "-------^-------"
      hangman_board_message
    when 2
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts "  |    |"
      puts "       |"
      puts "       |"
      puts "-------^-------"
      hangman_board_message
    when 3
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts " /|    |"
      puts "       |"
      puts "       |"
      puts "-------^-------"
      puts
      puts "Running out of chances now. only #{7-bad_guesses.length} guesses left"
    when 4
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts " /|\\   |"
      puts "       |"
      puts "       |"
      puts "-------^-------"
      hangman_board_message
    when 5
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts " /|\\   |"
      puts "  |    |"
      puts "       |"
      puts "-------^-------"
      puts
      puts "Getting real close to losing. get it together man, the windows"
      puts "using guy is gonna die soon. #{7 - bad_guesses.length} guesses left"
    when 6
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts " /|\\   |"
      puts "  |    |"
      puts " /     |"
      puts "-------^-------"
      puts
      puts "ONE MORE MISTAKE AND IT'S FINISHED DUDE!"
      puts "Or maybe that's what you want. hmm yes, serves him right for using"
      puts "blue-screen-of-death-windows doesnt it. Go on, pick Z."
      puts "it's never Z. Kill him!"
    when 7
      puts "  ____________  "
      puts "  |   \\|"
      puts "  O    |"
      puts " /|\\   |"
      puts "  |    |"
      puts " / \\   |"
      puts "-------^-------"
      puts
      puts "I guess you could say, he's hanging in there... get it... hanging.."
      puts "I'm so funny man. I get my jokes from linux. where the best jokes"
      puts "are!!"
    end
  end

  def hangman_board_message
    puts "\nYou've got #{7-bad_guesses.length} chances to make a mistake again"
  end
  def display_bad_guesses
    count = 1
    @bad_guesses.each { |e|

      puts "Incorrect guess #{count}: #{e}"
      count += 1
    }
  end

  def display_good_guesses
    puts "\nThe word is: #{@good_guesses.join(" ")}"
  end

  def display_board
    draw_board
    display_good_guesses
    display_bad_guesses
  end

  def update_board(guess)
    evaluate_guess(guess)
    display_board
  end

  def evaluate_guess(guess)
    if @secret_word.include?(guess)
      correct_letters = @secret_word.each_index.select { |index| @secret_word[index] == guess }
      correct_letters.each { |e| @good_guesses[e] = guess  }
    else
      @bad_guesses << guess
    end
  end

  def check_for_longest_word
    #use this to define maximum ending_range of word
  end

  def check_for_shortest_word
    #use this to define minimum starting_range of word
  end

  def convert_to_json
    {"secret_word" => @secret_word, "good_guesses" => @good_guesses, "bad_guesses" => @bad_guesses}.to_json
  end

  def load(file_number)
    json_data = File.read("saved_games/saved_game#{file_number}.json")
    data = JSON.parse(json_data)
    @secret_word = data["secret_word"]
    @good_guesses = data["good_guesses"]
    @bad_guesses = data["bad_guesses"]
  end
end
