type TPerson = { name: string };
type TAgedPerson = TPerson & { age: number };
type TGenderedPerson = TPerson & { gender: string };

type TPeople<A extends TPerson = TPerson> = A[];

let input = [
  { name: 'alice', age: 21 },
  { name: 'bob', age: 21 },
];

// this works
let people: TPeople = input;

// this works
let agedPeople: TPeople<TAgedPerson> = input;

// this fails
let genderedPeople: TPeople<TGenderedPerson> = input;

export default null;
