// generics
type TReducer<A> = {
  init: (val: A) => void;
  update: (val: A) => void;
  finalize: () => A;
};

function StringConcatenator(): TReducer<string> {
  let _state = '';

  return {
    init: (val: string) => {
      _state = val;
    },
    update: (val: string) => {
      _state += val;
    },
    finalize: () => _state,
  };
}

let stringConcatenator = StringConcatenator();
stringConcatenator.init('1');
stringConcatenator.update('2');
stringConcatenator.update('3');

// '123'
let res = stringConcatenator.finalize();

export default null;
