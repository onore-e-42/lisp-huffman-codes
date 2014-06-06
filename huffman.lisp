(defun decode (bits huffman-tree)
  (labels ((decode-1 (bits current-branch)
             (unless (null bits)
               (let ((next-branch (choose-branch (first bits) current-branch)))
                 (if (leaf-p next-branch)
                     (cons (leaf-symbol next-branch) (decode-1 (rest bits) huffman-tree)) 
                        (decode-1 (rest bits) next-branch))))))
               (decode-1 bits huffman-tree)))

(defun choose-branch (bit branch) 
  (cond ((= 0 bit) (node-left branch))
        ((= 1 bit) (node-right branch)) 
        (t (error "Bad bit ~D" bit))))

(defun leaf-p (branch)
  (cond ((null (cdr (cdr branch))) T)
        (T nil)))

(defun leaf-symbol (leaf)
  (car leaf))


