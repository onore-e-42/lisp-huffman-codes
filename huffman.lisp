;generate-huffman-tree: generates tree from a list of symbol-weight couples.
(defun generate-huffman-tree (symbols-n-weights)
	(if (null (cdr symbols-n-weights))
		(car symbols-n-weights)
		(let ((ordered (stable-sort symbols-n-weights 'criterion)))
			(let ((tree-step (
				append (list (list (flatten (list (car (car ordered))(car (car (cdr ordered))))) 
				(+ (car (cdr (car ordered)))(car (cdr (car (cdr ordered)))))
				(list (car ordered)(car (cdr ordered))))) (cdr (cdr ordered))
				)
			))
				(generate-huffman-tree tree-step))
		)
	)				
)
		
(defun flatten (x)
       (cond ((null x) x)
             ((atom x) (list x))
             (T (append (flatten (first x)) (flatten (rest x))))))

(defun criterion (a b)
	(if (< (car (cdr a))(car (cdr b)))
		T
	nil
	)
)

;generate_symbol_bits_table: generates a table of couples consisting of a symbol and its relative code.
(defun generate-symbol-bits-table (huffman-tree)
	(let ((symbols (car huffman-tree)))
		(labels ((generate-symbol-bits-1 (symbols huffman-tree)
					(unless (null symbols)
					(cons (cons (car symbols) (list (encode (list(car symbols)) huffman-tree)))
					(generate-symbol-bits-1 (cdr symbols) huffman-tree))
					)
				))
		(generate-symbol-bits-1 symbols huffman-tree))
	)
)


;encode: encodes a message in a list of bits following an huffman tree.
(defun encode (message huffman-tree)
	(unless (null huffman-tree)
		(labels ((encode-1 (message current-branch)
			(unless (null message)
				(if (leaf-p current-branch) 
					(encode-1 (cdr message) huffman-tree)
					(cond 	((member (car message) (flatten(node-left current-branch)))
								(cons 0 (encode-1 message (node-left current-branch))))
							((member (car message) (flatten(node-right current-branch)))
								(cons 1 (encode-1 message (node-right current-branch))))
							((T) (error "Invalid character"))
					)
				)
			)
		))
		(encode-1 message huffman-tree))
	)
)


(defun node-left (branch)
	(car (cdr (car (cdr (cdr branch)))))
)
(defun node-right (branch)
	(car (car (cdr (cdr branch))))
)


;decode: decodes a list of bits into a message following an huffman tree
(defun decode (bits huffman-tree)
  (labels ((decode-1 (bits current-branch)
				(unless (null bits)
					(let ((next-branch (choose-branch (car bits) current-branch)))
					(if (leaf-p next-branch)
						(cons (leaf-symbol next-branch) (decode-1 (cdr bits) huffman-tree)) 
						(decode-1 (rest bits) next-branch)))
				)
			))
           (decode-1 bits huffman-tree))
)

(defun choose-branch (bit branch) 
  (cond ((= 0 bit) (node-left branch))
        ((= 1 bit) (node-right branch)) 
        (t (error "Bad bit ~D" bit))))

(defun leaf-p (branch)
  (cond ((null (cdr (cdr branch))) T)
        (T nil)))

(defun leaf-symbol (leaf)
  (car leaf))