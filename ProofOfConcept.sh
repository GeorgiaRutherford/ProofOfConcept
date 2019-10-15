# Will download notes from hypothesis, rename original, move info into a new file without unwanted sections and perform basic analysis of notes
# Warning: This will rename all files beginning with search?url
# Warning: If note includes the phrases "created", "updated", "user", "uri", "text", "tags", "group", "exact", or "prefix" (including the "" this code will not work
# Must also have a stopwords.txt file for the analysis to be useful
# Usage: bash ProofOfConcept.sh URL Filename

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
