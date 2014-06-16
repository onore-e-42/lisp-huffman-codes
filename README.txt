(generate-huffman-tree (symbols-n-weights))
generate-huffman-tree: generates tree from a list of symbol-weight couples.

(generate-symbol-bits-table (huffman-tree))
generate_symbol_bits_table: generates a table of couples consisting of a symbol and its relative code.

(encode (message huffman-tree))
encode: encodes a message in a list of bits following an huffman tree.

(decode (bits huffman-tree))
decode: decodes a list of bits into a message following an huffman tree


e.g:

symbols-n-weights:
(list (list 'a 10)(list 'b 2)(list 'c 4)(list 'd 1)(list 'e 23)(list 'f 59))

huffman-tree:
((D B C A E F) 99 (((D B C A E) 40 (((D B C A) 17 (((D B C) 7 (((D B) 3 ((D 1) (B 2))) (C 4))) (A 10))) (E 23))) (F 59)))

encoded message (bits):
(encode (list 'a 'b 'c 'd 'e 'f) tree)
(1 1 0 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 0 0)

decode bits (message):
(decode '(1 1 0 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 0 0) tree)
(A B C D E F)

generate-symbol-bits-table:
(generate-symbol-bits-table tree)
((D (1 1 1 1 1)) (B (1 1 1 1 0)) (C (1 1 1 0)) (A (1 1 0)) (E (1 0)) (F (0)))