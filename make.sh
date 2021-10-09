# The order of finding & replacing cannot be changed arbitrarily!

# I define the contextual citation as `A conclusion was obtained by @stern2020`, which is like ([@stern2020](((LGOJZKLWM)))) in Roam Research.
# And the bare citation as `[@dogaru2009] asserted that mining industry has negative impacts on the environment`, which is like [@dogaru2009](((gqFy2edpC))).

# Bear in mind that exported Flat Markdown:
# 1. Use the hashtag instead of the alias page references
# 2. The alt text of block references is the citekey

# Turn italics syntax __ to * 
perl -i -p -e 's/(__)(.*?)(__)/\*\2\*/g' *.md

# Remove something like {{word-count}}
perl -i -p -e 's/ \{\{.*\}\}//g' *.md

# Remove the hashtag
perl -i -p -e 's/\s#\[\[.*?\]\]//g' *.md
perl -i -p -e 's/\s#\S+//g' *.md

# Remove block references alias with *
perl -i -p -e 's/\s\[\*\]\({3}\S*\){3}//g' *.md

# Clean block references
perl -i -p -e 's/(\[)(@[a-z0-9\-]*)(\])\({3}[\w\-]*\){3}/[[\2]]/g' *.md

# Clean bare citation
perl -i -p -e 's/(\(\[)(\[@.*?)(\]\))/\2/g' *.md

# Handle multiple citekeys at the same location
perl -i -p -e 's/(\]\])(;\s)(\[\[)(@)/\2\4/g' *.md

# Clean page references, including contextual citation
perl -i -p -e 's/(\[\[)(.*?)(\]\])/\2/g' *.md

# Generate `input.tex` via pandoc
pandoc -F pandoc-crossref --biblatex \
--wrap=none input.md \
-f markdown+smart+autolink_bare_uris \
-t latex -o input.tex

# Generate `main.pdf` via latexmk
latexmk -xelatex main.tex -quiet

# Rename `main.pdf` to `in-defense-of-private-offices.pdf`
mv main.pdf in-defense-of-private-offices.pdf

# Remove auxiliary files
latexmk -c
rm *.bbl *.xml *.xdv input.tex
