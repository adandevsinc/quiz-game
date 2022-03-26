# frozen_string_literal: true

require 'csv'
require 'timeout'

# if file name is not given in args default file is problems.csv
filename = 'problems.csv'
filename = ARGV[1] if ARGV[0] == '-n'
filename = ARGV[3] if ARGV[2] == '-n'
time = 30
time = ARGV[1] if ARGV[0] == '-t'
time = ARGV[3] if ARGV[2] == '-t'

# exception handling
begin
  # timer
  correct, wrong, unattempted = Timeout.timeout(time.to_i) do
    correct = wrong = 0

    # count number of questions
    unattempted = CSV.read(filename).size

    # reading file
    CSV.read(filename).each do |line|
      *question, answer = line
      puts question.join(',')
      name = STDIN.gets.chomp
      answer = answer.sub(/ /, '')
      unattempted -= 1
      name == answer ? correct += 1 : wrong += 1
    end
    [correct, wrong, unattempted]
  end
rescue Timeout::Error
  # final output
  puts "Total questions: #{correct + wrong + unattempted}"
  puts "Correct answers: #{correct}"
  puts "Wrong answers: #{wrong + unattempted}"
end
