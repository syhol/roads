const os = require('os');

// Token Group Definition

const tokenGroups = {
    // T_IF: handleSymbol('if'),
    // T_THEN: handleSymbol('then'),
    // T_ELSE: handleSymbol('else'),
    // T_IDENTIFIER: handleCharSet('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'),
    T_STRING: handleString,
    T_TAG: handleRegex(/^((?:[A-Z][a-z0-9]+)(?:(?:\d)|(?:[A-Z0-9][a-z0-9]+))*(?:[A-Z])?)/),
    T_KEY: handleRegex(/^((?:[A-Za-z_][A-Za-z0-9_]*|".+"|'.+')(?:\.(?:[A-Za-z_][A-Za-z0-9_]*|".+"|'.+'))*(?:\[\])?)/),
    // T_PARENTHESIS: handleCharSet('()'),
    T_SQUARE_PARENTHESIS_OPEN: handleSymbol('['),
    T_SQUARE_PARENTHESIS_CLOSE: handleSymbol(']'),
    T_CURLY_PARENTHESIS_OPEN: handleSymbol('{'),
    T_CURLY_PARENTHESIS_CLOSE: handleSymbol('}'),
    // T_NUMBER: handleCharSet('1234567890'),
    // T_FN_DEFINE_ARROW: handleSymbol('=>'),
    // T_FN_INVOKE_ARROW: handleSymbol('->'),
    T_DOUBLE_SLASH_COMMENT: handleRegex(/^(\/\/).*/),
    T_NUMBER_SIGN_COMMENT: handleRegex(/^(\#).*/),
    T_ASSIGNMENT: handleSymbol('='),
    T_COMMA: handleSymbol(','),
    T_WHITESPACE: handleCharSet(' \t\f\r\n'),
    T_UNKNOWN: unknown,
};

function tokenise(input) {
  let inputPointer = {
    data: input,
    line: 0,
    character: 0,
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

function posMinusOne(inputPointer) {
  return inputPointer.character === 0
    ? { line: inputPointer.line - 1, character: inputPointer.tokens[inputPointer.tokens.length - 1].end.character + 1 }
    : { line: inputPointer.line, character: inputPointer.character - 1 }
}

function makeToken(type, inputPointer) {
  return {
    type,
    value: '',
    start: { line: inputPointer.line, character: inputPointer.character }
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
      inputPointer.character = 0;
    } else {
      inputPointer.character++;
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

function handleRegex(regex) {
  return (inputPointer, token) => {
    const result = inputPointer.data.match(regex);
    if (!result) {
      return false;
    }
    token.value += takeChars(inputPointer, result[0].length);
    return token;
  }
}

function handleString(inputPointer, token) {
  let test = peekChars(inputPointer);
  if (test !== '"') {
    return false;
  }
  token.value += takeChars(inputPointer);
  let isEscaping = false;
  while ((peekChars(inputPointer) !== '"' || isEscaping) && inputPointer.data.length > 0) {
    const next = takeChars(inputPointer);
    isEscaping = (next === '\\' && !isEscaping);
    token.value += next;
  }
  token.value += takeChars(inputPointer);
  return token;
}

function unknown(inputPointer, token) {
  const lastToken = inputPointer.tokens[inputPointer.tokens.length - 1];
  if (lastToken.type === 'T_UNKNOWN') {
    lastToken.value += takeChars(inputPointer);
    return false;
  }
  token.value += takeChars(inputPointer);
  return token;
}

function prettyTokens(tokens) {
  for (token of tokens) {
    const value = token.value
      .replace(/\n/g,'\\n')
      .replace(/\t/g,'\\t')
      .replace(/\f/g,'\\f')
      .replace(/\r/g,'\\r')
    console.log(token.type.padStart(27), `|${value}|`);
  }
}

module.exports = {
  tokenise,
  prettyTokens,
};