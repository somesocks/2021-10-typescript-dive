
type TEmailAccount = {
  email: string;
  passwordHash: string;
};

type TFacebookAccount = {
  userId: string;
  authToken: string;
};

type TAccount = TEmailAccount | TFacebookAccount;

type TAccountType<A extends TAccount> =
	A extends TEmailAccount ? 'email' : A extends TFacebookAccount ? 'facebook' : never;


type TTaggedAccount<A extends TAccount> = A & { kind: TAccountType<A>; };

// works
let a : TTaggedAccount<TEmailAccount>;

// works
a = {
  kind: 'email',
  email: 'foo@bar.com',
  passwordHash: '12345678',
};

// compile error
a = {
  email: 'foo@bar.com',
  passwordHash: '12345678',
};

// compile error
a = {
  kind: 'facebook',
  email: 'foo@bar.com',
  passwordHash: '12345678',
};

export default null;
