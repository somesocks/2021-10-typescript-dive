// WARNING: this package is a controlled file generated from a template
// do not try to make changes in here, they will be overwritten

// if you want to customize eslint for this package, 
// add rules to this extras file instead
const extras = require('./.eslintrc.extras.js');

module.exports = {
	parser: '@typescript-eslint/parser',
	parserOptions: {
		project: require.resolve('./tsconfig.json'),
	},
	plugins: [
		'@typescript-eslint/eslint-plugin',
		...(extras.plugins || [])
	],
	extends: [
		'eslint:recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:@typescript-eslint/recommended-requiring-type-checking',
		...(extras.extends || [])
	],
	rules: {
		...(extras.rules || {})
	},
};
