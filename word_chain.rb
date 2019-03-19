require "byebug"
require "set"

class WordChainer
    
    attr_reader :dictionary, :current_words, :all_seen_words

    def initialize(dictionary_file_name)
        @dictionary = extract_file(dictionary_file_name)
 
        run("ball", "deal")
    end 

    def extract_file(file)
        dictionary = Set.new([])
        IO.readlines(file).each {|line| dictionary << line.chomp} 
        dictionary
    end 

    def adjacent_words(og_word)   
        near_words = []
        i = 0    
        while i < og_word.length
            @dictionary.each do |word|
                if word.length == og_word.length && partial_match(word, og_word, i) && word != og_word
                    near_words << word 
                end 
            end 
            i += 1
            end   
        near_words
    end 

    def partial_match(word, og_word, i) 
        if i != 0 && og_word[i] != og_word[-1]
            first = og_word[0...i]
            last = og_word[(i + 1)..-1] 
            return word[0...i].include?(first) && word[(i + 1)..-1].include?(last)
        else
            arr = og_word.chars
            arr.delete_at(i)
            original = arr.join("")
            compare = word.chars
            compare.delete_at(i)
            word = compare.join("")
        end 
        word.include?(original)
    end 

    def run(source, target)
        @current_words = [source]
        @all_seen_words = {source=>nil}

        until @all_seen_words.include?(target)
            new_current_words = []
            @current_words.each_with_index do |word, i|
                if word.length == 2 
                    new_current_words += explore_current_words(word)
                else 
                    new_current_words += explore_current_words(word)
                end 
            end  
            new_current_words
            @current_words = new_current_words
        end 
       puts build_path(source, target)
    end 
    def explore_current_words(source)
        new_words = []
        adjacent_words(source).each do |word|
            if !@all_seen_words.include?(word)
                new_words << word
                @all_seen_words[word] = source
            end 
        end 
        new_words
    end 

    def build_path(source, target)
        return target if target == source 
              
        path = []
        path << (build_path(source, @all_seen_words[target]))
        path << target 
    end 
        
end 
if $PROGRAM_NAME == __FILE__
    WordChainer.new("dictionary.txt")
end 
