const fs = require('fs');
const { tokenise } = require('./tokeniser');
const { generateCST } = require('./cst');

async function run(input) {
    const tokens = tokenise(input);
    console.log(tokens);
    const syntaxTree = generateCST(tokens);
    console.log(syntaxTree);
}

run(fs.readFileSync('/dev/stdin').toString());
