require_relative "board.rb"
require "json"
class Hangman

  attr_accessor :board, :success, :failure
  def initialize
    @max_turns = 7
    @success = false
    @failure = false
  end

  def game_loop
    intro
    @board = Board.new(get_starting_range_of_word, get_ending_range_of_word)
    @board.display_board
    ask_for_load if Dir.exist?("./saved_games")
    play_game
  end

  def play_game
    loop do
      @board.update_board(get_guess)
      check_success?
      check_failure?
      break if @success || @failure
    end
    success_message if @success
    failure_message if @failure
  end
  def get_starting_range_of_word
    puts "\n\nHow long do you want the secret word to be?"
    puts "Please state, from the pool of words, what is the shortest acceptable"
    puts "length of the secret word?"
    starting_range = gets.chomp.to_i
    if !starting_range.is_a?(Integer) || starting_range < 4 || starting_range > 10
      puts "\nplease press a number. The shortest possible word can not be less than"
      puts "4 letters long, and cant be longer than 10 letters long"
      get_starting_range_of_word
    else
      return starting_range
    end
  end

  def get_ending_range_of_word
    puts "\nAnd what is the longest length the word can be?"
    ending_range = gets.chomp.to_i
    if !ending_range.is_a?(Integer) || ending_range < 8 || ending_range > 12
      puts "\nplease press a number. It cant be less than 8 come on thats too easy!"
      puts "It cant be longer than 12 either, i dont think youre too smart to handle"
      puts "any word longer than 12"
      get_ending_range_of_word
    else
      return ending_range
    end
  end

  def how_many_turns_left
    return @max_turns - @board.bad_guesses.length
  end

  def get_guess
    puts "\nPlease enter your guess."
    user_guess = gets.chomp.downcase
    if !user_guess.match(/^[a-z]$/) && user_guess != "save"
      puts "\nThere are only letters in the code. Use letters A-Z in your guess"
      puts "One letter per guess. I'm trying to help you out dude."
      get_guess
    elsif @board.good_guesses.include?(user_guess) || @board.bad_guesses.include?(user_guess)
      puts "\nYou've tried that before. Dont waste a guess!"
      puts "You only got like #{how_many_turns_left} guesses left!"
      puts "You're lucky I run linux and so I'm a nice guy and wont count that."
      puts "Try again."
      get_guess
    elsif user_guess == "save"
        ask_for_save
    else
      return user_guess
    end
  end

  def check_success?
    @success = true if @board.good_guesses == @board.secret_word
  end

  def check_failure?
    @failure = true if @board.bad_guesses.length >= 7
  end

  def success_message
    puts "Congrats, you win!"
    play_again?
  end

  def failure_message
    puts "\nUnlucky, the word was #{@board.secret_word.join}"
    puts "Wtf is that?" if @board.secret_word.join == "glutei"
    play_again?
  end

  def play_again?
    @success = false
    @failure = false
    puts "\nDo you want to play again?"
    puts "Type yes if you do and no if you dont"
    response_to_play_again ? game_loop : exit
  end

  def response_to_play_again
    answer = gets.chomp.downcase
    if answer == "yes"
      puts "Ok lets do it!"
      true
    elsif answer == "no"
      puts "OK, hope you had fun. Bye!\n"
      false
    else
      puts "I'm sorry, type yes or no"
      response_to_play_again
    end
  end

  def ask_for_save
    puts "\nDo you want to save the game? [ yes  | no  ]"
    save_game if get_response == "yes"
    other_response if get_response == "no"
  end

  def get_response
    response = gets.chomp.downcase
    if response == "yes"
      return response
    elsif response == "no"
      return response
    else
      print "I didnt catch that, please press yes or no"
      get_response
    end
  end

  def other_response
    puts "Please press yes to continue with the game, or no to quit"
    response_to_play_again ? get_guess : exit
  end

  def ask_for_load
    puts "\nA game file already exists."
    puts "Do you want to load a game? [ yes  | no  ]"
    load_game if get_response == "yes"
  end

  def save_game
    file_number = get_saved_file_number
    puts "saving..."
    sleep(2)
    create_save_file(file_number)
    puts "done"
    continue?
  end

  def continue?
    puts "press yes if you want to continue, and no if you want to quit"
    get_response == "yes" ? play_game : print_exit_response
  end

  def print_exit_response
    puts "Hope you had fun, be sure to remember which file you saved this game"
    puts "in so that you can load it up next time. bye \n"
    exit
  end

  def get_saved_file_number
    puts "Choose the save file number you want to save the game in (1, 2, 3 or 4). "
    number = gets.chomp
    if !number.match(/[1-4]/)
      puts "Just pick a number between 1 and 4. Why do you need more than 4 saves"
      puts "anyway, its hangman for God's sake it takes two minutes to complete"
      puts "hmm.. wait a minute... are YOU running windows?!!!"
      get_saved_file_number
    else
      return number
    end
  end

  def create_save_file(file_number)
    Dir.mkdir("./saved_games") if (Dir.exist?("./saved_games") == false)
    saved_game = File.open("./saved_games/saved_game#{file_number}.json", "w")
    saved_game.write(@board.convert_to_json)
  end

  def load_game
    @board.load(get_load_file_number)
    sleep(2)
    puts "welcome back.."
    @board.display_board
  end

  def get_load_file_number
    puts "which file would you like to load?"
    number = gets.chomp
    if !File.exist?("./saved_games/saved_game#{number}.json")
      puts "hmm.. That file cant be found, please try again"
      get_load_file_number
    else
      return number
    end
  end


  def intro

    puts "

                                /$$   /$$                                     /$$      /$$
                                | $$  | $$                                    | $$$    /$$$
                                | $$  | $$  /$$$$$$  /$$$$$$$   /$$$$$$       | $$$$  /$$$$  /$$$$$$  /$$$$$$$
                                | $$$$$$$$ |____  $$| $$__  $$ /$$__  $$      | $$ $$/$$ $$ |____  $$| $$__  $$
                                | $$__  $$  /$$$$$$$| $$ \\ $$| $$ \\ $$      | $$  $$$| $$  /$$$$$$$| $$ \\ $$
                                | $$  | $$ /$$__  $$| $$  | $$| $$  | $$      | $$\\ $ | $$ /$$__  $$| $$  | $$
                                | $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$      | $$\\/  | $$|  $$$$$$$| $$  | $$
                                |__/  |__/\\_______/|__/  |__/\\____  $$      |__/     |__/\\_______/|__/  |__/
                                                               /$$  \\$$
                                                              |  $$$$$$/
                                                              \\______/




                              "

    puts "\n\n"
    puts "----------------------------------"
    puts "\nThe rules of the game are simple. First you select your difficulty"
    puts "by choosing the shortest and longest possible length of the secret code"
    puts "Then you guess a letter, if the guess is correct you'll be closer to guessing"
    puts "the word. But if its wrong, you get closer to getting the man hung to death."
    puts "Try to get it right, the man hasnt done anything after all (besides use windows)\n\n"
    puts "----------------------------------"
    puts "\nYou have seven chances to make an incorrect guess before the windows"
    puts "using man is dead. Maybe you should guess it wrong on purpose."
    puts "Who uses windows?? He should be running linux!!"
    puts "good luck\n\n"
  end

  #load dictionary - dictionaryclass
  #game loop
    #tell player how many guesses they have left - boardclass
    #display the word in hidden form i.e. with _ _ _ - boardclass
    #ask player for a guess (ensure its validated) -
    #check player guess
      #if guess is correct replace the _ with the letter
      #if guess is incorrect player has one less available guess
    #check for vic/loss
      #check if board is complete
      #check if ran out of guesses

end
