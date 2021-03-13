const os = require('os');

// Token Group Definition

const tokenGroups = {
    T_IF: handleSymbol('if'),
    T_THEN: handleSymbol('then'),
    T_ELSE: handleSymbol('else'),
    T_IDENTIFIER: handleCharSet('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'),
    T_PARENTHESIS: handleCharSet('()'),
    T_NUMBER: handleCharSet('1234567890'),
    T_FN_DEFINE_ARROW: handleSymbol('=>'),
    T_FN_INVOKE_ARROW: handleSymbol('->'),
    T_OPERATOR: handleCharSet('=>+.?/!@#$%^&*|'),
    T_COMMA: handleCharSet(','),
    T_QUOTE: handleCharSet('"'),
    T_WHITESPACE: handleCharSet(' \t\f\r\n'),
    T_UNKNOWN: unknown,
};

function tokenise(input) {
  let inputPointer = {
    data: input,
    line: 1,
    column: 1,
    tokens: [],
  };
  while (inputPointer.data.length > 0) {
    for (const tokeniser in tokenGroups) {
      let token = makeToken(tokeniser, inputPointer);
      token = tokenGroups[tokeniser](inputPointer, token)
      if (token) {
        token.end = posMinusOne(inputPointer);
        inputPointer.tokens.push(token);
        break;
      }
    }
  }
  return inputPointer.tokens;
}

// inputPointer helpers

function pos(inputPointer) {
  return {
    line: inputPointer.line,
    column: inputPointer.column
  };
}

function posMinusOne(inputPointer) {
  const newPos = pos(inputPointer);
  return newPos.column === 1
    ? { line: newPos.line - 1, column: inputPointer.tokens[inputPointer.tokens.length - 1].end.column + 1 }
    : { line: newPos.line, column: newPos.column - 1 }
}

function makeToken(type, inputPointer) {
  return {
    type,
    value: '',
    start: pos(inputPointer)
  };
}

function peekChars(inputPointer, amount = 1) {
  return inputPointer.data.slice(0, amount);
}

function takeChars(inputPointer, amount = 1) {
  const chars = inputPointer.data.slice(0, amount);
  inputPointer.data = inputPointer.data.slice(amount);
  updatePointer(inputPointer, chars);
  return chars;
}

function updatePointer(inputPointer, removedChars) {
  for (const char of removedChars.split('')) {
    if (char === os.EOL) {
      inputPointer.line++;
      inputPointer.column = 1;
    } else {
      inputPointer.column++;
    }
  }
}

// Token Group Handlers

function handleCharSet(chars) {
  return (inputPointer, token) => {
    if (!chars.includes(inputPointer.data[0])) {
      return false;
    }
    while (chars.includes(inputPointer.data[0])) {
      token.value += takeChars(inputPointer);
    }
    return token;
  };
}

function handleSymbol(symbol) {
  return (inputPointer, token) => {
    let length = symbol.length;
    let test = peekChars(inputPointer, length);
    if (test !== symbol) {
      return false;
    }
    token.value += takeChars(inputPointer, length);
    return token;
  }
}

function unknown(inputPointer, token) {
  token.value += takeChars(inputPointer);
  return token;
}

module.exports = {
  tokenise
};