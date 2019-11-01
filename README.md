# ProofOfConcept
Static Website: https://georgiarutherford.github.io/ProofOfConcept/
This is my proof of concept for FOAR705.

# Purpose
I have found hypothes.is a useful tool for taking notes on online sources. Hypothes.is improves the efficiency of my note taking as it allows me to visually see the notes I have taken while I am reading rather than switching through multiple tabs. It also allows for improved collaboration as I am able to send my notes within their original context, and see public notes other users are taking. However, hypothes.is does not currently have a tool that allows users to locally back up their notes. This is an issue for multiple reasons. Firstly, if hypothes.is were to become inaccessible I would be unable to access many of the notes I had taken. Secondly, I also take notes on physical sources such as books and would like to be able to keep all my notes organised in the same place. Finally, having my notes in text format would allow for automatic analysis that could help direct my future research. Therefore, for my proof of concept I have decided to work on a tool that takes annotation information from hypothes.is and locally backs it up. This tool will also improve the quality and efficiency of the research projects of other academics who utilise hypothes.is. Hypothes.is allows for ease of online note taking and collaboration, and this tool increases the security and organisation of that process. 

# Usage
This code is a shell script and can be used within terminal. This code has been developed and tested on SWAN terminal available via cloudstor. Initial testing has suggested that the code will not work in git-bash as the wget command is not supported by git-bash.

Alternatively follow this link https://repl.it/@GeorgiaRutherfo/ProofOfConcept to an executable environment.

To run the script type ' bash ProofOfConcept.sh (URL) (filename) ' where the (URL) is the url from which you want to save annotation information and the (filename) is the desired filename. Note that for useful analysis of the notes you will also need the stopwords.txt file. The stopwords.txt file can be updated to suit the users purposes.

# Result
The result of this code will be two files. One will be titled (filename).txt. This file will contain notes taken from hypothes.is formatted in such a way that is human readable. It will also contain a basic analysis of the notes. That is, it will show the most common words used in the user, uri, text, exact, and tags sections of the annotation information. This will allow the user to know at a glance who was involved in the note taking, where the notes are from and important themes. The other file will be titled (filename)-original.txt. This file will contain the original uncleaned annotaion information from the hypothes.is API. 

# Example Code
This is an example of the Proof of Concept code. For the code with comments and the stopwords.txt file, please see the code folder of the github repository:  https://github.com/GeorgiaRutherford/ProofOfConcept

