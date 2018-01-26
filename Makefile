MAPBOX_GL_JS_VERSION=0.43.0

install: install-server install-client install-mapbox-gl-js
uninstall: uninstall-server uninstall-client uninstall-client-dependencies

open: install
	open http://127.0.0.1:8889

server-run: install
	cd source/server && cargo run

clean: uninstall
.PHONY: clean

###
# Server
###

install-server:
	cd source/server && cargo build --release

uninstall-server:
	rm -rf source/server/Cargo.lock source/server/target

###
# Client
###

install-client: public/static/index.html public/static/javascript/application.elm.js install-client-dependencies
public/static/index.html:
	cp source/client/index.html public/static/index.html
	sed -i '' "s@{MAP-PLACEHOLDER.svg}@`cat public/static/image/map-placeholder.svg | sed -E 's/^ +//g; s/"/'"'"'/g; s/</%3c/g; s/>/%3e/g; s/\#/%23/g' | tr -d "\n"`@" public/static/index.html
public/static/javascript/application.elm.js:
	elm-make source/client/Main.elm --output public/static/javascript/application.elm.js

uninstall-client:
	rm -f public/static/index.html
	rm -f public/static/javascript/application.elm.js

###
# Client dependencies
###

install-client-dependencies: install-mapbox-gl-js
uninstall-client-dependencies: uninstall-mapbox-gl-js

###
# Client dependencies: Mapbox GL JS
###

install-mapbox-gl-js: install-mapbox-gl-js-js install-mapbox-gl-js-css

install-mapbox-gl-js-js: public/static/javascript/mapbox-gl.js public/static/javascript/mapbox-gl.js.map
public/static/javascript/mapbox-gl.js:
	curl -L https://api.tiles.mapbox.com/mapbox-gl-js/v$(MAPBOX_GL_JS_VERSION)/mapbox-gl.js > public/static/javascript/mapbox-gl.js
public/static/javascript/mapbox-gl.js.map:
	curl -L https://api.tiles.mapbox.com/mapbox-gl-js/v$(MAPBOX_GL_JS_VERSION)/mapbox-gl.js.map > public/static/javascript/mapbox-gl.js.map

install-mapbox-gl-js-css: public/static/css/mapbox-gl.css
public/static/css/mapbox-gl.css:
	curl -L https://api.tiles.mapbox.com/mapbox-gl-js/v$(MAPBOX_GL_JS_VERSION)/mapbox-gl.css > public/static/css/mapbox-gl.css

uninstall-mapbox-gl-js:
	rm public/static/javascript/mapbox-gl.js
	rm public/static/javascript/mapbox-gl.js.map
	rm public/static/css/mapbox-gl.css
