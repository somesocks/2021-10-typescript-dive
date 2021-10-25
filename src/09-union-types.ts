type TAgedPerson = {
  name: string;
  age: number;
};

type TGenderedPerson = {
  name: string;
  gender: string;
};

type TPerson = TAgedPerson | TGenderedPerson;

let alice: TPerson;

alice = { name: 'alice', age: 21 }; // compiles
alice = { name: 'alice', gender: 'f' }; // compiles

alice = { name: 'alice', age: 21, gender: 'f' }; // compiles, but maybe shouldnt?
alice = { name: 'alice', age: undefined, gender: 'f' }; // compiles, but maybe shouldnt?

alice = { name: 'alice', age: null, gender: 'f' }; // error
alice = { name: 'alice', age: undefined, gender: undefined }; // error



type bit = 0 | 1;

let num : bit;

num = 0; // works
num = 1; // works
num = 2; // error




type TEmailAccount = {
  kind: 'email';
  user: string;
  passwordHash: string;
};

type TFacebookAccount = {
  kind: 'facebook';
  user: string;
  authToken: string;
};

type TAccount = TEmailAccount | TFacebookAccount;

// compiler error
let account: TAccount = {
  kind: 'email',
  user: 'fb-1234',
  authToken: '5678',
};
// compiler error
let account2: TAccount = {
  kind: 'facebook',
  user: 'fb-1234',
  passwordHash: '1234',
  authToken: '5678',
};

export default null;
