class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @guessed_word = ""
    @win_or_loss = :play
  end
  
  def guess(letter)
    raise ArgumentError if invalidLetter? letter
    letter.downcase!
    return false if alreadyGuessed? letter
    if self.word.include? letter
      self.guesses += letter
    else
      self.wrong_guesses += letter
    end
    updateResults
    return true
  end
  
  def word_with_guesses()
    @guessed_word
  end
  
  def check_win_or_lose()
    @win_or_loss
  end
  
  private def updateResults()
    @guessed_word = ""
    for i in 0...(self.word.size)
      if self.guesses.include? self.word[i]  
        @guessed_word += self.word[i]
      else
        @guessed_word += "-"
      end
    end
    
    if @guessed_word.include? "-"
      if @wrong_guesses.size >= 7
        @win_or_loss = :lose
      end
    else
      if @wrong_guesses.size < 7
        @win_or_loss = :win
      end
    end
  end
  
  private def invalidLetter?(letter)
    (letter.nil?) || (letter.empty?) || !(letter =~ /[[:alpha:]]/)
  end
  
  private def alreadyGuessed?(letter)
    (self.guesses.include? letter) || (self.wrong_guesses.include? letter)
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
