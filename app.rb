require 'sinatra'
require 'erb'
require 'sinatra/reloader'

enable :sessions

def random_word
  dictionary = File.readlines('dictionary.txt').map {|word| word.chomp}
  possible_answers = dictionary.select { |word| (word.length > 4) && (word.length < 13) }
  possible_answers.sample.downcase
end

get '/' do
  erb :home
end

post '/' do
  reset_variables
  redirect '/play'
end

get '/play' do
  get_all_session_data
  redirect to('/win') if win?
  redirect to('/lose') if lose?
  session[:warning_message] = nil
  erb :play
end

post "/play" do
  get_all_session_data
  evaluate_guess
  redirect "/play"
end

get '/win' do
  erb :win
end

get '/lose' do
  erb :lose
end

def reset_variables
  solution = random_word.split("")
  session[:solution] = solution
  session[:guesses_remaining] = 6
  session[:incorrect_guesses] = []
  session[:gapped_solution] = []
  solution.length.times { session[:gapped_solution] << "__" }
end

def get_all_session_data
  @gapped_solution = session[:gapped_solution]
  @incorrect_guesses = session[:incorrect_guesses]
  @solution = session[:solution]
  @guesses_remaining = session[:guesses_remaining]
  @guess = params["guess"].downcase if params["guess"]
  @warning_message = session[:warning_message]
end

def evaluate_guess
  if @solution.include?(@guess)
    session[:gapped_solution] = update_gapped_solution
  elsif session[:incorrect_guesses].include?(@guess)
    session[:warning_message] = "You've already guessed #{@guess}"
  else
    session[:incorrect_guesses] << @guess
    session[:guesses_remaining] -= 1
  end
end

def update_gapped_solution
  correct_letters = @solution.each_index.select { |index| @solution[index] == @guess }
  correct_letters.each { |e| @gapped_solution[e] = @guess  }
  @gapped_solution
end

def win?
  @solution == @gapped_solution
  # !@gapped_solution.include?("__")
end

def lose?
  @guesses_remaining < 1
end
