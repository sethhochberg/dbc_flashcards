require_relative 'deck'

module LoopingInterface
  def start_interface
    puts help
    while true
      input = gets.chomp
      break if input == 'exit'
      self.send(input.to_sym)
    end
  end
end

def Game
  
  attr_reader :num_correct, :num_incorrect

  def init
    @num_correct = 0
    @num_incorrect = 0
    @last_guess_good = false

    if ARGV[0].nil?
      help and return
    else
      @filename = ARGV[0]
      play!
    end
  end

  def play!
    @deck = Deck.new(@filename)
    
    while true
      current_card = @deck.top_card unless last_guess_wrong?
      print 'Definition: '
      puts current_card.definition
      print 'Guess: '
      input = gets.chomp
      case input
      when 'exit'
        stats
        return
      when 'stats'
        stats
      when 'help'
        help
      else
        if input == current_card.answer
          correct!
        else
          incorrect!  
        end 
      end
    end    
  end

  def help
    puts "This is a flash card game. It MUST be run with a filename:"
    puts "ruby game.rb your_deck_filename.txt"
    puts "- "*20 
    puts "You can play by guessing terms by their definition."
    puts "At any time, type 'exit' to exit."
    puts "Type 'play!' to start the game."
    puts "You can type 'stats' to see your score."
    puts "'shuffle' will shuffle the order of cards." 
  end

  def stats
    puts "You have given #{@num_correct} correct answers. Good job!"
    puts "You have given #{@num_incorrect} wrong answers. Step it up!"  
  end

  private

  def correct!
    puts "Congratulations! That was a correct answer!"
    @last_guess_good = true
    @num_correct += 1
  end

  def incorrect!
    puts "Try again. That wasn't right."
    @last_guess_good = false
    @num_incorrect += 1
  end

  def last_guess_wrong?
    return !@last_guess_good
  end
end
