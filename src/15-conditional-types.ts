type TPerson = { name: string };
type TAgedPerson = TPerson & { age: number };
type TGenderedPerson = TPerson & { gender: string };

type TPersonType<A extends TPerson> = A extends TGenderedPerson
  ? 'gendered'
  : A extends TAgedPerson
  ? 'aged'
  : 'person';

type TPersonWrapper<A extends TPerson> = {
  kind: TPersonType<A>;
  person: A;
};

// works
let a: TPersonWrapper<TAgedPerson> = {
  kind: 'aged',
  person: { name: 'alice', age: 21 },
};

// compile error
let b: TPersonWrapper<TAgedPerson> = {
  kind: 'aged',
  person: { name: 'alice', gender: 'f' },
};

export default null;
