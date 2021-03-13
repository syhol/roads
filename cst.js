
function generateCST(tokens) {
  const program = [];
  while(tokens.length > 0) {
    for (const token of tokens) {
      if (token.type === 'T_FN_DEFINE_ARROW') {
        program.push(parseFunction(tokens));
        break;
      } else if (token.type === 'T_OPERATOR' && token.value === '=') {
        program.push(parseAssignment(tokens));
        break;
      }
    }
  }
  return program;
}

function parseFunction(tokens) {
  return {
    type: 'function',
    name: parseFunctionName(tokens),
    arguments: parseFunctionArguments(tokens),
    operator: parseFunctionOperator(tokens),
    body: parseFunctionBody(tokens),
  };
}

function clearWhitespace(tokens) {
  clearTokens(tokens, 'T_WHITESPACE');
}

function parseFunctionName(tokens) {
  clearWhitespace(tokens);
  expectToken(tokens, 'T_IDENTIFIER');
  return tokens.shift();
}

function parseFunctionArguments(tokens) {
  clearWhitespace(tokens);
  expectToken(tokens, 'T_PARENTHESIS', '(');
  tokens.shift(); // Remove open paren
  clearWhitespace(tokens);
  const args = [];
  while(tokens[0].type !== 'T_PARENTHESIS' && tokens[0].value !== ')') {
    expectToken(tokens, 'T_IDENTIFIER');
    args.push(tokens.shift());
    clearWhitespace(tokens);
    clearTokens('T_COMMA');
    clearWhitespace(tokens);
  }
  expectToken(tokens, 'T_PARENTHESIS', ')');
  tokens.shift(); // Remove closing parenth
  return args;
}

function parseFunctionOperator(tokens) {

}

function parseFunctionBody(tokens) {

}

function clearTokens(tokens, type) {
  while (tokens[0].type === type) {
    tokens.shift();
  }
}

function expectToken(tokens, type, value) {
  if (tokens[0].type !== type) {
    const error = new Error(`Unexpected ${tokens[0].type}, expecting ${type}`);
    error.token = token[0];
    throw error;
  }
  if (typeof value !== 'undefined' && tokens[0].value !== value) {
    const error = new Error(`Unexpected value ${tokens[0].value}, expecting ${value}`);
    error.token = tokens[0];
    throw error;
  }
  return true;
}

function parseAssignment(tokens) {
  return {
    type: 'assignment',
    name: '',
    body: ''
  };
}

module.exports = {
  generateCST
};
