# ProofOfConcept
This is my proof of concept for FOAR705.

# Purpose
I have found hypothes.is a useful tool for taking notes on online sources. Hypothes.is improves the efficiency of my note taking as it allows me to visually see the notes I have taken while I am reading rather than switching through multiple tabs. It also allows for improved collaboration as I am able to send my notes within their original context, and see public notes other users are taking. However, hypothes.is does not currently have a tool that allows users to locally back up their notes. This is an issue for multiple reasons. Firstly, if hypothes.is were to become inaccessible I would be unable to access many of the notes I had taken. Secondly, I also take notes on physical sources such as books and would like to be able to keep all my notes organised in the same place. Finally, having my notes in text format would allow for automatic analysis that could help direct my future research. Therefore, for my proof of concept I have decided to work on a tool that takes annotation information from hypothes.is and locally backs it up. This tool will also improve the quality and efficiency of the research projects of other academics who utilise hypothes.is. Hypothes.is allows for ease of online note taking and collaboration, and this tool increases the security and organisation of that process. 

# Usage
This code is a shell script and can be used within terminal. Alternatively follow this link https://repl.it/@GeorgiaRutherfo/ProofOfConcept to an executable environment.

To run the script type ' bash ProofOfConcept.sh (URL) (filename) ' where the (URL) is the url from which you want to save annotation information and the (filename) is the desired filename. Note that for useful analysis of the notes you will also need the stopwords.txt file. The stopwords.txt file can be updated to suit the users purposes.

# Result
The result of this code will be two files. One will be titled (filename).txt. This file will contain notes taken from hypothes.is formatted in such a way that is human readable. It will also contain a basic analysis of the notes. That is, it will show the most common words used in the user, uri, text, exact, and tags sections of the annotation information. This will allow the user to know at a glance who was involved in the note taking, where the notes are from and important themes. The other file will be titled (filename)-original.txt. This file will contain the original uncleaned annotaion information from the hypothes.is API. 
