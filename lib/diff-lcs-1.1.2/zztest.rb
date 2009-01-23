require 'lib/diff/lcs'
require 'lib/diff/lcs/array'

seq1 = %w[ i want you to behave ]
seq2 = %w[ i insist that you behave son ]

diffs = seq1.sdiff(seq2)
diffs.each do |diff| 
    p diff
end
