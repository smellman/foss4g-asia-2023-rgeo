SRC = foss4g-asia-2023-rgeo.md
HTML = $(SRC:%.md=%.html)
PDF = $(SRC:%.md=%.pdf)
PPTX = $(SRC:%.md=%.pptx)

all: html pdf pptx

html: $(SRC)
	npx -y @marp-team/marp-cli@latest $(SRC) -o $(HTML)

pdf: $(SRC)
	npx -y @marp-team/marp-cli@latest $(SRC) -o $(PDF)

pptx: $(SRC)
	npx -y @marp-team/marp-cli@latest $(SRC) -o $(PPTX)