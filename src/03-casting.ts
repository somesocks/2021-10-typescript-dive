let a: number = 1; // compiles

// note: newer versions of TS will complain about: ``"2" as number`,
// so now you have to cast to a "broader" type first: `"2" as any as number`
a = '2' as number; // compiles, but a lie

a = '2' as any as number; // compiles, but a lie

export default null;
