
(defn increases [xs]
  (if (= 1 (length xs))
    0
    (let [y (if (> (get xs 1) (get xs 0)) 1 0)]
      (+ y (increases (tuple/slice xs 1))))))

(print (increases
        (map scan-number (string/split "\n" (string/trimr (slurp "input-1"))))))
