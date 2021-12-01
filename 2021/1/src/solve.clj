;;; clj -X solve/solve1
;;; clj -X solve/solve2

(ns solve)

(defn increases [nums]
  (let [x (first nums)
        xs (next nums)]
    (if (empty? xs) 0
        (+ (if (< x (first xs)) 1 0) (increases xs)))))

(defn movingSumsOf3
  "moving sums of 3"
  [nums]
  (if (< (count nums) 3) []
      (concat [(+ (nth nums 0) (nth nums 1) (nth nums 2))]
              (movingSumsOf3 (next nums)))))

(defn solve1 [opts]
  (let [nums (map #(. Integer parseInt %)
                  (clojure.string/split-lines (slurp "input-1")))]
    (println (increases nums))))

(defn solve2 [opts]
  (let [nums (map #(. Integer parseInt %)
                  (clojure.string/split-lines (slurp "input-1")))]
    (println (increases (movingSumsOf3 nums)))))
