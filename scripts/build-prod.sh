
# Generates optized JS
echo "Generate elm js"
elm make src/Main.elm --output elm.js --optimize

# Optimize further by uglyfying it with compress
echo "Uglify #1"
uglifyjs elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters=true,keep_fargs=false,unsafe_comps=true,unsafe=true,passes=2' --output=elm.js

# Uglify again with mangle so that pure funcs argument can be used
echo "Uglyfy #2"
uglifyjs elm.js --mangle --output=elm.js
