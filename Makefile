all:
	love ./

images:
	aseprite -b assets/dog.aseprite --save-as assets/dog-idle.png
	aseprite -b assets/exit.aseprite --save-as assets/exit.png

serve:
	rm -rf makelove-build
	makelove lovejs
	unzip -o "makelove-build/lovejs/sundog-lovejs" -d makelove-build/html/
	echo "http://localhost:8000/makelove-build/html/sundog/"
	python3 -m http.server
