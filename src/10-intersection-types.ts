type TPerson = {
  name: string;
  age: number;
};

type TGenderedPerson = TPerson & {
  gender: string;
};

let bob: TGenderedPerson = { name: 'bob', age: 21, gender: 'm' }; // compiles
bob = { name: 'bob', age: 21 }; // error, missing property

// what's the result of this?
type Something = number & string;

export default null;