```
# Will download notes from hypothesis, rename original, move info into a new file without unwanted sections and perform basic analysis of notes
# Warning: This will rename all files beginning with search?url
# Warning: If note includes the phrases "created", "updated", "user", "uri", "text", "tags", "group", "exact", or "prefix" (including the "" this code will not work
# Must also have a stopwords.txt file for the analysis to be useful
# Usage: bash ProofOfConcept.sh URL Filename

# This section of code gets the annotation information from the hypothes.is api and then renames the file to original.txt
wget https://hypothes.is/api/search?url="$1"
mv search?url* original.txt

# This line of code creates a variable which is a count of every instance of the term "created" (including the quotation marks)
var=$(grep -o "created" original.txt | grep -c "created")

# This section of code creates a variable that is the same as the above variable but plus one
var2=$(($var+1))

# This section of code sets the initial value of i within the until loop
i=1

# This line of code states that the loop will continue until $i is equal to the value of var2 set above
until [ $i -gt $var2 ]

# This command begins the loop
do

# This section of code examines the original.txt file and moves a section of text (which changes based on the i variable) to a new file for reformating
cat original.txt | awk -v FS='"id":' '{print $'$i'}' > output1.txt

# This section of code copies the text between the terms "created" and "updated", and then deletes the term "updated"
grep -o '"created".*"updated"' output1.txt > output2.txt
sed 's/"updated"//g' output2.txt >> output3.txt

# This section of code copies the text between the terms "updated" and "user", and then deletes the term "user"
grep -o '"updated".*"user"' output1.txt > output2.txt
sed 's/"user"//g' output2.txt >> output3.txt

# This section of code copies the text between the terms "user" and "uri", and then deletes the term "uri"
grep -o '"user".*"uri"' output1.txt > output2.txt
sed 's/"uri"//g' output2.txt >> output3.txt

# This section of code copies the text between the terms "uri" and "text", and then deletes the term "text"
grep -o '"uri".*"text"' output1.txt > output2.txt
sed 's/"text"//g' output2.txt >> output3.txt

# This section of code copies the text between the terms "text" and "tags", and then deltes the term "tags"
grep -o '"text".*"tags"' output1.txt > output2.txt
sed 's/"tags"//g' output2.txt >> output3.txt

# This section of code copies the text between the terms "tags" and "group", and then deletes the term "group"
grep -o '"tags".*"group"' output1.txt > output2.txt
sed 's/"group"//g' output2.txt >> output3.txt

# This section of code copies the text between the terms "exact" and "prefix", and then deltes the term "prefix"
grep -o '"exact".*"prefix"' output1.txt > output2.txt
sed 's/"prefix"//g' output2.txt >> output3.txt

# This line of code incrementally increases the $i within the loop. This will mean the loop will run through the code again for the next annotation
((i++))

# This line of code will type An Annotation Complete each time the code finishes a loop. This will allow the user to see progress made
echo "An Annotation Complete"

# This command finishes the loop. The loop will repeat until $i is equal to var2. The result of this loop is that all irrelevant sections of text are deleted. The remaining sections are the ones beginning with "created", "updated", "user", "uri", "text", "tags" and "exact"
done

# This changes all instances of ": to | (for example "created": will be created |). It also removes unwanted commas at the end of lines
sed 's/":/ |/g;s/.//;s/ $//;s/,$//' output3.txt > output2.txt

# This line of code will add a space every 7 lines within the final document to separate out each annotation
sed '0~7 a\\' output2.txt > "$2".txt

# This line of code types the heading Analysis at the end of the final document page, all analysis from the next loop will be pasted under this heading
echo "Analysis" >> "$2".txt

# This changed all instances of ": to | (in this case "created" would change to created| without the space, this is important for the following array loop). It also removes unwanted commas at the end of lines
sed 's/":/|/g;s/.//;s/ $//;s/,$//' output3.txt > output2.txt

# This line of code declares the array that the next loop will run through
declare -a arr=( "created|" "updated|" "user|" "uri|" "text|" "exact|" "tags|" )

# This line of code states that $c within the loop will change through the array terms
for c in "${arr[@]}"

# This command begins the loop
do

# This line of code moves all texts after every instance of one of the array terms to a new file for analysis to be done
grep '^'$c'' output2.txt > output3.txt

# This line of code deletes the array term that started this loop so that it won't be included in the analysis
sed 's/'$c'//g' output3.txt > output1.txt

# This section of code reformats all uppercase letters to be lowercase, and deletes all punctuation to allow for better analysis
cat output1.txt | tr 'A-Z' 'a-z' | tr -d [:punct:] > output3.txt
cat output3.txt | tr -sc 'a-z' '\12' > output1.txt
sed -i '/^$/d' output1.txt

# This line of code deletes all instances of terms in stopwords.txt so that they will not be included within the analysis
grep -i -F -v -w -f stopwords.txt output1.txt >output3.txt

# This line of code sorts the remaining words by the top 10 most common
cat output3.txt | sort | uniq -c | sort -nr | head -10 > output1.txt

# This line of code adds a space to separate out each section of analysis
sed -i '0~1 a\\' output1.txt

# This section of code adds a title based on the variable being used in the loop and then deletes the | at the end of that title
sed -i '1s/^/'$c'\n/' output1.txt
sed -i 's/|//g' output1.txt

# This line of text moves the results of an analysis loop into the final document
cat output1.txt >> "$2".txt

# This line of code writes Analysis Complete on the screen after each loop so the user can track progress
echo "Analysis Complete"

# This command finishes the loop. The loop will repeat until it has run through the declared array
done

# This line of code writes Notes at the top of the final document
sed -i '1s/^/Notes\n/' "$2".txt

# This section of code removes the working files used throughout the code
rm output1.txt
rm output2.txt
rm output3.txt

# This line of code renames the original.txt file so that it is named according to the chosen filename
mv original.txt "$2-original.txt"

# This line of code writes Task Complete on the screen so the user knows when the code has finished running
echo "Task Complete"
```
