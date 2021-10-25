type TPerson = {
  name: string;
  age: number;
};

let alice: TPerson = { name: 'alice', age: 21 }; // compiles
alice = { name: 'alice' }; // error, missing age prop
alice = { name: 'alice', age: '21' }; // error, type mismatch for age prop

type TPerson2 = {
  name: string;
  age?: number;
};

let bob: TPerson2 = { name: 'bob', age: 21 }; // compiles
bob = { name: 'bob' }; // compiles
bob = { name: 'bob', age: '21' }; // error, type mismatch for age prop

export default null;
