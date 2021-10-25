let alice: { name: string; age: number } = { name: 'alice', age: 21 }; // object type

alice.age = 22; // compiles
alice.age = '22'; // error, mismatched types
alice.age = undefined; // error, mismatched types
alice = { name: 'alice' }; // error, missing property

let bob: { name: string; age?: number } = { name: 'bob', age: 21 };

bob.age = '22'; // error, mismatched types
bob.age = undefined; // compiles
bob = { name: 'bob' }; // compiles

bob = alice; // compiles
alice = bob; // error, mismatched types

export default null;
