const fs = require('fs');
const { tokenise, prettyTokens } = require('./tokeniser');
// const { generateCST } = require('./cst');

async function run(input) {
    // console.log('Processing\n', input);
    const tokens = tokenise(input);
    prettyTokens(tokens);
    // const syntaxTree = generateCST(tokens);
    // console.log(syntaxTree);
}

run(fs.readFileSync('/dev/stdin').toString());
