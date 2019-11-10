# Install needed modules
npm install

# Generates optized JS
echo "Generate elm js"
elm make src/Main.elm --output /assets/elm.js --optimize

# Optimize further by uglyfying it with compress
echo "Uglify #1"
uglifyjs /assets/elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters=true,keep_fargs=false,unsafe_comps=true,unsafe=true,passes=2' --output=/assets/elm.js

# Uglify again with mangle so that pure funcs argument can be used
echo "Uglyfy #2"
uglifyjs /assets/elm.js --mangle --output=/assets/elm.js
