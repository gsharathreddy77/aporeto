package main

import (
    "fmt"
	"flag"
    "net/http"
    "io/ioutil"
    "os"
	"io"
	"regexp"
	"strings"
	"strconv"
    )
	

/* Get words from the text using non alpha numeric characters as delimiters */
func get_words_from(text string) []string{
	re := regexp.MustCompile(`[a-z0-9A-Z]+`)
    return re.FindAllString(text, -1)
}

/* Count the frequency of each word */
func count_words (words []string) map[string]int{
    word_counts := make(map[string]int)
    for _, word :=range words{
        word_counts[word]++
    }
    return word_counts;
}

/* write the frequenccy table to a output file */
func console_out (word_counts map[string]int, i int, url string){
	filename := "url"+ strconv.Itoa(i+1) + ".txt"
	f, err := os.Create(filename)
	if err != nil {
	fmt.Println(err)
	}
	n, err := io.WriteString(f, "url: " + url + "\n")
	if err != nil {
	fmt.Println(n, err)
	}
    for word, word_count :=range word_counts{
        //fmt.Printf("%v %v\n",word, word_count)
		n, err = io.WriteString(f, "\t" + word + "\t" + strconv.Itoa(word_count) + "\n")
		if err != nil {
		fmt.Println(n, err)
		}
    }
	 f.Close()
}
/*Open the url and get the content	and write the word frequenccy table */
func getDataUrl(url string, i int, c chan string) {
	response, err := http.Get(url)
    if err != nil {
        fmt.Printf("%s", err)
    } else {
		b := response.Body
        defer b.Close()
		contents, err := ioutil.ReadAll(b)
        if err != nil {
            fmt.Printf("%s", err)
            //os.Exit(1)
        }
		
		console_out(count_words(get_words_from(string(contents))), i, url)
		c <- "over"
    }
}

func main() {

	wordPtr := flag.String("urls", "", "comma seperated urls")
	
	helpPtr := flag.Bool("help", false, "a bool value to store help")
	helpPtr2 := flag.Bool("h", false, "a bool value to store help")
	
	
    // Once all flags are declared, call `flag.Parse()`
    // to execute the command-line parsing.
    flag.Parse()
	if(*helpPtr == true || *helpPtr2 == true){
		fmt.Println("Usage:gosample -urls=<url1>[,<url2>[,<url3>[,<url4>]]]")
		os.Exit(1)
	}
    fmt.Println("urls:", *wordPtr)
	if(*wordPtr == ""){
		fmt.Println("Usage:gosample -urls=<url1>[,<url2>[,<url3>[,<url4>]]]")
		os.Exit(1)
	}
	urlList := strings.Split(*wordPtr, ",")
	var c chan string = make(chan string)
	var i int
	fmt.Println("Printing urls:", len(urlList))
	
	/* Call go routine using each url */
	for i=0; i < len(urlList); i++{	
		fmt.Println("url:", urlList[i])
		go getDataUrl(urlList[i], i, c)
	}
	/* wait for the signal from the channel for each url which indicates that it is finished */
	for i=0; i < len(urlList); i++{	
		msg := <- c
		fmt.Println(msg)
	}



	
}