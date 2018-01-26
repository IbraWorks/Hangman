class Dictionary

  def self.get_dictionary(file)
    @@dictionary = File.readlines(file)
  end

  def self.get_random_word(starting_range, ending_range)
    word = @@dictionary.sample
    while word.length.between?(starting_range, ending_range) == false
      word = @@dictionary.sample
    end
    return word
  end
end
