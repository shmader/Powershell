#Opens the author.dotm file - User will need to click the Author tab in Word and click the settings icon in the Utilities group.

$Filename='C:\StartingPoint\StartingPoint_v5.6.1_IND\Templates\Author.dotm'

$Word=NEW-Object –comobject Word.Application

$Document=$Word.documents.open($Filename)

#Opens a template - User will have to then go to file > info > advanced options and click the dropdown for "Enable Content" > Advanced options
#and then click radio button for "Trust all documents from this publisher"

$Filename="C:\StartingPoint\StartingPoint_v5.6.1_IND\Templates\Module 1 US\1.2 Cover letter-Initial IND application.docx"

$Word=NEW-Object –comobject Word.Application

$Document=$Word.documents.open($Filename)