package main
import (
	"os"
	"log"
)

func main () {
	file, err := os.Open("input")
	if err != nil {
		log.Fatal(err)
	}

	data := make([]byte, 7000)
	count, err := file.Read(data);
	if err != nil {
		log.Fatal(err)
	}

	santa_at := 0
	santa_first_visit_to_basement := -1
	for i :=0; i < count; i++ {
		if data[i] == '(' {
			santa_at += 1
		} else if data[i] == ')' {
			santa_at -= 1
		}
		if santa_at == -1 && santa_first_visit_to_basement == -1 {
			santa_first_visit_to_basement = i + 1
		}
	}

	log.Printf("part 1: %d", santa_at)
	log.Printf("part 2: %d", santa_first_visit_to_basement)
}
