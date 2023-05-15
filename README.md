# Identify Lego Star Wars Set
Identify which Lego Star Wars set your random pieces belong to:
[Link to R Shiny App](https://mtwtn7.shinyapps.io/LegoStarWarsSetIdentifier/)

[Link to determine piece number](https://www.bricklink.com/catalogTree.asp?itemType=P)

[Link to deterine piece color](https://brickipedia.fandom.com/wiki/Colour_Palette)


# Files
- allLSWpieces.csv: contains a row for every Lego Piece in every (numbered) Lego Star Wars Set
- allSets.py: python code used to create allLSWpieces.csv and legoSW.csv
- app.R: R shiny app which can be used to enter piece number and color for up to 3 pieces and returns common set(s) for those piece(s)
- legoSW.csv: contains set number and set name for every Lego Star Wars Set 
