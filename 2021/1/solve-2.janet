
(defn increases [xs]
  (if (= 1 (length xs))
    0
    (let [y (if (> (get xs 1) (get xs 0)) 1 0)]
      (+ y (increases (tuple/slice xs 1))))))

(defn moving-sums-of-3 [xs]
  (if (< (length xs) 3)
    @[]
    (array/concat @[(+ (get xs 0) (get xs 1) (get xs 2))]
                  (moving-sums-of-3 (tuple/slice xs 1)))
    ))

(print (increases
        (moving-sums-of-3
         (map scan-number (string/split "\n" (string/trimr (slurp "input-1")))))))
