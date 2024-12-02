(defvar sample (format nil "3   4
4   3
2   5
1   3
3   9
3   3
"))

(defun str-join (lst)
  (reduce (lambda (acc x) (concatenate 'string acc "
  " x)) lst))

(defun delimiterp (c) (char= c #\linefeed))

(defun space-delim (c) (char= c #\Space))

(defun split (string &key (delimiterp #'delimiterp))
  (loop :for beg = (position-if-not delimiterp string)
    :then (position-if-not delimiterp string :start (1+ end))
    :for end = (and beg (position-if delimiterp string :start beg))
    :when beg :collect (subseq string beg end)
    :while end))

(defun parse (input) 
  (reduce 
    (lambda 
      (lists line) 
        (let ((parsed
              (mapcar 
                (lambda (part) (parse-integer part)) 
                (split line :delimiterp #'space-delim))))
            (list
              (cons (first parsed) (first lists)) 
              (cons (second parsed) (second lists)))))
          (split
            (string-trim 
              (list #\linefeed #\Space) input))
          :initial-value '(() ())))


(defun distance (input) (reduce '+ (let ((lists (parse input))) 
  (loop for x in (sort (first lists) '>)
        for y in (sort (second lists) '>)
        collect (abs (- x y))))))

(defun compare (input) (reduce '+ (let ((lists (parse input))) 
  (loop for x in (first lists)
        collect (* x (count x (second lists)))))))

(print (format nil "part 1 (sample): ~a" (distance sample)))
(print (format nil "part 2 (sample): ~a" (compare sample)))

(let ((in (open "input.txt")))
    (print (format nil "part 1: ~a" (distance (str-join (loop for line = (read-line in nil)
          while line
          collect line)))))
  (close in))

(let ((in (open "input.txt")))
    (print (format nil "part 2: ~a" (compare (str-join (loop for line = (read-line in nil)
          while line
          collect line)))))
  (close in))
