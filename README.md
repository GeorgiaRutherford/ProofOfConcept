# ProofOfConcept
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

'''
wget https://hypothes.is/api/search?url="$1"

mv search?url* original.txt

var=$(grep -o "created" original.txt | grep -c "created")

var2=$(($var+1))

i=1

until [ $i -gt $var2 ]

do

cat original.txt | awk -v FS='"id":' '{print $'$i'}' > output1.txt

grep -o '"created".*"updated"' output1.txt > output2.txt

sed 's/"updated"//g' output2.txt >> output3.txt

grep -o '"updated".*"user"' output1.txt > output2.txt

sed 's/"user"//g' output2.txt >> output3.txt

grep -o '"user".*"uri"' output1.txt > output2.txt

sed 's/"uri"//g' output2.txt >> output3.txt

grep -o '"uri".*"text"' output1.txt > output2.txt

sed 's/"text"//g' output2.txt >> output3.txt

grep -o '"text".*"tags"' output1.txt > output2.txt

sed 's/"tags"//g' output2.txt >> output3.txt

grep -o '"tags".*"group"' output1.txt > output2.txt

sed 's/"group"//g' output2.txt >> output3.txt

grep -o '"exact".*"prefix"' output1.txt > output2.txt

sed 's/"prefix"//g' output2.txt >> output3.txt

((i++))

echo "An Annotation Complete"

done

sed 's/":/ |/g;s/.//;s/ $//;s/,$//' output3.txt > output2.txt

sed '0~7 a\\' output2.txt > "$2".txt

echo "Analysis" >> "$2".txt

sed 's/":/|/g;s/.//;s/ $//;s/,$//' output3.txt > output2.txt

declare -a arr=( "created|" "updated|" "user|" "uri|" "text|" "exact|" "tags|" )

for c in "${arr[@]}"

do

grep '^'$c'' output2.txt > output3.txt

sed 's/'$c'//g' output3.txt > output1.txt

cat output1.txt | tr 'A-Z' 'a-z' | tr -d [:punct:] > output3.txt

cat output3.txt | tr -sc 'a-z' '\12' > output1.txt

sed -i '/^$/d' output1.txt

grep -i -F -v -w -f stopwords.txt output1.txt >output3.txt

cat output3.txt | sort | uniq -c | sort -nr | head -10 > output1.txt

sed -i '0~1 a\\' output1.txt

sed -i '1s/^/'$c'\n/' output1.txt

sed -i 's/|//g' output1.txt

cat output1.txt >> "$2".txt

echo "Analysis Complete"

done

sed -i '1s/^/Notes\n/' "$2".txt

rm output1.txt

rm output2.txt

rm output3.txt

mv original.txt "$2-original.txt"

echo "Task Complete"
'''
